// lib/features/auth/screens/signup_screen.dart
// UI pronta para integração com Supabase Auth

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Substituir por Supabase Auth
    // final response = await supabase.auth.signUp(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    //   data: {'name': _nameController.text},
    // );

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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go(AppConstants.routeLogin),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Criar conta', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Comece seu treino estratégico agora.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _nameController,
                style: AppTextStyles.bodyLarge,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nome completo'),
              ),
              const SizedBox(height: 16),

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

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Mínimo 8 caracteres',
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
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _signup,
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
                        'CRIAR CONTA',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'Ao criar conta, você concorda com os\nTermos de Uso e Política de Privacidade.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
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
