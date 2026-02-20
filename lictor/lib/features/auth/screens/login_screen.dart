// lib/features/auth/screens/login_screen.dart
// UI pronta para integração com Supabase Auth

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Substituir por Supabase Auth
    // final response = await supabase.auth.signInWithPassword(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );

    // Mock: simula login com sucesso após delay
    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);

    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppConstants.routeDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Center(child: LictorLogo()),
              const SizedBox(height: 60),

              Text('Entrar', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Continue seu treino de onde parou.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyLarge,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'seu@email.com',
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 32),

              // Login button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.background),
                        ),
                      )
                    : const Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Forgot password
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Supabase resetPasswordForEmail
                  },
                  child: Text(
                    'Esqueci minha senha',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              const _DividerWithText(text: 'ou'),
              const SizedBox(height: 24),

              // Create account
              OutlinedButton(
                onPressed: () => context.go(AppConstants.routeSignup),
                child: const Text(
                  'CRIAR CONTA',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final String text;

  const _DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: AppTextStyles.caption),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
