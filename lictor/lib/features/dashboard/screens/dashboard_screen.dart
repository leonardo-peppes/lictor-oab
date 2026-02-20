// lib/features/dashboard/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/app_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubscriber = ref.watch(isSubscriberProvider);
    final stats = ref.watch(statsProvider);
    final dailyCount = ref.watch(dailyQuestionCountProvider);

    final remaining = AppConstants.dailyQuestionLimit - dailyCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const LictorLogo(size: 0.65, showTagline: false),
                    Row(
                      children: [
                        if (!isSubscriber)
                          GestureDetector(
                            onTap: () => context.push(AppConstants.routePremium),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColors.premiumGold.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'PREMIUM',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.premiumGold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.person_outline,
                              color: AppColors.textSecondary, size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 36)),

            // Welcome + Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bom treino.', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      isSubscriber
                          ? 'Questões ilimitadas disponíveis.'
                          : 'Plano Free · $remaining questão${remaining != 1 ? 's' : ''} restante${remaining != 1 ? 's' : ''} hoje.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 24)),

            // Quick stats cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Respondidas',
                        value: '${stats.totalAnswered}',
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Taxa de acerto',
                        value:
                            '${(stats.overallAccuracy * 100).toStringAsFixed(0)}%',
                        icon: Icons.trending_up,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 36)),

            // Free plan daily progress
            if (!isSubscriber) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      LictorProgressBar(
                        progress: dailyCount / AppConstants.dailyQuestionLimit,
                        current: dailyCount,
                        total: AppConstants.dailyQuestionLimit,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 36)),
            ],

            // Main actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const SectionHeader(
                  title: 'Treinar',
                  subtitle: 'Escolha o modo de estudo',
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Training button (always available)
                    _ActionCard(
                      title: 'Treinar Questões',
                      subtitle: isSubscriber
                          ? 'Ilimitado · Com explicação imediata'
                          : '$remaining restantes hoje',
                      icon: Icons.play_arrow_outlined,
                      onTap: () {
                        if (!isSubscriber &&
                            dailyCount >= AppConstants.dailyQuestionLimit) {
                          showPremiumModal(context,
                              featureName: 'questões ilimitadas');
                          return;
                        }
                        context.push(AppConstants.routeTraining);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Simulation (premium only)
                    if (isSubscriber)
                      _ActionCard(
                        title: 'Simulado',
                        subtitle: 'OAB 1ª fase · Temporizador ativo',
                        icon: Icons.timer_outlined,
                        onTap: () =>
                            context.push(AppConstants.routeSimulation),
                      )
                    else
                      _LockedActionCard(
                        title: 'Simulado',
                        subtitle: 'OAB 1ª fase · Temporizador ativo',
                        icon: Icons.timer_outlined,
                        onTap: () => showPremiumModal(context,
                            featureName: 'Simulado'),
                      ),
                    const SizedBox(height: 12),

                    // Stats
                    _ActionCard(
                      title: 'Análise Estratégica',
                      subtitle: isSubscriber
                          ? 'Diagnóstico completo por disciplina'
                          : 'Visão básica disponível',
                      icon: Icons.bar_chart_outlined,
                      onTap: () => context.push(AppConstants.routeStats),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headlineMedium.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textTertiary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _LockedActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.locked,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.textTertiary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const PremiumBadge(),
          ],
        ),
      ),
    );
  }
}
