import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart' as ww;

import 'voguesly_api.dart' show kVogueslyHosts;

/// 易联 app 內嵌 Turnstile 人机验证(2026-09-18 Sam 拍板)。
///
/// 背景:之前注册 / 发邮箱码走「逃生口免验证码」—— 任何免验证码入口一公开
/// 就即刻被 bot 食(09-18 开咗 5 分钟就入咗两个 bot)。改成同网页一样过 Turnstile:
/// webview 载入我哋自己 host 上嘅 `/yl/captcha.html?k=<sitekey>`,页面 render CF widget
/// (non-interactive,正常 1-3 秒自动通过),拿到 token 经 JS channel 回传,
/// 再随 register / sendEmailVerify 请求以 `turnstile_token` 送畀 XBoard。
///
/// 平台:Android / macOS = webview_flutter;Windows = webview_windows(同客服面板一致);
/// Linux / web 无 in-app webview → 返 null(调用方提示)。
///
/// 返回 token;用户取消或验证服务不可用 → null。
Future<String?> showVogueslyCaptcha(
  BuildContext context, {
  required String siteKey,
}) {
  if (kIsWeb || Platform.isLinux) return Future.value(null);
  final dark = Theme.of(context).brightness == Brightness.dark;
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _VogueslyCaptchaDialog(siteKey: siteKey, dark: dark),
  );
}

bool get _useWindowsWebview => !kIsWeb && Platform.isWindows;

class _VogueslyCaptchaDialog extends StatefulWidget {
  const _VogueslyCaptchaDialog({required this.siteKey, required this.dark});

  final String siteKey;
  final bool dark;

  @override
  State<_VogueslyCaptchaDialog> createState() => _VogueslyCaptchaDialogState();
}

class _VogueslyCaptchaDialogState extends State<_VogueslyCaptchaDialog> {
  WebViewController? _ctrl;
  ww.WebviewController? _win;
  bool _winReady = false;
  int _hostIdx = 0;
  bool _done = false;
  bool _failed = false; // 全部 host 都载唔到页(唔係 Turnstile 本身失败,页内有自己嘅重试)

  Uri _pageUri(int idx) =>
      Uri.parse('${kVogueslyHosts[idx]}/yl/captcha.html').replace(
        queryParameters: {
          'k': widget.siteKey,
          't': widget.dark ? 'dark' : 'light',
        },
      );

  @override
  void initState() {
    super.initState();
    if (_useWindowsWebview) {
      _initWindows();
    } else {
      _initFlutterWebview();
    }
  }

  void _initFlutterWebview() {
    try {
      _ctrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..addJavaScriptChannel('VogueslyCaptcha', onMessageReceived: (m) {
          _onMessage(m.message);
        })
        ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (e) {
            // 只对主文档载入失败换下一个 host;widget 内部资源错误由页面自己处理
            if (e.isForMainFrame ?? true) _nextHost();
          },
        ))
        ..loadRequest(_pageUri(0));
    } catch (_) {
      _ctrl = null;
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _initWindows() async {
    try {
      final c = ww.WebviewController();
      await c.initialize();
      c.webMessage.listen((message) {
        _onMessage(message is String ? message : jsonEncode(message));
      });
      c.onLoadError.listen((_) => _nextHost());
      await c.loadUrl(_pageUri(0).toString());
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() {
        _win = c;
        _winReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  /// 页面回传 JSON:{"kind":"token","value":"…"} / {"kind":"error","value":"…"}。
  /// error 由页面自己显示 + 提供重试,呢度只处理 token。
  void _onMessage(String raw) {
    if (_done) return;
    String? token;
    try {
      final j = jsonDecode(raw);
      if (j is Map && j['kind'] == 'token') token = j['value']?.toString();
    } catch (_) {
      // 兼容页面直接送裸 token 嘅情况
      if (raw.length > 20 && !raw.startsWith('{')) token = raw;
    }
    if (token == null || token.isEmpty) return;
    _done = true;
    if (mounted) Navigator.of(context).pop(token);
  }

  void _nextHost() {
    if (_done || !mounted) return;
    final next = _hostIdx + 1;
    if (next >= kVogueslyHosts.length) {
      setState(() => _failed = true);
      return;
    }
    _hostIdx = next;
    final uri = _pageUri(next);
    if (_useWindowsWebview) {
      _win?.loadUrl(uri.toString());
    } else {
      _ctrl?.loadRequest(uri);
    }
  }

  void _retryAll() {
    setState(() => _failed = false);
    _hostIdx = 0;
    final uri = _pageUri(0);
    if (_useWindowsWebview) {
      if (_win == null) {
        _initWindows();
      } else {
        _win!.loadUrl(uri.toString());
      }
    } else {
      if (_ctrl == null) {
        _initFlutterWebview();
      } else {
        _ctrl!.loadRequest(uri);
      }
    }
  }

  @override
  void dispose() {
    _win?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = currentAppLocalizations;
    Widget body;
    if (_failed) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.vgCaptchaUnavailable,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            FilledButton.tonal(onPressed: _retryAll, child: Text(l.vgRetry)),
          ],
        ),
      );
    } else if (_useWindowsWebview) {
      body = _winReady && _win != null
          ? ww.Webview(_win!)
          : const Center(child: CircularProgressIndicator(strokeWidth: 2));
    } else {
      body = _ctrl != null
          ? WebViewWidget(controller: _ctrl!)
          : const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.vgCaptchaTitle,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    tooltip: l.vgCancel,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(height: 150, child: body),
            ],
          ),
        ),
      ),
    );
  }
}
