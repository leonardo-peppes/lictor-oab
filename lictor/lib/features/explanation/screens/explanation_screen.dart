// lib/features/explanation/screens/explanation_screen.dart
// Tela de explicação standalone (usada no resultado do simulado)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../questions/models/question_model.dart';

class ExplanationScreen extends StatelessWidget {
  final Question question;
  final String selectedAnswer;

  const ExplanationScreen({
    super.key,
    required this.question,
    required this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedAnswer == question.correctAlternative;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.subject, style: AppTextStyles.bodyMedium),
            Text(question.topic, style: AppTextStyles.caption),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCorrect ? AppColors.correctSoft : AppColors.wrongSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorrect
                      ? AppColors.correctAccent.withOpacity(0.3)
                      : AppColors.wrongAccent.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
                    color: isCorrect
                        ? AppColors.correctAccent
                        : AppColors.wrongAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isCorrect
                          ? 'Você acertou esta questão.'
                          : 'Você respondeu ${selectedAnswer.isEmpty ? '—' : selectedAnswer}. Gabarito: ${question.correctAlternative}.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isCorrect
                            ? AppColors.correctAccent
                            : AppColors.wrongAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Enunciado
            Text(
              'Enunciado',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: 12),
            Text(question.statement, style: AppTextStyles.bodyLarge),

            const SizedBox(height: 28),
            const Divider(color: AppColors.border),
            const SizedBox(height: 28),

            // Explanation blocks
            _Block(
              label: 'CONCEITO CENTRAL',
              icon: Icons.lightbulb_outline,
              content: question.explanationConcept,
            ),
            const SizedBox(height: 20),
            _Block(
              label: 'POR QUE A CORRETA ESTÁ CERTA',
              icon: Icons.check_circle_outline,
              content: question.explanationCorrect,
            ),
            const SizedBox(height: 20),
            _Block(
              label: 'PADRÃO DE ERRO',
              icon: Icons.warning_amber_outlined,
              content: question.explanationWrongPattern,
            ),

            const SizedBox(height: 24),

            // Tip
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.silver.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark_outline,
                          size: 14, color: AppColors.silver),
                      const SizedBox(width: 8),
                      Text('DICA PRÁTICA', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.tip,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String label;
  final IconData icon;
  final String content;

  const _Block({
    required this.label,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textTertiary),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}
