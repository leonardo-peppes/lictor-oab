// lib/features/simulation/screens/simulation_screen.dart
// Simulado: sem explicação imediata, resposta sequencial com temporizador

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/app_providers.dart';
import '../../questions/models/question_model.dart';

final _simulationQuestionsProvider = FutureProvider<List<Question>>((ref) async {
  final repo = ref.read(questionRepositoryProvider);
  return repo.getQuestions();
});

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  static const int _totalSeconds = 60 * 60; // 1 hora
  late Timer _timer;
  int _remainingSeconds = _totalSeconds;
  int _currentIndex = 0;
  final Map<int, String> _answers = {};
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        _finish();
      } else {
        if (mounted) setState(() => _remainingSeconds--);
      }
    });
  }

  void _selectAnswer(String letter, List<Question> questions) {
    HapticFeedback.selectionClick();
    setState(() => _answers[_currentIndex] = letter);
  }

  void _next(List<Question> questions) {
    if (_currentIndex < questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _finish();
    }
  }

  void _finish() {
    _timer.cancel();
    if (_isFinished || !mounted) return;
    setState(() => _isFinished = true);

    final questionsAsync = ref.read(_simulationQuestionsProvider);
    questionsAsync.whenData((questions) {
      int correct = 0;
      final answerList = <Map<String, dynamic>>[];

      for (int i = 0; i < questions.length; i++) {
        final selected = _answers[i] ?? '';
        final isCorrect = selected == questions[i].correctAlternative;
        if (isCorrect) correct++;
        answerList.add({
          'question': questions[i],
          'selected': selected,
          'isCorrect': isCorrect,
        });
      }

      context.go(AppConstants.routeSimulationResult, extra: {
        'totalQuestions': questions.length,
        'correctAnswers': correct,
        'answers': answerList,
      });
    });
  }

  String get _timerText {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    final s = _remainingSeconds % 60;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color get _timerColor {
    if (_remainingSeconds < 300) return AppColors.wrongAccent;
    if (_remainingSeconds < 600) return AppColors.premiumGoldLight;
    return AppColors.silver;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(_simulationQuestionsProvider);

    return questionsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.silver),
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Erro', style: AppTextStyles.bodyMedium)),
      ),
      data: (questions) {
        if (questions.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Sem questões')),
          );
        }

        final question = questions[_currentIndex];
        final selectedAnswer = _answers[_currentIndex];
        final progress = (_currentIndex + 1) / questions.length;

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.surfaceElevated,
                title: Text('Sair do simulado?',
                    style: AppTextStyles.headlineMedium),
                content: Text(
                  'Seu progresso será perdido.',
                  style: AppTextStyles.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Continuar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text('Sair',
                        style:
                            TextStyle(color: AppColors.wrongAccent)),
                  ),
                ],
              ),
            );
            if (shouldExit == true && context.mounted) {
              context.go(AppConstants.routeDashboard);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  // Top bar with timer
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        // Timer
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _timerColor.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.timer_outlined,
                                  size: 14, color: _timerColor),
                              const SizedBox(width: 6),
                              Text(
                                _timerText,
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _timerColor,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LictorProgressBar(
                            progress: progress,
                            current: _currentIndex + 1,
                            total: questions.length,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Question
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.subject.toUpperCase(),
                            style: AppTextStyles.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(question.topic, style: AppTextStyles.caption),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 24),
                          Text(question.statement,
                              style: AppTextStyles.bodyLarge),
                          const SizedBox(height: 28),

                          // Alternatives (no feedback shown)
                          ...question.alternatives.map((alt) {
                            final isSelected = selectedAnswer == alt.letter;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () =>
                                    _selectAnswer(alt.letter, questions),
                                child: AnimatedContainer(
                                  duration: AppConstants.animShort,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.graphite
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.silver
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.silver
                                                : AppColors.border,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          alt.letter,
                                          style: TextStyle(
                                            fontFamily: 'DM Sans',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? AppColors.textPrimary
                                                : AppColors.textTertiary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 3),
                                          child: Text(
                                            alt.text,
                                            style:
                                                AppTextStyles.bodyLarge.copyWith(
                                              fontSize: 15,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Bottom navigation
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 12, 24, MediaQuery.of(context).padding.bottom + 12),
                    child: Row(
                      children: [
                        if (_currentIndex > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => _currentIndex--),
                              child: const Text('ANTERIOR'),
                            ),
                          ),
                        if (_currentIndex > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => _next(questions),
                            child: Text(
                              _currentIndex < questions.length - 1
                                  ? 'PRÓXIMA'
                                  : 'FINALIZAR',
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
