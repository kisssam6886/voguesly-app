import 'dart:typed_data';

import 'package:dio/dio.dart';

/// 易联 API 入口（主 + 中国可达 fallback 镜像，反代同一后端 cp.voguesly.com）。
/// 主入口偶尔瞬断时自动轮下一个，保证登录 / 拉订阅高可用。
/// 镜像走自签证书，靠 main.dart 的 HttpOverrides.global(FlClashHttpOverrides)
/// 全局 badCertificateCallback=>true 接受，无需额外处理。
const List<String> kVogueslyHosts = [
  'https://cp.voguesly.com',
  'https://s1.corelane.xyz',
  'https://s2.corelane.xyz',
  'https://s3.octolink.xyz',
];

/// 易联(voguesly) 后端 XBoard API 服务。
/// 登录 -> auth_data(令牌, 后续放 Authorization 头) -> 拉套餐/订阅。
class VogueslyApi {
  VogueslyApi({List<String>? hosts})
      : _hosts = hosts ?? kVogueslyHosts,
        _dio = Dio(
          BaseOptions(
            // 调短连接超时, 主入口挂时尽快轮 fallback
            connectTimeout: const Duration(seconds: 8),
            receiveTimeout: const Duration(seconds: 20),
            // XBoard 4xx 也返 JSON(含 message), 不要让 dio 直接抛
            validateStatus: (code) => code != null && code < 500,
          ),
        );

  final Dio _dio;
  final List<String> _hosts;

  /// 逐个入口尝试同一 /api/v1 请求, 第一个成功即返回; 全挂则抛最后错误。
  Future<Response> _try(
    String path, {
    String method = 'GET',
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    Object? lastError;
    for (final host in _hosts) {
      try {
        return await _dio.request(
          '$host/api/v1$path',
          data: data,
          options: Options(method: method, headers: headers),
        );
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? Exception('所有入口均不可达');
  }

  /// 登录, 成功返回 auth_data 令牌。
  Future<VogueslyAuthResult> login({
    required String email,
    required String password,
  }) =>
      _postAuth('/passport/auth/login', email, password, '邮箱或密码错误');

  /// 注册(XBoard 注册即自动登录, 同样返 auth_data)。只需邮箱+密码。
  Future<VogueslyAuthResult> register({
    required String email,
    required String password,
    String? inviteCode,
  }) =>
      _postAuth(
        '/passport/auth/register',
        email,
        password,
        '注册失败',
        extra: (inviteCode != null && inviteCode.trim().isNotEmpty)
            ? {'invite_code': inviteCode.trim()}
            : null,
      );

  Future<VogueslyAuthResult> _postAuth(
    String path,
    String email,
    String password,
    String failMsg, {
    Map<String, dynamic>? extra,
  }) async {
    try {
      final body = <String, dynamic>{
        'email': email.trim(),
        'password': password,
      };
      if (extra != null) body.addAll(extra);
      final resp = await _try(path, method: 'POST', data: body);
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] != null) {
        final d = json!['data'] as Map<String, dynamic>;
        final auth = (d['auth_data'] ?? d['token'])?.toString();
        if (auth == null || auth.isEmpty) {
          return VogueslyAuthResult.error('返回为空, 请重试');
        }
        return VogueslyAuthResult.success(auth);
      }
      return VogueslyAuthResult.error(
        json?['message']?.toString() ?? failMsg,
      );
    } on DioException catch (e) {
      return VogueslyAuthResult.error('网络异常: ${e.message ?? e.type.name}');
    } catch (e) {
      return VogueslyAuthResult.error('$failMsg: $e');
    }
  }

  /// 拉订阅链接(Clash 订阅, 内含我们的智能分流规则)。
  Future<String?> getSubscribeUrl(String token) async {
    final resp =
        await _try('/user/getSubscribe', headers: {'Authorization': token});
    final data = (resp.data as Map<String, dynamic>?)?['data'];
    if (data is Map<String, dynamic>) {
      return data['subscribe_url']?.toString();
    }
    if (data is String) return data; // 部分端点直接返 URL 字符串
    return null;
  }

  /// 一次 /user/getSubscribe 同时攞 用户套餐 + 订阅链接(慳一个 China→HK RT)。
  /// getSubscribe 响应已含 u/d/transfer_enable/expired_at(套餐卡) 同 subscribe_url。
  Future<({VogueslyUser? user, String? subscribeUrl})> getSubscribeBundle(
    String token,
  ) async {
    final resp =
        await _try('/user/getSubscribe', headers: {'Authorization': token});
    final data = (resp.data as Map<String, dynamic>?)?['data'];
    if (data is Map<String, dynamic>) {
      return (
        user: VogueslyUser.fromJson(data),
        subscribeUrl: data['subscribe_url']?.toString(),
      );
    }
    if (data is String) return (user: null, subscribeUrl: data);
    return (user: null, subscribeUrl: null);
  }

  /// 探测某订阅 URL 是否可达(用于 fallback 选路)。
  /// 用本类 dio(我们控制超时 + 全局接受自签证书)，可达返 true，不弹任何 UI。
  Future<bool> probeUrl(String url) async {
    try {
      final resp = await _dio.get<String>(
        url,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (c) => c != null && c < 500,
        ),
      );
      return resp.statusCode == 200 && (resp.data?.isNotEmpty ?? false);
    } catch (_) {
      return false;
    }
  }

  /// 攞订阅原始内容(bytes)，主 cp 失败逐个轮 fallback 镜像。
  /// 用本类 dio(全局接受自签证书)，绕开 FlClash 核心 _clashDio
  /// (后者喺主入口瞬断时会抛 unknown 错 = 用户见到嘅「未知网络错误」)。
  /// 返回 (bytes, 成功嗰个 url) 或 null。
  Future<({Uint8List bytes, String url})?> fetchSubscribeBytes(
    String subscribeUrl,
  ) async {
    final uri = Uri.parse(subscribeUrl);
    for (final base in _hosts) {
      final host = Uri.parse(base).host;
      final tryUrl = uri.replace(scheme: 'https', host: host).toString();
      try {
        final resp = await _dio.get<List<int>>(
          tryUrl,
          options: Options(
            responseType: ResponseType.bytes,
            validateStatus: (c) => c == 200,
            // ⚠️ 必须用 clash UA, 否则面板返 base64 通用格式而非 Clash YAML,
            // 会令 saveFile 的 validateConfig 失败(表现=无错但无加载)。
            headers: {'User-Agent': 'clash-verge/2.0.0 FlClash'},
          ),
        );
        final data = resp.data;
        if (data != null && data.isNotEmpty) {
          return (bytes: Uint8List.fromList(data), url: tryUrl);
        }
      } catch (_) {}
    }
    return null;
  }
}

class VogueslyAuthResult {
  const VogueslyAuthResult._(this.token, this.error);
  factory VogueslyAuthResult.success(String token) =>
      VogueslyAuthResult._(token, null);
  factory VogueslyAuthResult.error(String message) =>
      VogueslyAuthResult._(null, message);

  final String? token;
  final String? error;

  bool get ok => token != null;
}

/// 用户套餐/流量(单位: 字节, expired_at 秒级时间戳; null=不限/长期)。
class VogueslyUser {
  const VogueslyUser({
    required this.upload,
    required this.download,
    required this.transferEnable,
    required this.expiredAt,
    required this.planId,
    this.email,
  });

  final int upload;
  final int download;
  final int transferEnable;
  final int? expiredAt;
  final int? planId;
  final String? email;

  int get used => upload + download;
  int get remain => (transferEnable - used).clamp(0, transferEnable);

  /// 剩余流量百分比 0..1（transferEnable=0 时返 0，避免除零）。
  double get remainRatio =>
      transferEnable <= 0 ? 0 : (remain / transferEnable).clamp(0, 1);

  static int _toInt(Object? v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

  factory VogueslyUser.fromJson(Map<String, dynamic> j) => VogueslyUser(
        upload: _toInt(j['u']),
        download: _toInt(j['d']),
        transferEnable: _toInt(j['transfer_enable']),
        expiredAt: j['expired_at'] == null ? null : _toInt(j['expired_at']),
        planId: j['plan_id'] == null ? null : _toInt(j['plan_id']),
        email: j['email']?.toString(),
      );
}
