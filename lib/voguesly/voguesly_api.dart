import 'package:dio/dio.dart';

/// 易联(voguesly) 后端 XBoard API 服务。
/// 登录 -> auth_data(令牌, 后续放 Authorization 头) -> 拉套餐/订阅。
class VogueslyApi {
  VogueslyApi({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'https://cp.voguesly.com/api/v1',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            // XBoard 4xx 也返 JSON(含 message), 不要让 dio 直接抛
            validateStatus: (code) => code != null && code < 500,
          ),
        );

  final Dio _dio;

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
  }) =>
      _postAuth('/passport/auth/register', email, password, '注册失败');

  Future<VogueslyAuthResult> _postAuth(
    String path,
    String email,
    String password,
    String failMsg,
  ) async {
    try {
      final resp = await _dio.post(
        path,
        data: {'email': email.trim(), 'password': password},
      );
      final body = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && body?['data'] != null) {
        final data = body!['data'] as Map<String, dynamic>;
        final auth = (data['auth_data'] ?? data['token'])?.toString();
        if (auth == null || auth.isEmpty) {
          return VogueslyAuthResult.error('返回为空, 请重试');
        }
        return VogueslyAuthResult.success(auth);
      }
      return VogueslyAuthResult.error(
        body?['message']?.toString() ?? failMsg,
      );
    } on DioException catch (e) {
      return VogueslyAuthResult.error('网络异常: ${e.message ?? e.type.name}');
    } catch (e) {
      return VogueslyAuthResult.error('$failMsg: $e');
    }
  }

  Options _auth(String token) => Options(headers: {'Authorization': token});

  /// 拉订阅链接(Clash 订阅, 内含我们的智能分流规则)。
  Future<String?> getSubscribeUrl(String token) async {
    final resp = await _dio.get('/user/getSubscribe', options: _auth(token));
    final data = (resp.data as Map<String, dynamic>?)?['data'];
    if (data is Map<String, dynamic>) {
      return data['subscribe_url']?.toString();
    }
    if (data is String) return data; // 部分端点直接返 URL 字符串
    return null;
  }

  /// 拉用户套餐/流量信息。
  Future<VogueslyUser?> getUserInfo(String token) async {
    final resp = await _dio.get('/user/info', options: _auth(token));
    final data = (resp.data as Map<String, dynamic>?)?['data'];
    if (data is Map<String, dynamic>) {
      return VogueslyUser.fromJson(data);
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
  });

  final int upload;
  final int download;
  final int transferEnable;
  final int? expiredAt;
  final int? planId;

  int get used => upload + download;
  int get remain => (transferEnable - used).clamp(0, transferEnable);

  static int _toInt(Object? v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

  factory VogueslyUser.fromJson(Map<String, dynamic> j) => VogueslyUser(
        upload: _toInt(j['u']),
        download: _toInt(j['d']),
        transferEnable: _toInt(j['transfer_enable']),
        expiredAt: j['expired_at'] == null ? null : _toInt(j['expired_at']),
        planId: j['plan_id'] == null ? null : _toInt(j['plan_id']),
      );
}
