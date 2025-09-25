import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../application/auth_controller.dart';
import '../../application/auth_providers.dart';
import '../../data/auth_types.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  static const routeName = 'auth';
  static const routePath = '/auth';

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

enum _AuthMode { emailLogin, emailRegister, phoneOtp }

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  _AuthMode _mode = _AuthMode.emailLogin;
  bool _validateOtpField = false;

  @override
  void initState() {
    super.initState();
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.status.whenOrNull(
        error: (error, stackTrace) {
          if (!mounted) return;
          final message = error is String ? error : error.toString();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        },
        data: (_) {
          if (!mounted) return;
          final tokens = ref.read(authTokensProvider);
          final becameAuthenticated =
              tokens.isAuthenticated && (previous?.status.isLoading ?? false) && !next.status.isLoading;
          if (becameAuthenticated) {
            _clearSensitiveFields();
            context.go(HomePage.routePath);
          }
        },
      );

      if (!mounted) return;
      if (next.lastSentOtp != null && next.lastSentOtp != previous?.lastSentOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Код подтверждения: ${next.lastSentOtp}')),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<_AuthMode>(
              segments: const [
                ButtonSegment(value: _AuthMode.emailLogin, label: Text('Вход по email')),
                ButtonSegment(value: _AuthMode.emailRegister, label: Text('Регистрация')),
                ButtonSegment(value: _AuthMode.phoneOtp, label: Text('Вход по телефону')),
              ],
              selected: {_mode},
              onSelectionChanged: isLoading
                  ? null
                  : (selection) {
                      setState(() {
                        _mode = selection.first;
                        _validateOtpField = false;
                      });
                    },
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFormFields(),
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              onPressed: isLoading ? null : _onSubmit,
              label: _primaryActionLabel,
              isLoading: isLoading,
            ),
            if (_mode == _AuthMode.phoneOtp) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: isLoading ? null : _requestOtp,
                child: Text(authState.lastSentOtp == null ? 'Получить код' : 'Отправить код ещё раз'),
              ),
              if (authState.lastSentOtp != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Для теста используйте код: ${authState.lastSentOtp}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
            const SizedBox(height: 32),
            Text(
              'Или продолжите через',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _OAuthButtons(isLoading: isLoading, onSelected: _onOAuthSelected),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    switch (_mode) {
      case _AuthMode.emailLogin:
        return [
          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: 'Пароль',
            obscureText: true,
            validator: _validatePassword,
          ),
        ];
      case _AuthMode.emailRegister:
        return [
          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: 'Пароль',
            obscureText: true,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _confirmPasswordController,
            label: 'Повторите пароль',
            obscureText: true,
            validator: (value) {
              final password = _passwordController.text;
              if (value == null || value.isEmpty) {
                return 'Подтвердите пароль';
              }
              if (value != password) {
                return 'Пароли не совпадают';
              }
              return null;
            },
          ),
        ];
      case _AuthMode.phoneOtp:
        return [
          AppTextField(
            controller: _phoneController,
            label: 'Номер телефона',
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _otpController,
            label: 'Код подтверждения',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (!_validateOtpField) {
                return null;
              }
              if ((value ?? '').isEmpty) {
                return 'Введите код из сообщения';
              }
              if ((value ?? '').length < 4) {
                return 'Код должен содержать 4-6 цифр';
              }
              return null;
            },
          ),
        ];
    }
  }

  String get _primaryActionLabel {
    switch (_mode) {
      case _AuthMode.emailLogin:
        return 'Войти';
      case _AuthMode.emailRegister:
        return 'Зарегистрироваться';
      case _AuthMode.phoneOtp:
        return 'Подтвердить код';
    }
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Введите email';
    }
    if (!trimmed.contains('@')) {
      return 'Неверный формат email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Минимальная длина пароля — 6 символов';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final cleaned = value?.replaceAll(RegExp(r'[^0-9+]'), '') ?? '';
    if (cleaned.isEmpty) {
      return 'Введите номер телефона';
    }
    if (cleaned.length < 10) {
      return 'Укажите корректный номер телефона';
    }
    return null;
  }

  void _onSubmit() {
    if (_mode == _AuthMode.phoneOtp) {
      setState(() {
        _validateOtpField = true;
      });
      if (!_validateAndSave()) {
        return;
      }
      final phone = _phoneController.text.trim();
      final code = _otpController.text.trim();
      ref.read(authControllerProvider.notifier).verifyPhoneOtp(phoneNumber: phone, code: code);
      return;
    }

    if (!_validateAndSave()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final controller = ref.read(authControllerProvider.notifier);
    if (_mode == _AuthMode.emailLogin) {
      controller.loginWithEmail(email, password);
    } else {
      controller.registerWithEmail(email, password);
    }
  }

  void _requestOtp() {
    setState(() {
      _validateOtpField = false;
      _otpController.clear();
    });
    if (_validatePhone(_phoneController.text) != null) {
      _formKey.currentState?.validate();
      return;
    }
    ref.read(authControllerProvider.notifier).requestPhoneOtp(_phoneController.text.trim());
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form == null) {
      return false;
    }
    return form.validate();
  }

  void _onOAuthSelected(SocialProvider provider) {
    ref.read(authControllerProvider.notifier).signInWithProvider(provider);
  }

  void _clearSensitiveFields() {
    _passwordController.clear();
    _confirmPasswordController.clear();
    _otpController.clear();
  }
}

class _OAuthButtons extends StatelessWidget {
  const _OAuthButtons({required this.isLoading, required this.onSelected});

  final bool isLoading;
  final void Function(SocialProvider provider) onSelected;

  @override
  Widget build(BuildContext context) {
    final configs = <_OAuthConfig>[
      const _OAuthConfig(provider: SocialProvider.google, label: 'Google', icon: Icons.g_translate),
      const _OAuthConfig(provider: SocialProvider.apple, label: 'Apple', icon: Icons.apple),
      const _OAuthConfig(provider: SocialProvider.vk, label: 'VK', icon: Icons.public),
      const _OAuthConfig(provider: SocialProvider.telegram, label: 'Telegram', icon: Icons.send),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final config in configs) ...[
          OutlinedButton.icon(
            onPressed: isLoading ? null : () => onSelected(config.provider),
            icon: Icon(config.icon),
            label: Text('Продолжить через ${config.label}'),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _OAuthConfig {
  const _OAuthConfig({required this.provider, required this.label, required this.icon});

  final SocialProvider provider;
  final String label;
  final IconData icon;
}
