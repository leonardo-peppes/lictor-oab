// lib/features/stats/screens/stats_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/app_providers.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubscriber = ref.watch(isSubscriberProvider);
    final stats = ref.watch(statsProvider);

    final accuracy = (stats.overallAccuracy * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go(AppConstants.routeDashboard),
        ),
        title: Text('ANÁLISE ESTRATÉGICA', style: AppTextStyles.labelLarge),
        actions: [
          if (!isSubscriber)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: const PremiumBadge(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Free stats - always visible
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Respondidas',
                    value: '${stats.totalAnswered}',
                    icon: Icons.article_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Corretas',
                    value: '${stats.totalCorrect}',
                    icon: Icons.check_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Taxa de acerto',
                    value: '$accuracy%',
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Erros',
                    value:
                        '${stats.totalAnswered - stats.totalCorrect}',
                    icon: Icons.close,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // Performance bar
            if (stats.totalAnswered > 0) ...[
              const SectionHeader(title: 'Desempenho Geral'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Acertos', style: AppTextStyles.bodyMedium),
                        Text('$accuracy%',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.silver)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: stats.overallAccuracy,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(
                          stats.overallAccuracy >= 0.7
                              ? AppColors.correctAccent
                              : stats.overallAccuracy >= 0.5
                                  ? AppColors.silver
                                  : AppColors.wrongAccent,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      stats.overallAccuracy >= 0.7
                          ? 'Excelente. Acima da média dos aprovados.'
                          : stats.overallAccuracy >= 0.5
                              ? 'Na média. Continue treinando.'
                              : 'Abaixo da média. Foque nas disciplinas mais frágeis.',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
            ],

            // Premium locked features
            const SectionHeader(
              title: 'Análise Avançada',
              subtitle: 'Diagnóstico completo por disciplina',
            ),
            const SizedBox(height: 16),

            if (isSubscriber) ...[
              // Premium content: by subject
              if (stats.answeredBySubject.isNotEmpty) ...[
                ...stats.answeredBySubject.entries.map((entry) {
                  final subject = entry.key;
                  final answered = entry.value;
                  final correct = stats.correctBySubject[subject] ?? 0;
                  final pct = answered > 0 ? correct / answered : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(subject,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    )),
                              ),
                              Text(
                                '${(pct * 100).toStringAsFixed(0)}%',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.silver,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: pct,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation(
                                pct >= 0.7
                                    ? AppColors.correctAccent
                                    : pct >= 0.5
                                        ? AppColors.silver
                                        : AppColors.wrongAccent,
                              ),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$correct/$answered questões',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ] else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Responda questões para ver sua análise por disciplina.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
            ] else ...[
              // Locked content with tension
              LockedFeatureCard(
                label: 'Taxa por disciplina',
                onTap: () => showPremiumModal(context),
              ),
              const SizedBox(height: 10),
              LockedFeatureCard(
                label: 'Taxa por tema',
                onTap: () => showPremiumModal(context),
              ),
              const SizedBox(height: 10),
              LockedFeatureCard(
                label: 'Ranking de vulnerabilidade',
                onTap: () => showPremiumModal(context),
              ),
              const SizedBox(height: 10),
              LockedFeatureCard(
                label: 'Probabilidade estimada de aprovação',
                onTap: () => showPremiumModal(context),
              ),
              const SizedBox(height: 10),
              LockedFeatureCard(
                label: 'Comparação com média dos aprovados',
                onTap: () => showPremiumModal(context),
              ),

              const SizedBox(height: 32),

              // CTA
              OutlinedButton(
                onPressed: () => context.push(AppConstants.routePremium),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppColors.premiumGold, width: 1),
                  foregroundColor: AppColors.premiumGoldLight,
                ),
                child: const Text(
                  'VER PLANOS PREMIUM',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
