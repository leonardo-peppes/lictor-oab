// lib/features/auth/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';

class _OnboardingPage {
  final String headline;
  final String body;
  final String label;

  const _OnboardingPage({
    required this.headline,
    required this.body,
    required this.label,
  });
}

const _pages = [
  _OnboardingPage(
    label: '01 / MÉTODO',
    headline: 'A aprovação\nnão é sorte.',
    body:
        'É método. É repetição inteligente. É clareza sobre o que importa. É saber onde você erra e corrigir rápido.',
  ),
  _OnboardingPage(
    label: '02 / DIAGNÓSTICO',
    headline: 'Cada erro\né diagnóstico.',
    body:
        'Cada questão é um campo de batalha. Cada acerto é construção. Não prometemos atalhos. Prometemos método.',
  ),
  _OnboardingPage(
    label: '03 / RESULTADO',
    headline: 'Treine como\nquem já vai passar.',
    body:
        'Lictor é treino estratégico, estruturado e de alta performance. Porque provas difíceis exigem preparação séria.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingDone, true);
    if (mounted) context.go(AppConstants.routeLogin);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LictorLogo(size: 0.6, showTagline: false),
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Pular',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          page.label,
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          page.headline,
                          style: AppTextStyles.headlineLarge.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 32,
                          height: 1,
                          color: AppColors.silver,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page.body,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      return AnimatedContainer(
                        duration: AppConstants.animShort,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == index ? 24 : 6,
                        height: 2,
                        color: _currentPage == index
                            ? AppColors.textPrimary
                            : AppColors.border,
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(
                      _currentPage < _pages.length - 1
                          ? 'CONTINUAR'
                          : 'COMEÇAR',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
