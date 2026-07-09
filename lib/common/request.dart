import 'dart:async';
import 'dart:convert';
import 'dart:ffi' show Abi;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Request {
  late final Dio dio;
  late final Dio _clashDio;
  String? userAgent;

  Request() {
    dio = Dio(BaseOptions(headers: {'User-Agent': browserUa}));
    _clashDio = Dio();
    _clashDio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (Uri uri) {
          client.userAgent = globalState.ua;
          return FlClashHttpOverrides.handleFindProxy(uri);
        };
        return client;
      },
    );
  }

  Future<Response<Uint8List>> getFileResponseForUrl(String url) async {
    try {
      return await _clashDio.get<Uint8List>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          // ⚠️ 必须 clash UA:否则 XBoard 面板返 base64 通用格式而非 Clash YAML,
          // validateConfig 失败 → profile 刷新后无节点组,只剩 GLOBAL 兜底
          // (桌面用户见到「只有 FlClash 一个」)。同 fetchSubscribeBytes 一致。
          headers: {
            'User-Agent': 'clash-verge/2.0.0 FlClash',
            'Cache-Control': 'no-cache',
          },
        ),
      );
    } catch (e) {
      commonPrint.log('getFileResponseForUrl error ${e.toString()}');
      if (e is DioException) {
        if (e.type == DioExceptionType.unknown) {
          throw currentAppLocalizations.unknownNetworkError;
        } else if (e.type == DioExceptionType.badResponse) {
          throw currentAppLocalizations.networkException;
        }
        rethrow;
      }
      throw currentAppLocalizations.unknownNetworkError;
    }
  }

  Future<Response<String>> getTextResponseForUrl(String url) async {
    final response = await _clashDio.get<String>(
      url,
      options: Options(responseType: ResponseType.plain),
    );
    return response;
  }

  Future<MemoryImage?> getImage(String url) async {
    if (url.isEmpty) return null;
    final response = await dio.get<Uint8List>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final data = response.data;
    if (data == null) return null;
    return MemoryImage(data);
  }

  // 用自己域名嘅 version.json(唔再打 api.github.com/chen08209 上游 repo——
  // 嗰个会引导用户装返原版 FlClash,而且国内冇 VPN 好大机会连唔到)。
  // 返回形状保持同旧代码一致(tag_name/body/download_url),方便 checkUpdateResultHandle 唔使大改。
  /// 本机对应嘅 manifest 平台键(Mac 分 arm64/intel,各平台各自安装包)。
  String? _updatePlatformKey() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isMacOS) {
      return Abi.current() == Abi.macosArm64 ? 'macos_arm64' : 'macos_x64';
    }
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return null;
  }

  Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      final response = await dio.get(
        vogueslyVersionCheckUrl,
        options: Options(responseType: ResponseType.json),
      );
      // 非 200 = 服务器/网络异常,唔可以当「已最新」(会误报),返错误标记畀调用方区分。
      if (response.statusCode != 200) return {'__net_error__': true};
      final data = response.data as Map<String, dynamic>;
      // ⚠️ 按平台+架构选对应条目。旧代码只读扁平 latest_version/download_url(=Android),
      // 令 Mac/Win 显示咗 Android 版本号 + 下错 APK。改成认返自己平台先。
      final key = _updatePlatformKey();
      final platforms = data['platforms'];
      Map<String, dynamic>? entry;
      if (key != null && platforms is Map && platforms[key] is Map) {
        entry = (platforms[key] as Map).cast<String, dynamic>();
      } else if (key == 'android') {
        // 向后兼容:旧 manifest 只有扁平键(即 Android)。
        entry = data;
      } else {
        // 桌面/其它平台喺 manifest 冇对应安装包 → 唔提示(唔好显示别平台版本+下错包)。
        return null;
      }
      final remoteVersion = entry['latest_version'] as String?;
      if (remoteVersion == null || remoteVersion.isEmpty) return null;
      final version = globalState.packageInfo.version;
      final hasUpdate = utils.compareVersions(remoteVersion, version) > 0;
      if (!hasUpdate) return null;
      return {
        'tag_name': 'v$remoteVersion',
        'body': entry['changelog'],
        'download_url': entry['download_url'],
      };
    } catch (e) {
      // 网络异常(断网/超时/DNS)唔可以当「已最新」误报,返错误标记畀调用方区分。
      commonPrint.log('checkForUpdate failed', logLevel: LogLevel.warning);
      return {'__net_error__': true};
    }
  }

  final Map<String, IpInfo Function(Map<String, dynamic>)> _ipInfoSources = {
    'https://ipwho.is': IpInfo.fromIpWhoIsJson,
    'https://api.myip.com': IpInfo.fromMyIpJson,
    'https://ipapi.co/json': IpInfo.fromIpApiCoJson,
    'https://ident.me/json': IpInfo.fromIdentMeJson,
    'http://ip-api.com/json': IpInfo.fromIpAPIJson,
    'https://api.ip.sb/geoip': IpInfo.fromIpSbJson,
    'https://ipinfo.io/json': IpInfo.fromIpInfoIoJson,
  };

  Future<Result<IpInfo?>> checkIp({CancelToken? cancelToken}) async {
    var failureCount = 0;
    final token = cancelToken ?? CancelToken();
    final futures = _ipInfoSources.entries.map((source) async {
      final Completer<Result<IpInfo?>> completer = Completer();
      void handleFailRes() {
        if (!completer.isCompleted && failureCount == _ipInfoSources.length) {
          completer.complete(Result.success(null));
        }
      }

      final future = dio
          .get<Map<String, dynamic>>(
        source.key,
        cancelToken: token,
        options: Options(responseType: ResponseType.json),
      )
          .timeout(const Duration(seconds: 10));
      future
          .then((res) {
        if (res.statusCode == HttpStatus.ok && res.data != null) {
          completer.complete(Result.success(source.value(res.data!)));
          return;
        }
        commonPrint.log('checkIp data empty', logLevel: LogLevel.info);
        failureCount++;
        handleFailRes();
      })
          .catchError((e) {
        failureCount++;
        if (e is DioException && e.type == DioExceptionType.cancel) {
          completer.complete(Result.error('cancelled'));
          return;
        }
        commonPrint.log('checkIp error $e', logLevel: LogLevel.warning);
        handleFailRes();
      });
      return completer.future;
    });
    final res = await Future.any(futures);
    token.cancel();
    return res;
  }

  Future<bool> pingHelper() async {
    if (kDebugMode) return true;
    try {
      final response = await dio
          .get(
        'http://$localhost:$helperPort/ping',
        options: Options(responseType: ResponseType.plain),
      )
          .timeout(const Duration(milliseconds: 2000));
      if (response.statusCode != HttpStatus.ok) {
        return false;
      }
      return (response.data as String) == globalState.coreSHA256;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startCoreByHelper(String arg) async {
    try {
      final response = await dio
          .post(
        'http://$localhost:$helperPort/start',
        data: json.encode({'path': appPath.corePath, 'arg': arg}),
        options: Options(responseType: ResponseType.plain),
      )
          .timeout(const Duration(milliseconds: 2000));
      if (response.statusCode != HttpStatus.ok) {
        return false;
      }
      final data = response.data as String;
      return data.isEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> stopCoreByHelper() async {
    try {
      final response = await dio
          .post(
        'http://$localhost:$helperPort/stop',
        options: Options(responseType: ResponseType.plain),
      )
          .timeout(const Duration(milliseconds: 2000));
      if (response.statusCode != HttpStatus.ok) {
        return false;
      }
      final data = response.data as String;
      return data.isEmpty;
    } catch (_) {
      return false;
    }
  }
}

final request = Request();
