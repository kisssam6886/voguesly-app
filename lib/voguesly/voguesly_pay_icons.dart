/// 支付方式品牌图标(内联 SVG 字符串,用 SvgPicture.string 渲染)。
/// ⚠️ 刻意唔用 assets/ 文件 —— 加新 asset 要 pub get 重生 manifest,网络挂时 build 唔到;
///    内联字符串零依赖,离线都 build 到。支付宝蓝 / 微信绿 / Stripe / USDT。
const String kSvgAlipay = '''
<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
<rect width="48" height="48" rx="11" fill="#1677FF"/>
<rect x="13" y="13.5" width="22" height="3.6" rx="1.4" fill="#fff"/>
<rect x="22.2" y="15" width="3.6" height="8" rx="1.2" fill="#fff"/>
<rect x="14.5" y="22" width="19" height="3.4" rx="1.4" fill="#fff"/>
<path fill="#fff" d="M23.2 24.5l2.6 1.4-6.4 9.2-3-2z"/>
<path fill="#fff" d="M24.8 24.5l-2.6 1.4 6.4 9.2 3-2z"/>
</svg>''';

const String kSvgWechat = '''
<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
<rect width="48" height="48" rx="11" fill="#07C160"/>
<path fill="#fff" d="M19 13c-6.4 0-11.6 4.3-11.6 9.6 0 3 1.7 5.7 4.4 7.5l-1.1 3.4 4-2.1c1 .3 2.1.5 3.2.6-.3-.9-.5-1.9-.5-2.9 0-5.3 5.1-9.4 11.2-9.4.5 0 1 .03 1.5.09C29.4 16 24.7 13 19 13z"/>
<circle cx="15" cy="20.5" r="1.7" fill="#07C160"/>
<circle cx="23" cy="20.5" r="1.7" fill="#07C160"/>
<path fill="#fff" d="M41 28.5c0-3.8-4-6.9-9-6.9s-9 3.1-9 6.9 4 6.9 9 6.9c1 0 2-.14 3-.4l3.2 1.7-.9-2.8c1.7-1.3 2.7-3.1 2.7-5.1z"/>
<circle cx="29.5" cy="27.8" r="1.3" fill="#07C160"/>
<circle cx="34.5" cy="27.8" r="1.3" fill="#07C160"/>
</svg>''';

const String kSvgStripe = '''
<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
<rect width="48" height="48" rx="11" fill="#635BFF"/>
<path fill="#fff" d="M25.7 20.3c0-1 .82-1.38 2.1-1.38 1.9 0 4.3.58 6.2 1.62v-5.9c-2.07-.82-4.12-1.14-6.2-1.14-5.06 0-8.43 2.64-8.43 7.06 0 6.9 9.5 5.78 9.5 8.75 0 1.18-1.02 1.56-2.4 1.56-2.07 0-4.75-.85-6.85-2v5.98c2.33 1 4.7 1.43 6.85 1.43 5.2 0 8.77-2.57 8.77-7.05 0-7.44-9.54-6.1-9.54-8.94z"/>
</svg>''';

const String kSvgUsdt = '''
<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
<rect width="48" height="48" rx="11" fill="#26A17B"/>
<rect x="12" y="13" width="24" height="4.6" rx="1.4" fill="#fff"/>
<rect x="21.4" y="14.5" width="5.2" height="21" rx="1.6" fill="#fff"/>
<ellipse cx="24" cy="22.5" rx="10" ry="3.6" fill="none" stroke="#fff" stroke-width="3.2"/>
</svg>''';

/// 按支付方式名返回对应 SVG 字符串;认唔到返 null(caller fallback 通用图标)。
String? payIconSvg(String label) {
  final l = label.toLowerCase();
  if (label.contains('支付宝') || l.contains('alipay')) return kSvgAlipay;
  if (label.contains('微信') || l.contains('wechat') || l.contains('weixin')) {
    return kSvgWechat;
  }
  if (label.contains('USDT') ||
      label.contains('加密') ||
      l.contains('usdt') ||
      l.contains('trc') ||
      l.contains('crypto')) {
    return kSvgUsdt;
  }
  if (label.contains('信用卡') ||
      l.contains('apple') ||
      l.contains('google') ||
      l.contains('stripe') ||
      l.contains('card')) {
    return kSvgStripe;
  }
  return null;
}
