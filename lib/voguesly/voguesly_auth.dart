import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';

final vogueslyApiProvider = Provider<VogueslyApi>((ref) => VogueslyApi());

enum VogueslyAuthStatus { loggedOut, loggingIn, loggedIn }

class VogueslyAuthState {
  const VogueslyAuthState({
    this.status = VogueslyAuthStatus.loggedOut,
    this.token,
    this.user,
    this.error,
  });

  final VogueslyAuthStatus status;
  final String? token;
  final VogueslyUser? user;
  final String? error;

  bool get isLoggedIn =>
      status == VogueslyAuthStatus.loggedIn && token != null;

  VogueslyAuthState copyWith({
    VogueslyAuthStatus? status,
    String? token,
    VogueslyUser? user,
    String? error,
    bool clearError = false,
  }) =>
      VogueslyAuthState(
        status: status ?? this.status,
        token: token ?? this.token,
        user: user ?? this.user,
        error: clearError ? null : (error ?? this.error),
      );
}

class VogueslyAuthNotifier extends Notifier<VogueslyAuthState> {
  @override
  VogueslyAuthState build() => const VogueslyAuthState();

  VogueslyApi get _api => ref.read(vogueslyApiProvider);

  /// 登录: 成功后存令牌 + 拉套餐, 状态变 loggedIn。
  Future<bool> login(String email, String password) async {
    state = state.copyWith(
      status: VogueslyAuthStatus.loggingIn,
      clearError: true,
    );
    final result = await _api.login(email: email.trim(), password: password);
    if (!result.ok) {
      state = state.copyWith(
        status: VogueslyAuthStatus.loggedOut,
        error: result.error,
      );
      return false;
    }
    final token = result.token!;
    VogueslyUser? user;
    try {
      user = await _api.getUserInfo(token);
    } catch (_) {}
    state = VogueslyAuthState(
      status: VogueslyAuthStatus.loggedIn,
      token: token,
      user: user,
    );
    return true;
  }

  /// 刷新套餐/流量。
  Future<void> refreshUser() async {
    final token = state.token;
    if (token == null) return;
    try {
      final user = await _api.getUserInfo(token);
      if (user != null) state = state.copyWith(user: user);
    } catch (_) {}
  }

  /// 拉订阅链接(供自动导入)。
  Future<String?> fetchSubscribeUrl() async {
    final token = state.token;
    if (token == null) return null;
    try {
      return await _api.getSubscribeUrl(token);
    } catch (_) {
      return null;
    }
  }

  void logout() {
    state = const VogueslyAuthState();
  }
}

final vogueslyAuthProvider =
    NotifierProvider<VogueslyAuthNotifier, VogueslyAuthState>(
  VogueslyAuthNotifier.new,
);
