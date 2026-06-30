import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';

final vogueslyApiProvider = Provider<VogueslyApi>((ref) => VogueslyApi());

enum VogueslyAuthStatus { loggedOut, loggingIn, loggedIn }

class VogueslyAuthState {
  const VogueslyAuthState({
    this.status = VogueslyAuthStatus.loggedOut,
    this.token,
    this.user,
    this.subscribeUrl,
    this.error,
  });

  final VogueslyAuthStatus status;
  final String? token;
  final VogueslyUser? user;
  final String? subscribeUrl; // 登录时随套餐一齐攞,避免再 call 一次 getSubscribe
  final String? error;

  bool get isLoggedIn =>
      status == VogueslyAuthStatus.loggedIn && token != null;

  VogueslyAuthState copyWith({
    VogueslyAuthStatus? status,
    String? token,
    VogueslyUser? user,
    String? subscribeUrl,
    String? error,
    bool clearError = false,
  }) =>
      VogueslyAuthState(
        status: status ?? this.status,
        token: token ?? this.token,
        user: user ?? this.user,
        subscribeUrl: subscribeUrl ?? this.subscribeUrl,
        error: clearError ? null : (error ?? this.error),
      );
}

class VogueslyAuthNotifier extends Notifier<VogueslyAuthState> {
  @override
  VogueslyAuthState build() => const VogueslyAuthState();

  VogueslyApi get _api => ref.read(vogueslyApiProvider);

  /// 登录: 成功后存令牌 + 拉套餐, 状态变 loggedIn。
  Future<bool> login(String email, String password) =>
      _authenticate(() => _api.login(email: email, password: password));

  /// 注册(XBoard 注册即自动登录)。emailCode: 后台开 email_verify 时必填。
  Future<bool> register(
    String email,
    String password, [
    String? inviteCode,
    String? emailCode,
  ]) =>
      _authenticate(
        () => _api.register(
          email: email,
          password: password,
          inviteCode: inviteCode,
          emailCode: emailCode,
        ),
      );

  /// Google OAuth deep-link 回调登录:已攞到 auth_data(Bearer token),直接拉套餐 + 登入。
  Future<bool> loginWithToken(String authData) async {
    if (authData.isEmpty) return false;
    state = state.copyWith(
      status: VogueslyAuthStatus.loggingIn,
      clearError: true,
    );
    VogueslyUser? user;
    String? subscribeUrl;
    try {
      final bundle = await _api.getSubscribeBundle(authData);
      user = bundle.user;
      subscribeUrl = bundle.subscribeUrl;
    } catch (_) {}
    state = VogueslyAuthState(
      status: VogueslyAuthStatus.loggedIn,
      token: authData,
      user: user,
      subscribeUrl: subscribeUrl,
    );
    return true;
  }

  Future<bool> _authenticate(
    Future<VogueslyAuthResult> Function() call,
  ) async {
    state = state.copyWith(
      status: VogueslyAuthStatus.loggingIn,
      clearError: true,
    );
    final result = await call();
    if (!result.ok) {
      state = state.copyWith(
        status: VogueslyAuthStatus.loggedOut,
        error: result.error,
      );
      return false;
    }
    final token = result.token!;
    VogueslyUser? user;
    String? subscribeUrl;
    try {
      final bundle = await _api.getSubscribeBundle(token);
      user = bundle.user;
      subscribeUrl = bundle.subscribeUrl;
    } catch (_) {}
    state = VogueslyAuthState(
      status: VogueslyAuthStatus.loggedIn,
      token: token,
      user: user,
      subscribeUrl: subscribeUrl,
    );
    return true;
  }

  /// 刷新套餐/流量(顺便更新订阅链接缓存)。
  Future<void> refreshUser() async {
    final token = state.token;
    if (token == null) return;
    try {
      final bundle = await _api.getSubscribeBundle(token);
      if (bundle.user != null) {
        state = state.copyWith(
          user: bundle.user,
          subscribeUrl: bundle.subscribeUrl,
        );
      }
    } catch (_) {}
  }

  /// 拉订阅链接(供自动导入)。登录时已随套餐缓存,直接用慳一个 RT。
  Future<String?> fetchSubscribeUrl() async {
    final cached = state.subscribeUrl;
    if (cached != null && cached.isNotEmpty) return cached;
    final token = state.token;
    if (token == null) return null;
    try {
      return await _api.getSubscribeUrl(token);
    } catch (_) {
      return null;
    }
  }

  /// 发送邮箱验证码(注册前,后台 email_verify 开时用)。
  Future<bool> sendEmailVerify(String email) => _api.sendEmailVerify(email);

  void logout() {
    state = const VogueslyAuthState();
  }
}

final vogueslyAuthProvider =
    NotifierProvider<VogueslyAuthNotifier, VogueslyAuthState>(
  VogueslyAuthNotifier.new,
);

/// 后台开关配置(邮箱验证码 / 人机验证),登录页据此决定显示。
/// 后台关时返默认(全 false),即唔显示额外位。
final vogueslyClientConfigProvider =
    FutureProvider<VogueslyClientConfig>((ref) async {
  return ref.read(vogueslyApiProvider).getClientConfig();
});
