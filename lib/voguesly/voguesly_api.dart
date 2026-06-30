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
  ///
  /// [idempotent]=false(写操作 POST,如注册/领试用/发邮件码):只在「连接根本未建立」
  /// (connectionTimeout/connectionError)时先轮下一个镜像;若请求已发出(receiveTimeout/
  /// sendTimeout/响应阶段错误,服务端可能已处理)则唔重试,避免重复副作用(重复领试用/重复下单)。
  ///
  /// [retryOn401]=true(token 校验类,如 getSubscribe):某镜像反代异常返 401/403 唔代表
  /// token 真失效 → 记住佢继续轮下一个 host,只有所有 host 都 401/403 先返回,避免单镜像 glitch 误登出。
  Future<Response> _try(
    String path, {
    String method = 'GET',
    Object? data,
    Map<String, dynamic>? headers,
    bool idempotent = true,
    bool retryOn401 = false,
  }) async {
    Object? lastError;
    Response? soft401;
    for (final host in _hosts) {
      try {
        final resp = await _dio.request(
          '$host/api/v1$path',
          data: data,
          options: Options(method: method, headers: headers),
        );
        if (retryOn401 &&
            (resp.statusCode == 401 || resp.statusCode == 403)) {
          soft401 = resp;
          continue;
        }
        return resp;
      } on DioException catch (e) {
        lastError = e;
        if (!idempotent &&
            e.type != DioExceptionType.connectionTimeout &&
            e.type != DioExceptionType.connectionError) {
          rethrow; // 写操作:请求可能已落地,唔轮镜像重发
        }
      } catch (e) {
        lastError = e;
        if (!idempotent) rethrow;
      }
    }
    // soft401 只在「全程无网络错误」时先作准(= 所有可达 host 一致 401/403 = token 真失效)。
    // 若有 host 抛网络错误(部分镜像 China→HK 瞬断),宁可抛错入调用方 catch 保住会话,
    // 唔好凭单一镜像 glitch 嘅 401 误判 token 失效而登出。
    if (soft401 != null && lastError == null) return soft401;
    if (lastError != null) throw lastError;
    if (soft401 != null) return soft401;
    throw Exception('所有入口均不可达');
  }

  /// 登录, 成功返回 auth_data 令牌。
  Future<VogueslyAuthResult> login({
    required String email,
    required String password,
  }) =>
      _postAuth('/passport/auth/login', email, password, '邮箱或密码错误');

  /// 注册(XBoard 注册即自动登录, 同样返 auth_data)。
  /// emailCode: 后台 email_verify 开时必填(邮箱验证码)。
  Future<VogueslyAuthResult> register({
    required String email,
    required String password,
    String? inviteCode,
    String? emailCode,
  }) {
    final extra = <String, dynamic>{};
    if (inviteCode != null && inviteCode.trim().isNotEmpty) {
      extra['invite_code'] = inviteCode.trim();
    }
    if (emailCode != null && emailCode.trim().isNotEmpty) {
      extra['email_code'] = emailCode.trim();
    }
    return _postAuth(
      '/passport/auth/register',
      email,
      password,
      '注册失败',
      extra: extra.isEmpty ? null : extra,
      idempotent: false, // 注册创建账号:已发出唔轮镜像重发,免重复注册/竞态
    );
  }

  /// 拉客户端配置(后台是否开 邮箱验证码 / 人机验证)。
  Future<VogueslyClientConfig> getClientConfig() async {
    try {
      final resp = await _try('/guest/comm/config');
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        return VogueslyClientConfig.fromJson(data);
      }
    } catch (_) {}
    return const VogueslyClientConfig();
  }

  /// 发送邮箱验证码(后台 email_verify 开时,注册前调用)。返回是否成功。
  Future<bool> sendEmailVerify(String email) async {
    try {
      final resp = await _try(
        '/passport/comm/sendEmailVerify',
        method: 'POST',
        data: {'email': email.trim()},
        idempotent: false, // 发邮件:已发出唔重试,免重复发码
      );
      final json = resp.data as Map<String, dynamic>?;
      return resp.statusCode == 200 && (json?['data'] == true);
    } catch (_) {
      return false;
    }
  }

  Future<VogueslyAuthResult> _postAuth(
    String path,
    String email,
    String password,
    String failMsg, {
    Map<String, dynamic>? extra,
    bool idempotent = true,
  }) async {
    try {
      final body = <String, dynamic>{
        'email': email.trim(),
        'password': password,
      };
      if (extra != null) body.addAll(extra);
      final resp =
          await _try(path, method: 'POST', data: body, idempotent: idempotent);
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
        await _try('/user/getSubscribe',
            headers: {'Authorization': token}, retryOn401: true);
    final data = (resp.data as Map<String, dynamic>?)?['data'];
    if (data is Map<String, dynamic>) {
      return data['subscribe_url']?.toString();
    }
    if (data is String) return data; // 部分端点直接返 URL 字符串
    return null;
  }

  /// 一次 /user/getSubscribe 同时攞 用户套餐 + 订阅链接(慳一个 China→HK RT)。
  /// getSubscribe 响应已含 u/d/transfer_enable/expired_at(套餐卡) 同 subscribe_url。
  Future<({VogueslyUser? user, String? subscribeUrl, int? status})>
      getSubscribeBundle(
    String token,
  ) async {
    final resp =
        await _try('/user/getSubscribe',
            headers: {'Authorization': token}, retryOn401: true);
    final status = resp.statusCode;
    final data = (resp.data as Map<String, dynamic>?)?['data'];
    if (data is Map<String, dynamic>) {
      return (
        user: VogueslyUser.fromJson(data),
        subscribeUrl: data['subscribe_url']?.toString(),
        status: status,
      );
    }
    if (data is String) return (user: null, subscribeUrl: data, status: status);
    return (user: null, subscribeUrl: null, status: status);
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

  /// 查询当前用户免费测试资格(后端 GET /user/trial/status)。
  /// eligible=可领;hasUsed=已领过;hasActivePaidPlan=已有付费套餐。
  /// 返 null = 拉取失败(网络),应让 UI 显示「重试」而非误当「不合资格」走购买路径。
  Future<VogueslyTrialStatus?> getTrialStatus(String token) async {
    try {
      final resp = await _try(
        '/user/trial/status',
        headers: {'Authorization': token},
      );
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        return VogueslyTrialStatus.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  /// 领取免费测试(后端 POST /user/trial/apply)。成功后该账号即得 6小时/500MB 套餐。
  /// 返回 (ok, message)。失败 message 系后端文案(已领过/已有套餐/未开放等)。
  Future<({bool ok, String message})> applyTrial(
    String token, {
    String source = 'android_app',
    String goal = 'app内一键体验',
  }) async {
    try {
      final resp = await _try(
        '/user/trial/apply',
        method: 'POST',
        data: {'source': source, 'goal': goal},
        headers: {'Authorization': token},
        idempotent: false, // 领试用:已发出唔轮镜像重发,免「重复领→已领过」误判
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] != null) {
        final d = json!['data'];
        final msg = (d is Map<String, dynamic> ? d['message'] : null)
                ?.toString() ??
            '免费测试已开通';
        return (ok: true, message: msg);
      }
      return (
        ok: false,
        message: json?['message']?.toString() ?? '开通失败,请稍后再试',
      );
    } on DioException catch (e) {
      return (ok: false, message: '网络异常: ${e.message ?? e.type.name}');
    } catch (e) {
      return (ok: false, message: '开通失败: $e');
    }
  }
}

/// 免费测试资格(后端 /user/trial/status)。
class VogueslyTrialStatus {
  const VogueslyTrialStatus({
    this.eligible = false,
    this.hasUsed = false,
    this.hasActivePaidPlan = false,
    this.templateAvailable = false,
  });

  final bool eligible; // 可领免费测试
  final bool hasUsed; // 已领取过
  final bool hasActivePaidPlan; // 已有有效付费套餐
  final bool templateAvailable; // 后台免费测试模板是否开放

  static bool _b(Object? v) => v == 1 || v == true;

  factory VogueslyTrialStatus.fromJson(Map<String, dynamic> j) =>
      VogueslyTrialStatus(
        eligible: _b(j['eligible']),
        hasUsed: _b(j['has_used']),
        hasActivePaidPlan: _b(j['has_active_paid_plan']),
        templateAvailable: _b(j['template_available']),
      );
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

/// 后台 /guest/comm/config 下发:登录/注册页据此决定显示验证码 / 邮箱码。
class VogueslyClientConfig {
  const VogueslyClientConfig({
    this.isEmailVerify = false,
    this.isCaptcha = false,
    this.captchaType = 'recaptcha-v3',
    this.recaptchaV3SiteKey,
    this.turnstileSiteKey,
  });

  final bool isEmailVerify;
  final bool isCaptcha;
  final String captchaType; // recaptcha | recaptcha-v3 | turnstile
  final String? recaptchaV3SiteKey;
  final String? turnstileSiteKey;

  factory VogueslyClientConfig.fromJson(Map<String, dynamic> j) =>
      VogueslyClientConfig(
        isEmailVerify: j['is_email_verify'] == 1 || j['is_email_verify'] == true,
        isCaptcha: j['is_captcha'] == 1 || j['is_captcha'] == true,
        captchaType: j['captcha_type']?.toString() ?? 'recaptcha-v3',
        recaptchaV3SiteKey: j['recaptcha_v3_site_key']?.toString(),
        turnstileSiteKey: j['turnstile_site_key']?.toString(),
      );
}
