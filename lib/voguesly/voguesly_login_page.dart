import 'dart:async';
import 'package:fl_clash/common/app_localizations.dart';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'voguesly_auth.dart';

// Google 官方四色 G(彩色,比单色 g_mobiledata 明显)。
const String _kGoogleG =
    '<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">'
    '<path fill="#4285F4" d="M45.12 24.5c0-1.56-.14-3.06-.4-4.5H24v8.51h11.84c-.51 2.75-2.06 5.08-4.39 6.64v5.52h7.11c4.16-3.83 6.56-9.47 6.56-16.17z"/>'
    '<path fill="#34A853" d="M24 46c5.94 0 10.92-1.97 14.56-5.33l-7.11-5.52c-1.97 1.32-4.49 2.1-7.45 2.1-5.73 0-10.58-3.87-12.31-9.07H4.34v5.7C7.96 41.07 15.4 46 24 46z"/>'
    '<path fill="#FBBC05" d="M11.69 28.18C11.25 26.86 11 25.45 11 24s.25-2.86.69-4.18v-5.7H4.34C2.85 17.09 2 20.45 2 24s.85 6.91 2.34 9.88l7.35-5.7z"/>'
    '<path fill="#EA4335" d="M24 10.75c3.23 0 6.13 1.11 8.41 3.29l6.31-6.31C34.91 4.18 29.93 2 24 2 15.4 2 7.96 6.93 4.34 14.12l7.35 5.7c1.73-5.2 6.58-9.07 12.31-9.07z"/>'
    '</svg>';

const _kRememberEmailKey = 'voguesly_remember_email';

/// 桌面 Google 登录回调后,浏览器落地页(提示返回 App,并尝试自动关标签)。
String get _kDesktopLandingHtml =>
    '<!DOCTYPE html><html lang="zh"><head><meta charset="utf-8">'
    '<meta name="viewport" content="width=device-width, initial-scale=1">'
    '<title>Voguesly</title></head>'
    '<body style="font-family:-apple-system,Segoe UI,Roboto,sans-serif;'
    'background:#0B0B12;color:#fff;display:flex;align-items:center;'
    'justify-content:center;height:100vh;margin:0;text-align:center">'
    '${currentAppLocalizations.vgOauthSuccessHtmlHead}'
    '${currentAppLocalizations.vgOauthSuccessHtmlBody}'
    '<script>setTimeout(function(){window.close();},1200);</script>'
    '</body></html>';

class VogueslyLoginPage extends ConsumerStatefulWidget {
  const VogueslyLoginPage({super.key});

  @override
  ConsumerState<VogueslyLoginPage> createState() => _VogueslyLoginPageState();
}

class _VogueslyLoginPageState extends ConsumerState<VogueslyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _inviteCode = TextEditingController();
  final _emailCode = TextEditingController();
  bool _obscure = true;
  bool _registerMode = false;
  bool _remember = true;
  int _codeCooldown = 0;
  Timer? _codeTimer;

  @override
  void initState() {
    super.initState();
    _loadRemembered();
  }

  Future<void> _loadRemembered() async {
    final p = await SharedPreferences.getInstance();
    final saved = p.getString(_kRememberEmailKey);
    if (saved != null && saved.isNotEmpty && mounted) {
      setState(() => _email.text = saved);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _inviteCode.dispose();
    _emailCode.dispose();
    _codeTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_email.text.contains('@')) {
      _toast(currentAppLocalizations.vgEnterValidEmailFirst);
      return;
    }
    final ok =
        await ref.read(vogueslyAuthProvider.notifier).sendEmailVerify(_email.text);
    if (!mounted) return;
    _toast(ok ? currentAppLocalizations.vgCodeSent : currentAppLocalizations.vgSendFailedRetry);
    if (ok) {
      setState(() => _codeCooldown = 60);
      _codeTimer?.cancel();
      _codeTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted || _codeCooldown <= 0) {
          t.cancel();
          return;
        }
        setState(() => _codeCooldown--);
      });
    }
  }

  /// 离线预检:无网络时直接提示,唔好发请求等满 4 host × 8s 超时(最坏 32s)令用户以为卡死。
  Future<bool> _offlineGuard() async {
    final res = await Connectivity().checkConnectivity();
    if (res.contains(ConnectivityResult.none) || res.isEmpty) {
      if (mounted) _toast(currentAppLocalizations.vgNetworkUnavailableRetry);
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    if (await _offlineGuard()) return;
    final notifier = ref.read(vogueslyAuthProvider.notifier);
    final ok = _registerMode
        ? await notifier.register(
            _email.text, _password.text, _inviteCode.text, _emailCode.text)
        : await notifier.login(_email.text, _password.text);
    if (!mounted) return;
    if (ok) {
      final p = await SharedPreferences.getInstance();
      if (_remember) {
        await p.setString(_kRememberEmailKey, _email.text.trim());
      } else {
        await p.remove(_kRememberEmailKey);
      }
    } else {
      final err = ref.read(vogueslyAuthProvider).error ??
          (_registerMode ? currentAppLocalizations.vgSignUpFailed : currentAppLocalizations.vgSignInFailed);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _googleLogin() async {
    if (await _offlineGuard()) return;
    // ⚠️Windows/Linux 闪退根因:flutter_web_auth_2 喺桌面用内置 loopback server 实现
    // (src/server.dart),硬性只认 http://127.0.0.1:{port} 回调,传自定义 scheme 'voguesly'
    // 会喺入口校验抛错。故桌面改行自建 loopback server;macOS/iOS/Android 保留原生
    // ASWebAuthenticationSession/Custom Tab(自定义 scheme 正常,唔改)。
    final isDesktop = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);
    try {
      final String result;
      if (isDesktop) {
        result = await _desktopWebAuth();
      } else {
        result = await FlutterWebAuth2.authenticate(
          // 迁现役 qzz.io(后端已支持动态 redirect_uri,GCP 已加 qzz.io callback):
          // 唔再经污染嘅 voguesly.com,China 用户 Google 登录唔会再卡超时。
          url:
              'https://ylink.im/api/v2/passport/auth/google?redirect=voguesly://auth',
          callbackUrlScheme: 'voguesly',
        );
      }
      final authData = Uri.parse(result).queryParameters['auth_data'];
      if (authData == null || authData.isEmpty) {
        if (mounted) _toast(currentAppLocalizations.vgGoogleSignInFailedRetry);
        return;
      }
      final ok =
          await ref.read(vogueslyAuthProvider.notifier).loginWithToken(authData);
      if (!ok && mounted) {
        // loginWithToken 喺 401/403 会置 state.error='登录已失效…' 并返 false。
        _toast(ref.read(vogueslyAuthProvider).error ?? currentAppLocalizations.vgGoogleSignInFailedRetry);
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      // flutter_web_auth_2:用户取消回 CANCELED;浏览器空返回/异常回 FAILED。
      // 两者都系用户放弃,静默唔弹 toast(同 Google/Apple 登录面板取消一致,唔误导)。
      // 只有 NO_BROWSER 及其它真错误(网络/配置)先弹失败提示。
      if (e.code == 'CANCELED' || e.code == 'FAILED') return;
      _toast(currentAppLocalizations.vgGoogleSignInFailedNetwork);
    } catch (e) {
      if (!mounted) return;
      // 非 PlatformException 兜底:含 cancel 静默,否则弹通用失败。
      if (e.toString().toLowerCase().contains('cancel')) return;
      _toast(currentAppLocalizations.vgGoogleSignInFailedNetwork);
    }
  }

  /// 桌面(Windows/Linux)Google 登录:自建 127.0.0.1 loopback server 收 OAuth 回调。
  /// 系统默认浏览器打开 web OAuth(externalApplication)→ 后端认证完 302 返
  /// http://127.0.0.1:{port}/?auth_data=… → 本地 server 捕获首个请求攞 auth_data。
  /// 全程 try/finally 关 server,唔会崩;返完整回调 URL 畀上层解析。
  Future<String> _desktopWebAuth() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    try {
      final redirect = 'http://127.0.0.1:${server.port}/';
      final authUrl = 'https://ylink.im/api/v2/passport/auth/google'
          '?redirect=${Uri.encodeComponent(redirect)}';
      final launched = await launchUrl(
        Uri.parse(authUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw PlatformException(code: 'FAILED', message: currentAppLocalizations.vgCannotOpenBrowser);
      }
      // 等浏览器带 auth_data 打返嚟(5 分钟够完成 Google 授权);超时抛 TimeoutException → 兜底 toast。
      final req = await server.first.timeout(const Duration(minutes: 5));
      final full = req.requestedUri.toString();
      req.response
        ..statusCode = 200
        ..headers.contentType = ContentType.html
        ..write(_kDesktopLandingHtml);
      await req.response.close();
      return full;
    } finally {
      await server.close(force: true);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final loading = ref.watch(
      vogueslyAuthProvider
          .select((s) => s.status == VogueslyAuthStatus.loggingIn),
    );
    // 后台开关:邮箱验证码 / 人机验证。关时全 false,唔显示额外位。
    final config = ref.watch(vogueslyClientConfigProvider).asData?.value;
    final showEmailCode = _registerMode && (config?.isEmailVerify ?? false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/icon.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _registerMode ? currentAppLocalizations.vgCreateAccount : currentAppLocalizations.vgSignInAccount,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _registerMode ? currentAppLocalizations.vgSignUpAutoConnect : currentAppLocalizations.vgEnterCredentials,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 28),
                    _label(currentAppLocalizations.vgEmail, required: true),
                    _field(
                      controller: _email,
                      hint: 'name@email.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !loading,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? currentAppLocalizations.vgEnterValidEmail : null,
                    ),
                    if (showEmailCode) ...[
                      const SizedBox(height: 14),
                      _label(currentAppLocalizations.vgEmailCode, required: true),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _field(
                              controller: _emailCode,
                              hint: currentAppLocalizations.vgSixDigitCode,
                              icon: Icons.mail_lock_outlined,
                              keyboardType: TextInputType.number,
                              enabled: !loading,
                              validator: (v) => (showEmailCode &&
                                      (v == null || v.trim().isEmpty))
                                  ? currentAppLocalizations.vgEnterCode
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: (loading || _codeCooldown > 0)
                                  ? null
                                  : _sendCode,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                  _codeCooldown > 0 ? '${_codeCooldown}s' : currentAppLocalizations.vgSend),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    _label(currentAppLocalizations.vgPassword, required: true),
                    _field(
                      controller: _password,
                      hint: currentAppLocalizations.vgEnterPassword,
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      enabled: !loading,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? currentAppLocalizations.vgEnterPassword : null,
                      onSubmitted: (_) => _submit(),
                    ),
                    if (_registerMode) ...[
                      const SizedBox(height: 14),
                      _label(currentAppLocalizations.vgReferralCodeOptional),
                      _field(
                        controller: _inviteCode,
                        hint: currentAppLocalizations.vgReferralCodeDiscount,
                        icon: Icons.card_giftcard_outlined,
                        enabled: !loading,
                        onSubmitted: (_) => _submit(),
                      ),
                    ],
                    if (!_registerMode) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: loading
                                ? null
                                : () => setState(() => _remember = !_remember),
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _remember
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: 18,
                                    color: _remember
                                        ? cs.primary
                                        : cs.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(currentAppLocalizations.vgRememberMe,
                                      style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: loading
                                ? null
                                // 开现役面板(ylink.im),唔好再叫用户去弃用+被污染嘅 voguesly.com。
                                : () => launchUrl(
                                      Uri.parse('https://ylink.im'),
                                      mode: LaunchMode.externalApplication,
                                    ),
                            child: Text(currentAppLocalizations.vgForgotPassword),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_registerMode ? currentAppLocalizations.vgSignUp : currentAppLocalizations.vgSignIn),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                    ),
                    // Google 登录/注册(登录同注册都提供)。
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(currentAppLocalizations.vgOr,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: loading ? null : _googleLogin,
                      icon: SvgPicture.string(_kGoogleG, width: 20, height: 20),
                      label: Text(_registerMode ? currentAppLocalizations.vgSignUpWithGoogle : currentAppLocalizations.vgSignInWithGoogle),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _registerMode ? currentAppLocalizations.vgAlreadyHaveAccount : currentAppLocalizations.vgNoAccountYet,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: loading
                          ? null
                          : () => setState(() => _registerMode = !_registerMode),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(_registerMode ? currentAppLocalizations.vgGoSignIn : currentAppLocalizations.vgCreateAccount),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Row(
        children: [
          Text(text, style: theme.textTheme.bodySmall),
          if (required)
            Text(' *', style: TextStyle(color: theme.colorScheme.error)),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool enabled = true,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
  }) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      keyboardType: keyboardType,
      autocorrect: false,
      textInputAction:
          onSubmitted != null ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
      ),
      validator: validator,
      onFieldSubmitted: onSubmitted,
    );
  }
}
