import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_pay_icons.dart';

/// 易联 · 共享支付流程(商城下单 + 我的订单「继续支付」共用)。
/// 选支付方式(余额 + 品牌图标方式)→ checkout →
///   余额直扣 / 桌面二维码 App 内画 / 跳转型外部浏览器 → 轮询到账 → onPaid。
class VogueslyPayment {
  /// 对已存在订单(tradeNo)发起支付。priceCents=订单金额;title=展示行。
  static Future<void> present({
    required BuildContext context,
    required WidgetRef ref,
    required String tradeNo,
    required int priceCents,
    required String title,
    Future<void> Function()? onPaid,
  }) async {
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final api = ref.read(vogueslyApiProvider);
    final methods = await api.fetchPaymentMethods(token);
    final balance = await api.fetchBalanceCents(token) ?? 0;
    if (!context.mounted) return;
    _showSheet(context, ref, tradeNo, priceCents, title, balance, methods, onPaid);
  }

  static void _showSheet(
    BuildContext context,
    WidgetRef ref,
    String tradeNo,
    int priceCents,
    String title,
    int balanceCents,
    List<VogueslyPayMethod> methods,
    Future<void> Function()? onPaid,
  ) {
    final cs = Theme.of(context).colorScheme;
    final enough = balanceCents >= priceCents;
    final balanceText = '¥${(balanceCents / 100).toStringAsFixed(2)}';
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('选择支付方式',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: Theme.of(ctx).textTheme.bodyMedium),
              Text('当前余额:$balanceText',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7))),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _payTile(
                        ctx,
                        label: enough ? '余额支付' : '余额不足',
                        enabled: enough,
                        onTap: enough
                            ? () => _checkout(ctx, ref, tradeNo, 0,
                                isBalance: true, onPaid: onPaid)
                            : null,
                      ),
                      ...methods.map((m) => _payTile(
                            ctx,
                            label: m.name,
                            iconUrl: m.icon,
                            enabled: true,
                            onTap: () => _checkout(ctx, ref, tradeNo, m.id,
                                onPaid: onPaid),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('取消'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 优先用面板下发嘅**官方图标**(m.icon:simpleicons SVG URL / wikimedia .svg / data-uri;
  // 同网页前端一样);加载失败(如国内 CDN 不通)fallback 到内联手绘品牌图标;再冇就通用 icon。
  static Widget _payLeading(String label, String? iconUrl, Color fg) {
    if (label.contains('余额')) {
      return Icon(Icons.account_balance_wallet, color: fg, size: 24);
    }
    final fallbackSvg = payIconSvg(label);
    Widget fallback() => fallbackSvg != null
        ? SvgPicture.string(fallbackSvg, width: 28, height: 28)
        : Icon(Icons.credit_card, color: fg, size: 24);
    if (iconUrl == null || iconUrl.isEmpty) return fallback();
    // data:image/svg+xml;base64,xxx → 解码渲染
    if (iconUrl.startsWith('data:image/svg+xml')) {
      try {
        final b64 = iconUrl.split(',').last;
        final svg = utf8.decode(base64.decode(b64));
        return SvgPicture.string(svg, width: 28, height: 28);
      } catch (_) {
        return fallback();
      }
    }
    if (iconUrl.startsWith('http')) {
      // SVG(simpleicons/wikimedia .svg)→ SvgPicture.network;失败 fallback 手绘。
      if (iconUrl.contains('.svg') || iconUrl.contains('simpleicons')) {
        return SvgPicture.network(
          iconUrl,
          width: 28,
          height: 28,
          placeholderBuilder: (_) => fallback(),
        );
      }
      // 位图 → Image.network,失败 fallback。
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(iconUrl,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => fallback()),
      );
    }
    return fallback();
  }

  static Widget _payTile(
    BuildContext context, {
    required String label,
    required bool enabled,
    VoidCallback? onTap,
    String? iconUrl,
  }) {
    final cs = Theme.of(context).colorScheme;
    final fg =
        enabled ? cs.onPrimary : cs.onSurfaceVariant.withValues(alpha: 0.5);
    final Widget leading = _payLeading(label, iconUrl, fg);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: enabled ? cs.primary : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: fg, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _checkout(
    BuildContext sheetCtx,
    WidgetRef ref,
    String tradeNo,
    int method, {
    bool isBalance = false,
    Future<void> Function()? onPaid,
  }) async {
    final navCtx = Navigator.of(sheetCtx, rootNavigator: true).context;
    Navigator.of(sheetCtx).pop(); // 关支付方式弹窗
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    _showBlocking(navCtx, isBalance ? '正在扣款…' : '正在发起支付…');
    final res =
        await ref.read(vogueslyApiProvider).checkout(token, tradeNo: tradeNo, method: method);
    if (navCtx.mounted) Navigator.of(navCtx, rootNavigator: true).pop();
    if (!navCtx.mounted) return;
    switch (res.kind) {
      case VogueslyCheckoutKind.balance:
        _toast(navCtx, '购买成功,套餐已开通');
        if (onPaid != null) await onPaid();
        break;
      case VogueslyCheckoutKind.qrcode:
        final isMobile = Platform.isAndroid || Platform.isIOS;
        if (isMobile) {
          final uri = Uri.tryParse(res.payload);
          if (uri != null && uri.hasScheme) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          _wait(navCtx, ref, tradeNo, res.payload, qrData: null, onPaid: onPaid);
        } else {
          _wait(navCtx, ref, tradeNo, res.payload,
              qrData: res.payload, onPaid: onPaid);
        }
        break;
      case VogueslyCheckoutKind.url:
        final uri = Uri.tryParse(res.payload);
        if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        _wait(navCtx, ref, tradeNo, res.payload, qrData: null, onPaid: onPaid);
        break;
      case VogueslyCheckoutKind.error:
        _toast(navCtx, res.payload);
        break;
    }
  }

  static void _wait(
    BuildContext context,
    WidgetRef ref,
    String tradeNo,
    String payload, {
    String? qrData,
    Future<void> Function()? onPaid,
  }) {
    Timer? poll;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dctx) {
        poll ??= Timer.periodic(const Duration(seconds: 3), (t) async {
          final token = ref.read(vogueslyAuthProvider).token;
          if (token == null) return;
          final status =
              await ref.read(vogueslyApiProvider).checkOrder(token, tradeNo);
          if (status == 3 || status == 1) {
            t.cancel();
            if (Navigator.of(dctx).canPop()) Navigator.of(dctx).pop();
            _toast(context, '支付成功,套餐已开通');
            if (onPaid != null) await onPaid();
          }
        });
        return AlertDialog(
          title: Text(qrData != null ? '扫码支付' : '等待支付到账'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              if (qrData != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QrImageView(
                      data: qrData, size: 200, backgroundColor: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text('请用手机 支付宝 / 微信 扫码支付。\n完成后本页会自动到账。',
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5)),
              ] else ...[
                const SizedBox(height: 8),
                const CircularProgressIndicator(),
                const SizedBox(height: 18),
                const Text('已在浏览器打开支付页面。\n完成支付后本页会自动到账。',
                    textAlign: TextAlign.center),
              ],
            ],
          ),
          actions: [
            if (qrData == null)
              TextButton(
                onPressed: () async {
                  final uri = Uri.tryParse(payload);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text('重新打开支付'),
              ),
            TextButton(
              onPressed: () async {
                poll?.cancel();
                Navigator.of(dctx).pop();
                if (onPaid != null) await onPaid();
              },
              child: const Text('我已完成/关闭'),
            ),
          ],
        );
      },
    ).then((_) => poll?.cancel());
  }

  static void _showBlocking(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(width: 18),
            Expanded(child: Text(msg)),
          ],
        ),
      ),
    );
  }

  static void _toast(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
