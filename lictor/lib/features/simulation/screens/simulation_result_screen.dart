// lib/features/simulation/screens/simulation_result_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../questions/models/question_model.dart';

class SimulationResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<Map<String, dynamic>> answers;

  const SimulationResultScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = totalQuestions > 0
        ? (correctAnswers / totalQuestions * 100).toStringAsFixed(0)
        : '0';
    final passed = correctAnswers >= (totalQuestions * 0.5);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const LictorLogo(size: 0.6, showTagline: false),
                ],
              ),
            ),

            // Result
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Main result display
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'SIMULADO CONCLUÍDO',
                            style: AppTextStyles.labelLarge,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '$accuracy%',
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontSize: 56,
                              fontWeight: FontWeight.w800,
                              color: passed
                                  ? AppColors.correctAccent
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$correctAnswers de $totalQuestions questões corretas',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: passed
                                  ? AppColors.correctSoft
                                  : AppColors.wrongSoft,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: passed
                                    ? AppColors.correctAccent.withOpacity(0.3)
                                    : AppColors.wrongAccent.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              passed
                                  ? 'Acima da média de aprovação'
                                  : 'Abaixo da média de aprovação',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: passed
                                    ? AppColors.correctAccent
                                    : AppColors.wrongAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Review section
                    SectionHeader(
                      title: 'Revisão',
                      subtitle: 'Toque em uma questão para ver a explicação',
                    ),
                    const SizedBox(height: 16),

                    // Question list
                    ...answers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final question = data['question'] as Question;
                      final selected = data['selected'] as String;
                      final isCorrect = data['isCorrect'] as bool;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => context.push(
                            AppConstants.routeExplanation,
                            extra: question,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCorrect
                                    ? AppColors.correctAccent.withOpacity(0.2)
                                    : AppColors.wrongAccent.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? AppColors.correctSoft
                                        : AppColors.wrongSoft,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isCorrect
                                          ? AppColors.correctAccent
                                          : AppColors.wrongAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        question.subject,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        question.topic,
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      selected.isEmpty ? '—' : 'Resp: $selected',
                                      style: AppTextStyles.caption,
                                    ),
                                    Text(
                                      'Gabarito: ${question.correctAlternative}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.correctAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              child: ElevatedButton(
                onPressed: () => context.go(AppConstants.routeDashboard),
                child: const Text(
                  'VOLTAR AO INÍCIO',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
