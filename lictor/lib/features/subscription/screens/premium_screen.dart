// lib/features/subscription/screens/premium_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/app_providers.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _yearlySelected = true;
  bool _isLoading = false;

  Future<void> _subscribe() async {
    setState(() => _isLoading = true);

    // TODO: Integrar com App Store / Google Play / Stripe
    // Simular processo de pagamento
    await Future.delayed(const Duration(milliseconds: 1000));

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.keyIsSubscriber, true);

    ref.read(isSubscriberProvider.notifier).state = true;

    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppConstants.routeDashboard);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Premium ativado. Bom treino.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.premiumGold.withOpacity(0.6),
                          width: 1.5),
                    ),
                    child: Icon(
                      Icons.workspace_premium_outlined,
                      color: AppColors.premiumGoldLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'LICTOR PREMIUM',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.premiumGoldLight,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Treine como quem já vai passar.',
                    style: AppTextStyles.headlineLarge.copyWith(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acesso completo a todas as ferramentas\nde treino estratégico.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Plan selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _PlanTab(
                      label: 'Anual',
                      sublabel: AppConstants.priceYearlyMonthly,
                      badge: 'MELHOR CUSTO',
                      isSelected: _yearlySelected,
                      onTap: () => setState(() => _yearlySelected = true),
                    ),
                  ),
                  Expanded(
                    child: _PlanTab(
                      label: 'Mensal',
                      sublabel: AppConstants.priceMonthly,
                      isSelected: !_yearlySelected,
                      onTap: () => setState(() => _yearlySelected = false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Price display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.premiumGold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _yearlySelected
                              ? AppConstants.priceYearly
                              : AppConstants.priceMonthly,
                          style: AppTextStyles.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _yearlySelected
                              ? 'Equivale a ${AppConstants.priceYearlyMonthly}'
                              : 'Renovação mensal automática',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  if (_yearlySelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.premiumGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ECONOMIZE 33%',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.premiumGoldLight,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Features list
            const SectionHeader(title: 'O que você desbloqueia'),
            const SizedBox(height: 16),

            const _FeatureRow(label: 'Questões ilimitadas por dia'),
            const _FeatureRow(label: 'Simulados completos com temporizador'),
            const _FeatureRow(label: 'Análise estratégica por disciplina'),
            const _FeatureRow(label: 'Análise por tema'),
            const _FeatureRow(label: 'Mapeamento de padrões de erro'),
            const _FeatureRow(label: 'Probabilidade estimada de aprovação'),
            const _FeatureRow(label: 'Histórico de evolução'),
            const _FeatureRow(label: 'Revisão inteligente'),

            const SizedBox(height: 32),
            const Divider(color: AppColors.border),
            const SizedBox(height: 32),

            // Subscribe button
            ElevatedButton(
              onPressed: _isLoading ? null : _subscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.premiumGoldLight,
                foregroundColor: AppColors.background,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.background),
                      ),
                    )
                  : Text(
                      _yearlySelected
                          ? 'ASSINAR — ${AppConstants.priceYearly}'
                          : 'ASSINAR — ${AppConstants.priceMonthly}',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        fontSize: 14,
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                'Cancele a qualquer momento. Sem fidelidade.',
                style: AppTextStyles.caption,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PlanTab extends StatelessWidget {
  final String label;
  final String sublabel;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanTab({
    required this.label,
    required this.sublabel,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animShort,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: AppColors.premiumGold.withOpacity(0.3))
              : null,
        ),
        child: Column(
          children: [
            if (badge != null) ...[
              Text(
                badge!,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.premiumGoldLight,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String label;

  const _FeatureRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            size: 16,
            color: AppColors.correctAccent,
          ),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
