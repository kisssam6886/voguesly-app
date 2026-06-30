import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'voguesly_auth.dart';

const _kRememberEmailKey = 'voguesly_remember_email';

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
      _toast('请先输入有效邮箱');
      return;
    }
    final ok =
        await ref.read(vogueslyAuthProvider.notifier).sendEmailVerify(_email.text);
    if (!mounted) return;
    _toast(ok ? '验证码已发送' : '发送失败,请稍后再试');
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
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
          (_registerMode ? '注册失败' : '登录失败');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _googleLogin() async {
    // 内置浏览器(Custom Tab/ASWebAuthenticationSession)一气呵成:开 web OAuth →
    // 后端 callback 跳 voguesly://auth?auth_data= → 由 flutter_web_auth_2 直接捕获返 app。
    try {
      final result = await FlutterWebAuth2.authenticate(
        url:
            'https://cp.voguesly.com/api/v2/passport/auth/google?redirect=voguesly://auth',
        callbackUrlScheme: 'voguesly',
      );
      final authData = Uri.parse(result).queryParameters['auth_data'];
      if (authData == null || authData.isEmpty) {
        if (mounted) _toast('Google 登录失败,请重试');
        return;
      }
      final ok =
          await ref.read(vogueslyAuthProvider.notifier).loginWithToken(authData);
      if (!ok && mounted) {
        // loginWithToken 喺 401/403 会置 state.error='登录已失效…' 并返 false。
        _toast(ref.read(vogueslyAuthProvider).error ?? 'Google 登录失败,请重试');
      }
    } catch (e) {
      if (!mounted) return;
      // flutter_web_auth_2 用户取消会抛 cancel 类异常;其余系网络/配置错误,
      // 唔好一律当「已取消」误导用户(令佢以为系自己取消咗)。
      final canceled = e.toString().toLowerCase().contains('cancel');
      _toast(canceled ? '已取消 Google 登录' : 'Google 登录失败,请检查网络后重试');
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
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.shield_outlined,
                            size: 30, color: cs.primary),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _registerMode ? '创建账户' : '登录账户',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _registerMode ? '注册即自动连接节点' : '请输入您的凭据继续',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 28),
                    _label('邮箱', required: true),
                    _field(
                      controller: _email,
                      hint: 'name@email.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !loading,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? '请输入有效邮箱' : null,
                    ),
                    if (showEmailCode) ...[
                      const SizedBox(height: 14),
                      _label('邮箱验证码', required: true),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _field(
                              controller: _emailCode,
                              hint: '6 位验证码',
                              icon: Icons.mail_lock_outlined,
                              keyboardType: TextInputType.number,
                              enabled: !loading,
                              validator: (v) => (showEmailCode &&
                                      (v == null || v.trim().isEmpty))
                                  ? '请输入验证码'
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
                                  _codeCooldown > 0 ? '${_codeCooldown}s' : '发送'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    _label('密码', required: true),
                    _field(
                      controller: _password,
                      hint: '请输入密码',
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
                          (v == null || v.isEmpty) ? '请输入密码' : null,
                      onSubmitted: (_) => _submit(),
                    ),
                    if (_registerMode) ...[
                      const SizedBox(height: 14),
                      _label('邀请码（选填）'),
                      _field(
                        controller: _inviteCode,
                        hint: '填邀请码注册有优惠',
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
                                  Text('记住我',
                                      style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: loading
                                ? null
                                : () => _toast('请在网页 cp.voguesly.com 重置密码'),
                            child: const Text('忘记密码?'),
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
                                Text(_registerMode ? '注册' : '登录'),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                    ),
                    if (!_registerMode) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('或',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant)),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: loading ? null : _googleLogin,
                        icon: const Icon(Icons.g_mobiledata, size: 26),
                        label: const Text('使用 Google 登录'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Text(
                      _registerMode ? '已有账户?' : '还没有账户?',
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
                      child: Text(_registerMode ? '去登录' : '创建账户'),
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
