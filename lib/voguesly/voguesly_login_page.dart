import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_auth.dart';

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
  bool _obscure = true;
  bool _registerMode = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _inviteCode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final notifier = ref.read(vogueslyAuthProvider.notifier);
    final ok = _registerMode
        ? await notifier.register(_email.text, _password.text, _inviteCode.text)
        : await notifier.login(_email.text, _password.text);
    if (!ok && mounted) {
      final err = ref.read(vogueslyAuthProvider).error ??
          (_registerMode ? '注册失败' : '登录失败');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loading = ref.watch(
      vogueslyAuthProvider.select((s) => s.status == VogueslyAuthStatus.loggingIn),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shield_moon_outlined,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '易联',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _registerMode ? '注册账号 · 一键连接' : '登录账号 · 一键连接',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enabled: !loading,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: '邮箱',
                        prefixIcon: Icon(Icons.mail_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? '请输入有效邮箱' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      enabled: !loading,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: '密码',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '请输入密码' : null,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    if (_registerMode) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _inviteCode,
                        enabled: !loading,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: '邀请码（选填）',
                          prefixIcon: Icon(Icons.card_giftcard),
                          border: OutlineInputBorder(),
                          helperText: '填邀请码注册有优惠',
                        ),
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_registerMode ? '注 册' : '登 录'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: loading
                          ? null
                          : () => setState(
                              () => _registerMode = !_registerMode),
                      child: Text(
                        _registerMode ? '已有账号? 去登录' : '还没账号? 注册',
                      ),
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
}
