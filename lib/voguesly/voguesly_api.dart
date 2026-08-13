import 'dart:typed_data';
import 'package:fl_clash/common/app_localizations.dart';

import 'package:dio/dio.dart';

/// 易联 API + 订阅入口。
/// ⚠️ 2026-07-01 由 cp.voguesly.com 迁到 ylink.im:
///   voguesly.com 已被 GFW SNI 污染(裸IP 100% RST + 套CF间歇被打),且旧域名嘅 /s/ 订阅
///   畀 Cloudflare 缓存(max-age=14400 = 4小时)serve 旧配置 → app 攞唔到 Sam 新加嘅节点。
///   ylink.im 系后端 app_url/subscribe_url 设定嘅现役 panel(CF DYNAMIC 唔缓存,干净)。
///   corelane/octolink 旧镜像已死(HTTP 000),移除。
/// ✅ 2026-08-13 加返 fallback(_try 逐 host 轮询逻辑本就现成):主入口挂 → 轮 CF 备用(不同
///   Anycast IP,治「单 IP 被墙」)→ 最后非CF直连HK逃生(异构路,治「整个 CF 被墙」)。
///   d.ylink.im = 灰云直连 HK 盒(104.245.40.48),非CF。✅广州移动手机实测可达(全新 SNI,
///   当年 voguesly.com 系 SNI 污染唔波及呢条);排最后兜底以保 CF 抗D,CF 全挂时接手。
/// 后续如换品牌门面只需改呢度。
const List<String> kVogueslyHosts = [
  'https://ylink.im',           // 主(CF;后端 app_url/subscribe_url)
  'https://cp.voguesly.com',    // CF 备①(不同 Anycast IP)
  'https://cp.samseah.qzz.io',  // CF 备②(不同 CF zone/IP)
  'https://d.ylink.im',         // 非CF直连HK逃生(异构路;广州移动实测可达)
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
    throw Exception(currentAppLocalizations.vgAllEndpointsUnreachable);
  }

  /// 登录, 成功返回 auth_data 令牌。
  Future<VogueslyAuthResult> login({
    required String email,
    required String password,
  }) =>
      _postAuth('/passport/auth/login', email, password, currentAppLocalizations.vgWrongEmailOrPassword);

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
      currentAppLocalizations.vgSignUpFailed,
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
          return VogueslyAuthResult.error(currentAppLocalizations.vgEmptyResponseRetry);
        }
        return VogueslyAuthResult.success(auth);
      }
      return VogueslyAuthResult.error(
        json?['message']?.toString() ?? failMsg,
      );
    } on DioException catch (e) {
      return VogueslyAuthResult.error(currentAppLocalizations.vgNetworkErrorWith(e.message ?? e.type.name));
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
      final cleanUrl = uri.replace(scheme: 'https', host: host).toString();
      // ⚠️ cache-bust:加时间戳 query 令每次 URL 唯一,绕过 CF 边缘/HTTP client 任何缓存,
      // 保证「更新订阅」实时攞最新(之前用户点更新攞到旧节点=中间层缓存)。后端 ignore _t。
      final fetchUrl = uri.replace(
        scheme: 'https',
        host: host,
        queryParameters: {
          ...uri.queryParameters,
          '_t': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      ).toString();
      try {
        final resp = await _dio.get<List<int>>(
          fetchUrl,
          options: Options(
            responseType: ResponseType.bytes,
            validateStatus: (c) => c == 200,
            // ⚠️ 必须用 clash UA, 否则面板返 base64 通用格式而非 Clash YAML,
            // 会令 saveFile 的 validateConfig 失败(表现=无错但无加载)。
            headers: {
              'User-Agent': 'clash-verge/2.0.0 FlClash',
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
            },
          ),
        );
        final data = resp.data;
        if (data != null && data.isNotEmpty) {
          // 返 cleanUrl(唔含 _t)做 profile.url,下次刷新再加新时间戳。
          return (bytes: Uint8List.fromList(data), url: cleanUrl);
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
    String? goal,
  }) async {
    goal ??= currentAppLocalizations.vgOneTapTrialInApp;
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
            currentAppLocalizations.vgFreeTrialActivated;
        return (ok: true, message: msg);
      }
      return (
        ok: false,
        message: json?['message']?.toString() ?? currentAppLocalizations.vgActivateFailedRetry,
      );
    } on DioException catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e.message ?? e.type.name));
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgActivateFailedWith(e));
    }
  }

  // ========================= 原生商城(套餐 / 下单 / 支付) =========================
  // ⚠️ 商城照 NinjaDesktop 做法 = 全原生页面直调 XBoard API(用 app 已登录 token),
  //    唔用 webview(webview 唔共享 app 会话 → 会弹面板登录页 + 404)。
  //    流程:plan/fetch → order/save(下单攞 trade_no)→ getPaymentMethod(选支付)
  //         → order/checkout(余额直扣 or 返支付 URL/二维码)→ order/check(轮询到账)。
  //    只有最后真支付(支付宝/微信)先跳外部浏览器/出二维码。

  /// 拉套餐列表(GET /user/plan/fetch)。返 [] = 失败/无套餐。
  Future<List<VogueslyPlan>> fetchPlans(String token) async {
    try {
      final resp = await _try('/user/plan/fetch',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VogueslyPlan.fromJson)
            .where((p) => p.periods.isNotEmpty) // 隐藏无可售周期嘅套餐
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  /// 拉账户余额(分)+ 基本信息(GET /user/info)。返 null=失败。
  Future<int?> fetchBalanceCents(String token) async {
    try {
      final resp = await _try('/user/info',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        return _intOf(data['balance']);
      }
    } catch (_) {}
    return null;
  }

  /// 拉可用支付方式(GET /user/order/getPaymentMethod)。返 [] = 失败。
  Future<List<VogueslyPayMethod>> fetchPaymentMethods(String token) async {
    try {
      final resp = await _try('/user/order/getPaymentMethod',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VogueslyPayMethod.fromJson)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  /// 下单(POST /user/order/save)。body{plan_id, period}。
  /// 成功返 trade_no(字符串);失败返 (null, 错误文案)。
  /// idempotent=false:已发出唔轮镜像重发,免重复下单。
  Future<({String? tradeNo, String? error})> createOrder(
    String token, {
    required int planId,
    required String period,
  }) async {
    try {
      final resp = await _try(
        '/user/order/save',
        method: 'POST',
        data: {'plan_id': planId, 'period': period},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      final data = json?['data'];
      if (resp.statusCode == 200 && data != null) {
        // data 通常直接系 trade_no 字符串;个别版本包一层 {trade_no}
        final tradeNo = data is String
            ? data
            : (data is Map ? data['trade_no']?.toString() : null);
        if (tradeNo != null && tradeNo.isNotEmpty) {
          return (tradeNo: tradeNo, error: null);
        }
      }
      return (
        tradeNo: null,
        error: json?['message']?.toString() ?? currentAppLocalizations.vgOrderFailedRetry,
      );
    } on DioException catch (e) {
      return (tradeNo: null, error: currentAppLocalizations.vgNetworkErrorWith(e.message ?? e.type.name));
    } catch (e) {
      return (tradeNo: null, error: currentAppLocalizations.vgOrderFailedWith(e));
    }
  }

  /// 结算支付(POST /user/order/checkout)。body{trade_no, method}。
  /// 返回:
  ///   kind=balance  → 余额已直接扣款开通(data==true)
  ///   kind=url      → 需跳外部浏览器嘅支付链接(payload=URL)
  ///   kind=qrcode   → 需展示二维码(payload=二维码内容,通常系 URL)
  ///   kind=error    → 失败(payload=错误文案)
  Future<VogueslyCheckoutResult> checkout(
    String token, {
    required String tradeNo,
    required int method,
  }) async {
    try {
      final resp = await _try(
        '/user/order/checkout',
        method: 'POST',
        data: {'trade_no': tradeNo, 'method': method},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode != 200) {
        return VogueslyCheckoutResult.error(
            json?['message']?.toString() ?? currentAppLocalizations.vgPaymentStartFailed);
      }
      final data = json?['data'];
      if (data == true) return VogueslyCheckoutResult.balance();
      if (data is String && data.isNotEmpty) {
        // XBoard checkout 返嘅 data:type=1 系跳转 URL,type=0 系二维码内容(多数仍系 URL)。
        // 冇 type 时统一当外部链接跳(支付宝/微信 h5 都可喺浏览器完成)。
        final type = json?['type'];
        if (type == 0) return VogueslyCheckoutResult.qrcode(data);
        return VogueslyCheckoutResult.url(data);
      }
      if (data is Map) {
        final type = _intOf(data['type']);
        final payload =
            (data['data'] ?? data['url'] ?? data['qr_code'])?.toString();
        if (payload != null && payload.isNotEmpty) {
          return type == 0
              ? VogueslyCheckoutResult.qrcode(payload)
              : VogueslyCheckoutResult.url(payload);
        }
      }
      return VogueslyCheckoutResult.error(
          json?['message']?.toString() ?? currentAppLocalizations.vgPaymentStartFailed);
    } on DioException catch (e) {
      return VogueslyCheckoutResult.error(
          currentAppLocalizations.vgNetworkErrorWith(e.message ?? e.type.name));
    } catch (e) {
      return VogueslyCheckoutResult.error(currentAppLocalizations.vgPaymentStartFailedWith(e));
    }
  }

  /// 轮询订单状态(GET /user/order/check?trade_no=)。
  /// 返回 status:0=待支付 1=开通中 2=已取消 3=已完成;null=拉取失败。
  Future<int?> checkOrder(String token, String tradeNo) async {
    try {
      final resp = await _try(
        '/user/order/check?trade_no=$tradeNo',
        headers: {'Authorization': token},
        retryOn401: true,
      );
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      return _intOf(data);
    } catch (_) {
      return null;
    }
  }

  // ========================= 邀请返利 =========================
  /// 拉邀请数据(GET /user/invite/fetch)。codes[](邀请码)+ stat[](统计)。返 null=失败。
  Future<VogueslyInviteData?> fetchInviteData(String token) async {
    try {
      final resp = await _try('/user/invite/fetch',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        return VogueslyInviteData.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  /// 生成一个新邀请码(POST /user/invite/save)。返回是否成功。
  Future<bool> generateInviteCode(String token) async {
    try {
      final resp = await _try('/user/invite/save',
          method: 'POST',
          headers: {'Authorization': token},
          idempotent: false); // 生成码:已发出唔轮镜像重发,免重复生成
      final json = resp.data as Map<String, dynamic>?;
      return resp.statusCode == 200 && json?['data'] != null;
    } catch (_) {
      return false;
    }
  }

  /// 拉知识库/教程列表(GET /user/knowledge/fetch)。客服首页「常见问题/教程」用。
  /// data 可能係 {category:[...]} 或扁平 [...],两者都处理。
  Future<List<VogueslyKnowledge>> fetchKnowledge(String token) async {
    try {
      final resp = await _try('/user/knowledge/fetch?language=zh-CN',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      final out = <VogueslyKnowledge>[];
      if (data is List) {
        for (final e in data) {
          if (e is Map<String, dynamic>) out.add(VogueslyKnowledge.fromJson(e));
        }
      } else if (data is Map) {
        // 分类分组:{ "教程": [ {...} ], ... }
        data.forEach((cat, list) {
          if (list is List) {
            for (final e in list) {
              if (e is Map<String, dynamic>) {
                out.add(VogueslyKnowledge.fromJson({...e, 'category': cat}));
              }
            }
          }
        });
      }
      return out;
    } catch (_) {}
    return const [];
  }

  /// 拉单篇知识库文章正文(GET /user/knowledge/fetch?id=)。返 body(HTML)。
  Future<({String title, String body})?> fetchKnowledgeBody(
      String token, int id) async {
    try {
      final resp = await _try('/user/knowledge/fetch?id=$id&language=zh-CN',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        return (
          title: data['title']?.toString() ?? '',
          body: data['body']?.toString() ?? '',
        );
      }
    } catch (_) {}
    return null;
  }

  // ========================= 公告 / 流量明细 =========================
  /// 拉公告列表(GET /user/notice/fetch)。响应直接 data+total,非 success 包装。返 []=失败。
  Future<List<VogueslyNotice>> fetchNotices(String token) async {
    try {
      final resp = await _try('/user/notice/fetch',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VogueslyNotice.fromJson)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  /// 拉流量明细(GET /user/stat/getTrafficLog)。仅当月每日记录,record_at 倒序。返 []=失败。
  Future<List<VogueslyTrafficLog>> fetchTrafficLog(String token) async {
    try {
      final resp = await _try('/user/stat/getTrafficLog',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VogueslyTrafficLog.fromJson)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  /// 重置订阅(GET /user/resetSecurity)。后端换新订阅 token,旧链接失效。
  /// 返回新 subscribe_url;null=失败。用户中心「重置订阅」用(防订阅泄漏/被盗用)。
  Future<({bool ok, String message})> resetSecurity(String token) async {
    try {
      final resp = await _try('/user/resetSecurity',
          headers: {'Authorization': token});
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] != null) {
        return (ok: true, message: currentAppLocalizations.vgSubscriptionResetFetching);
      }
      return (ok: false, message: json?['message']?.toString() ?? currentAppLocalizations.vgResetFailed);
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e));
    }
  }

  /// 修改密码(POST /user/changePassword {old_password,new_password})。new min 8。
  Future<({bool ok, String message})> changePassword(
    String token, {
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final resp = await _try(
        '/user/changePassword',
        method: 'POST',
        data: {'old_password': oldPassword, 'new_password': newPassword},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] == true) {
        return (ok: true, message: currentAppLocalizations.vgPasswordChanged);
      }
      return (
        ok: false,
        message: json?['message']?.toString() ?? currentAppLocalizations.vgChangeFailedCheckOldPassword
      );
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e));
    }
  }

  /// 佣金划转到余额(POST /user/transfer {transfer_amount 分})。
  Future<({bool ok, String message})> transferCommission(
      String token, int amountCents) async {
    try {
      final resp = await _try(
        '/user/transfer',
        method: 'POST',
        data: {'transfer_amount': amountCents},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] == true) {
        return (ok: true, message: currentAppLocalizations.vgTransferredToBalance);
      }
      return (ok: false, message: json?['message']?.toString() ?? currentAppLocalizations.vgTransferFailed);
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e));
    }
  }

  /// 提现申请(POST /user/ticket/withdraw {withdraw_method,withdraw_account})。
  Future<({bool ok, String message})> withdraw(
    String token, {
    required String method,
    required String account,
  }) async {
    try {
      final resp = await _try(
        '/user/ticket/withdraw',
        method: 'POST',
        data: {'withdraw_method': method, 'withdraw_account': account},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] == true) {
        return (ok: true, message: currentAppLocalizations.vgWithdrawSubmitted);
      }
      return (ok: false, message: json?['message']?.toString() ?? currentAppLocalizations.vgWithdrawFailed);
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e));
    }
  }

  /// 取消订单(POST /user/order/cancel {trade_no})。返回是否成功。
  Future<bool> cancelOrder(String token, String tradeNo) async {
    try {
      final resp = await _try(
        '/user/order/cancel',
        method: 'POST',
        data: {'trade_no': tradeNo},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      return resp.statusCode == 200 && json?['data'] == true;
    } catch (_) {
      return false;
    }
  }

  /// 拉订单记录(GET /user/order/fetch)。用户中心「我的订单」用(Sam:之前有订单查唔到)。
  Future<List<VogueslyOrder>> fetchOrders(String token) async {
    try {
      final resp = await _try('/user/order/fetch',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VogueslyOrder.fromJson)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  static int _intOf(Object? v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

  /// 提交反馈 / 上传日志 —— 用 XBoard 工单系统(POST /user/ticket/save)。
  /// 客服喺面板见到工单 + Telegram 收到通知,凭用户 ID 查后端定位问题。
  Future<({bool ok, String message})> submitFeedback(
    String token, {
    required String message,
    String? subject,
  }) async {
    subject ??= currentAppLocalizations.vgAppFeedbackLogs;
    try {
      final resp = await _try(
        '/user/ticket/save',
        method: 'POST',
        data: {'subject': subject, 'level': 1, 'message': message},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] != null) {
        return (ok: true, message: currentAppLocalizations.vgSubmittedSupportWillFollowUp);
      }
      return (
        ok: false,
        message: json?['message']?.toString() ?? currentAppLocalizations.vgSubmitFailedRetry,
      );
    } on DioException catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e.message ?? e.type.name));
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgSubmitFailedWith(e));
    }
  }

  /// 我的工单列表(GET /user/ticket/fetch,唔带 id = 列表)。
  /// 2026-07-27 补:之前得「提交反馈」冇地方睇返工单/客服回复,用户唔知有冇人跟进。
  Future<List<VogueslyTicket>> fetchTickets(String token) async {
    try {
      final resp = await _try('/user/ticket/fetch',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VogueslyTicket.fromJson)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  /// 单个工单详情 + 全部往来消息(GET /user/ticket/fetch?id=N)。
  Future<VogueslyTicket?> fetchTicketDetail(String token, int id) async {
    try {
      final resp = await _try('/user/ticket/fetch?id=$id',
          headers: {'Authorization': token}, retryOn401: true);
      final data = (resp.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        return VogueslyTicket.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  /// 继续回复工单(POST /user/ticket/reply)。
  /// ⚠️后端规则:同一个人唔可以连续回两次(要等客服先回),嗰个 message 会原样带返俾用户睇。
  Future<({bool ok, String message})> replyTicket(
    String token, {
    required int id,
    required String message,
  }) async {
    try {
      final resp = await _try(
        '/user/ticket/reply',
        method: 'POST',
        data: {'id': id, 'message': message},
        headers: {'Authorization': token},
        idempotent: false,
      );
      final json = resp.data as Map<String, dynamic>?;
      if (resp.statusCode == 200 && json?['data'] != null) {
        return (ok: true, message: currentAppLocalizations.vgSent);
      }
      return (
        ok: false,
        message: json?['message']?.toString() ?? currentAppLocalizations.vgSendFailedRetryComma,
      );
    } on DioException catch (e) {
      return (ok: false, message: currentAppLocalizations.vgNetworkErrorWith(e.message ?? e.type.name));
    } catch (e) {
      return (ok: false, message: currentAppLocalizations.vgSendFailedWith(e));
    }
  }

  /// 用户主动关闭工单(POST /user/ticket/close)。
  Future<bool> closeTicket(String token, int id) async {
    try {
      final resp = await _try(
        '/user/ticket/close',
        method: 'POST',
        data: {'id': id},
        headers: {'Authorization': token},
        idempotent: false,
      );
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

/// XBoard 工单(GET /user/ticket/fetch)。status 0=开启中 1=已关闭;
/// reply_status 1=等紧客服回 0=已回复。列表冇 message 字段,详情先有。
class VogueslyTicket {
  const VogueslyTicket({
    required this.id,
    required this.subject,
    required this.level,
    required this.status,
    required this.replyStatus,
    required this.createdAt,
    this.messages = const [],
  });

  final int id;
  final String subject;
  final int level;
  final int status;
  final int replyStatus;
  final int createdAt;
  final List<VogueslyTicketMessage> messages;

  bool get isClosed => status == 1;
  bool get waitingReply => replyStatus == 1;

  static int _i(Object? v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

  factory VogueslyTicket.fromJson(Map<String, dynamic> json) {
    final rawMsg = json['message'];
    return VogueslyTicket(
      id: _i(json['id']),
      subject: json['subject']?.toString() ?? '',
      level: _i(json['level']),
      status: _i(json['status']),
      replyStatus: _i(json['reply_status']),
      createdAt: _i(json['created_at']),
      messages: rawMsg is List
          ? rawMsg
              .whereType<Map<String, dynamic>>()
              .map(VogueslyTicketMessage.fromJson)
              .toList()
          : const [],
    );
  }
}

/// 工单一条消息。is_me = 係咪用户自己发(后端已经计好)。
class VogueslyTicketMessage {
  const VogueslyTicketMessage({
    required this.message,
    required this.isMe,
    required this.createdAt,
  });

  final String message;
  final bool isMe;
  final int createdAt;

  factory VogueslyTicketMessage.fromJson(Map<String, dynamic> json) {
    final v = json['created_at'];
    return VogueslyTicketMessage(
      message: json['message']?.toString() ?? '',
      isMe: json['is_me'] == true || json['is_me'] == 1,
      createdAt: v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0),
    );
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
    this.planName,
    this.email,
    this.deviceLimit,
  });

  final int upload;
  final int download;
  final int transferEnable;
  final int? expiredAt;
  final int? planId;
  final String? planName; // 套餐名(getSubscribe 返 data.plan.name)
  final String? email;

  /// 套餐并发/设备上限(getSubscribe 一直有返 device_limit,之前客户端冇取)。
  /// null / 0 = 不限。用嚟喺连接卡显示上限,令用户知道「超限」係咩事。
  final int? deviceLimit;

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
        // getSubscribe 已 join `data.plan`(Plan 对象),取其 name 做套餐名。
        planName: (j['plan'] is Map)
            ? (j['plan'] as Map)['name']?.toString()
            : null,
        email: j['email']?.toString(),
        deviceLimit:
            j['device_limit'] == null ? null : _toInt(j['device_limit']),
      );
}

/// 一个套餐嘅可售周期(月/季/年/一次性…)。price 单位=分。
class VogueslyPlanPeriod {
  const VogueslyPlanPeriod({
    required this.key,
    required this.label,
    required this.days,
    required this.priceCents,
  });

  final String key; // order/save 用嘅 period 值(如 month_price)
  final String label; // 月付 / 季付 / 一次性…
  final int days; // 时长(天);0=一次性/不固定
  final int priceCents;

  double get price => priceCents / 100.0;
  String get priceText => (priceCents % 100 == 0)
      ? '¥${(priceCents ~/ 100)}'
      : '¥${price.toStringAsFixed(2)}';
  // 时长文案:0 天当「一次性」,否则「N 天」(30/90/180… 亦顺带标月数)。
  String get durationText {
    if (days <= 0) return currentAppLocalizations.vgOneTime;
    if (days % 30 == 0 && days <= 1095) {
      final m = days ~/ 30;
      return m == 12 ? currentAppLocalizations.vgOneYear : (m % 12 == 0 ? currentAppLocalizations.vgNYears(m ~/ 12) : currentAppLocalizations.vgNMonths(m));
    }
    return currentAppLocalizations.vgNDays(days);
  }
}

/// 商城套餐(含多个可售周期)。
class VogueslyPlan {
  const VogueslyPlan({
    required this.id,
    required this.name,
    required this.transferEnableGb,
    required this.speedLimit,
    required this.content,
    required this.periods,
  });

  final int id;
  final String name;
  final int transferEnableGb; // 流量(GB)
  final int? speedLimit; // 限速(Mbps);null=不限
  final String? content; // 套餐描述(HTML/纯文,可能为空)
  final List<VogueslyPlanPeriod> periods;

  int get minPriceCents =>
      periods.map((e) => e.priceCents).reduce((a, b) => a < b ? a : b);
  int get maxPriceCents =>
      periods.map((e) => e.priceCents).reduce((a, b) => a > b ? a : b);
  // 卡片价格:单周期显一个价,多周期显「最低价 起」(Sam:唔好 69~700 咁写,写 69起 好睇啲)。
  String get priceRangeText {
    final lo = periods.reduce((a, b) => a.priceCents < b.priceCents ? a : b);
    if (periods.length == 1 || minPriceCents == maxPriceCents) {
      return lo.priceText;
    }
    return currentAppLocalizations.vgFromPrice(lo.priceText);
  }

  // 周期键 → (本地化标签, 天数)。onetime 时长唔固定(按套餐)故 days=0 交由 UI 处理。
  // ⚠️ 唔可以係 const:标签要跟当前语言变,const 会喺编译期钉死。
  static Map<String, (String, int)> get _periodMeta => <String, (String, int)>{
    'month_price': (currentAppLocalizations.vgMonthly, 30),
    'quarter_price': (currentAppLocalizations.vgQuarterly, 90),
    'half_year_price': (currentAppLocalizations.vgHalfYearly, 180),
    'year_price': (currentAppLocalizations.vgYearly, 365),
    'two_year_price': (currentAppLocalizations.vgTwoYearly, 730),
    'three_year_price': (currentAppLocalizations.vgThreeYearly, 1095),
    'onetime_price': (currentAppLocalizations.vgOneTime, 0),
  };

  factory VogueslyPlan.fromJson(Map<String, dynamic> j) {
    // 价格字段可能喺顶层,亦可能包一层 prices:{...};两处都揾。
    final prices = j['prices'];
    int? priceAt(String key) {
      final v = j[key] ?? (prices is Map ? prices[key] : null);
      if (v == null) return null;
      final n = v is num ? v.toInt() : int.tryParse('$v');
      return (n == null || n <= 0) ? null : n; // 0/null = 该周期不售
    }

    final periods = <VogueslyPlanPeriod>[];
    for (final e in _periodMeta.entries) {
      final cents = priceAt(e.key);
      if (cents != null) {
        periods.add(VogueslyPlanPeriod(
          key: e.key,
          label: e.value.$1,
          days: e.value.$2,
          priceCents: cents,
        ));
      }
    }
    final transfer = j['transfer_enable'];
    final speed = j['speed_limit'];
    return VogueslyPlan(
      id: VogueslyApi._intOf(j['id']),
      name: j['name']?.toString() ?? currentAppLocalizations.vgPlan,
      transferEnableGb:
          transfer is num ? transfer.toInt() : int.tryParse('$transfer') ?? 0,
      speedLimit: speed == null
          ? null
          : (speed is num ? speed.toInt() : int.tryParse('$speed')),
      content: j['content']?.toString(),
      periods: periods,
    );
  }
}

/// 邀请返利数据(/user/invite/fetch)。
/// ⚠️ stat[] 索引位/佣金单位(分vs元)各 XBoard 版本可能有差,真机拉一次核对再微调。
/// 现按 XBoard 常见:stat[0]=已邀请人数,stat[2]=可用佣金余额(分),stat[3]=累计佣金(分)。
class VogueslyInviteData {
  const VogueslyInviteData({
    required this.codes,
    required this.inviteCount,
    required this.commissionCents,
    required this.totalCommissionCents,
  });

  final List<String> codes; // 邀请码(可能多个,取 first 展示)
  final int inviteCount; // 已邀请注册人数
  final int commissionCents; // 可用佣金余额(分)
  final int totalCommissionCents; // 累计佣金(分)

  String? get firstCode => codes.isEmpty ? null : codes.first;

  factory VogueslyInviteData.fromJson(Map<String, dynamic> j) {
    final codesRaw = j['codes'];
    final codes = <String>[];
    if (codesRaw is List) {
      for (final c in codesRaw) {
        if (c is Map && c['code'] != null) {
          codes.add(c['code'].toString());
        } else if (c is String) {
          codes.add(c);
        }
      }
    }
    final stat = j['stat'];
    int statAt(int i) =>
        (stat is List && i < stat.length) ? VogueslyApi._intOf(stat[i]) : 0;
    return VogueslyInviteData(
      codes: codes,
      inviteCount: statAt(0),
      commissionCents: statAt(2),
      totalCommissionCents: statAt(3),
    );
  }
}

/// 知识库/教程条目(/user/knowledge/fetch)。
class VogueslyKnowledge {
  const VogueslyKnowledge({
    required this.id,
    required this.title,
    required this.category,
  });

  final int id;
  final String title;
  final String category;

  factory VogueslyKnowledge.fromJson(Map<String, dynamic> j) =>
      VogueslyKnowledge(
        id: VogueslyApi._intOf(j['id']),
        title: j['title']?.toString() ?? '',
        category: j['category']?.toString() ?? '',
      );
}

/// 订单记录(/user/order/fetch)。
class VogueslyOrder {
  const VogueslyOrder({
    required this.tradeNo,
    required this.planName,
    required this.totalCents,
    required this.status,
    required this.createdAt,
  });

  final String tradeNo;
  final String planName;
  final int totalCents; // 分
  final int status; // 0待支付 1开通中 2已取消 3已完成 4已退款
  final int createdAt; // 秒级时间戳

  String get statusText => switch (status) {
        0 => currentAppLocalizations.vgOrderPendingPayment,
        1 => currentAppLocalizations.vgOrderActivating,
        2 => currentAppLocalizations.vgOrderCancelled,
        3 => currentAppLocalizations.vgOrderCompleted,
        4 => currentAppLocalizations.vgOrderRefunded,
        _ => currentAppLocalizations.vgUnknown,
      };

  String get amountText => '¥${(totalCents / 100).toStringAsFixed(2)}';

  factory VogueslyOrder.fromJson(Map<String, dynamic> j) => VogueslyOrder(
        tradeNo: j['trade_no']?.toString() ?? '',
        planName: (j['plan'] is Map)
            ? ((j['plan'] as Map)['name']?.toString() ?? currentAppLocalizations.vgPlan)
            : (j['plan_name']?.toString() ?? currentAppLocalizations.vgPlan),
        totalCents: VogueslyApi._intOf(j['total_amount']),
        status: VogueslyApi._intOf(j['status']),
        createdAt: VogueslyApi._intOf(j['created_at']),
      );
}

/// 公告(/user/notice/fetch)。content 系 HTML 串;created_at 秒级时间戳。
class VogueslyNotice {
  const VogueslyNotice({
    required this.id,
    required this.title,
    required this.content,
    this.imgUrl,
    this.createdAt,
    this.tags = const [],
  });

  final int id;
  final String title;
  final String content;
  final String? imgUrl;
  final int? createdAt; // 秒级时间戳
  final List<String> tags;

  factory VogueslyNotice.fromJson(Map<String, dynamic> j) {
    final tagsRaw = j['tags'];
    final tags = <String>[];
    if (tagsRaw is List) {
      for (final t in tagsRaw) {
        if (t != null) tags.add(t.toString());
      }
    }
    return VogueslyNotice(
      id: VogueslyApi._intOf(j['id']),
      title: j['title']?.toString() ?? '',
      content: j['content']?.toString() ?? '',
      imgUrl: j['img_url']?.toString(),
      createdAt: j['created_at'] == null
          ? null
          : VogueslyApi._intOf(j['created_at']),
      tags: tags,
    );
  }
}

/// 单日流量记录(/user/stat/getTrafficLog)。u=上行 d=下行(字节);record_at 秒级时间戳。
class VogueslyTrafficLog {
  const VogueslyTrafficLog({
    required this.recordAt,
    required this.u,
    required this.d,
  });

  final int recordAt; // 当天时间戳(秒)
  final int u; // 上行字节
  final int d; // 下行字节

  int get total => u + d;

  factory VogueslyTrafficLog.fromJson(Map<String, dynamic> j) =>
      VogueslyTrafficLog(
        recordAt: VogueslyApi._intOf(j['record_at']),
        u: VogueslyApi._intOf(j['u']),
        d: VogueslyApi._intOf(j['d']),
      );
}

/// 支付方式(getPaymentMethod)。id=checkout 用嘅 method。
class VogueslyPayMethod {
  const VogueslyPayMethod({
    required this.id,
    required this.name,
    this.icon,
  });

  final int id;
  final String name; // 支付宝 / 微信 / 余额…
  final String? icon;

  factory VogueslyPayMethod.fromJson(Map<String, dynamic> j) =>
      VogueslyPayMethod(
        id: VogueslyApi._intOf(j['id']),
        name: j['name']?.toString() ?? currentAppLocalizations.vgOnlinePayment,
        icon: j['icon']?.toString(),
      );
}

/// checkout 结果:余额直扣 / 跳外部 URL / 出二维码 / 出错。
enum VogueslyCheckoutKind { balance, url, qrcode, error }

class VogueslyCheckoutResult {
  const VogueslyCheckoutResult._(this.kind, this.payload);
  factory VogueslyCheckoutResult.balance() =>
      const VogueslyCheckoutResult._(VogueslyCheckoutKind.balance, '');
  factory VogueslyCheckoutResult.url(String url) =>
      VogueslyCheckoutResult._(VogueslyCheckoutKind.url, url);
  factory VogueslyCheckoutResult.qrcode(String data) =>
      VogueslyCheckoutResult._(VogueslyCheckoutKind.qrcode, data);
  factory VogueslyCheckoutResult.error(String msg) =>
      VogueslyCheckoutResult._(VogueslyCheckoutKind.error, msg);

  final VogueslyCheckoutKind kind;
  final String payload;
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
