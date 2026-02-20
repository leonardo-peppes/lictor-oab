// lib/features/questions/screens/training_screen.dart
// Tela principal de treino com explicação imediata após resposta (dinâmica Duolingo)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/providers/app_providers.dart';
import '../models/question_model.dart';
import '../repositories/question_repository.dart';

// ─── Providers ────────────────────────────────────────────────────────────────
final trainingQuestionsProvider =
    FutureProvider<List<Question>>((ref) async {
  final repo = ref.read(questionRepositoryProvider);
  return repo.getQuestions();
});

class _TrainingState {
  final int currentIndex;
  final String? selectedAnswer;
  final bool isAnswered;
  final bool showExplanation;

  const _TrainingState({
    this.currentIndex = 0,
    this.selectedAnswer,
    this.isAnswered = false,
    this.showExplanation = false,
  });

  _TrainingState copyWith({
    int? currentIndex,
    String? selectedAnswer,
    bool? isAnswered,
    bool? showExplanation,
  }) {
    return _TrainingState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isAnswered: isAnswered ?? this.isAnswered,
      showExplanation: showExplanation ?? this.showExplanation,
    );
  }
}

class _TrainingNotifier extends StateNotifier<_TrainingState> {
  _TrainingNotifier() : super(const _TrainingState());

  void selectAnswer(String letter) {
    if (state.isAnswered) return;
    state = state.copyWith(
      selectedAnswer: letter,
      isAnswered: true,
      showExplanation: true,
    );
  }

  void nextQuestion() {
    state = _TrainingState(currentIndex: state.currentIndex + 1);
  }
}

final _trainingNotifierProvider =
    StateNotifierProvider.autoDispose<_TrainingNotifier, _TrainingState>(
  (ref) => _TrainingNotifier(),
);

// ─── Screen ───────────────────────────────────────────────────────────────────
class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(trainingQuestionsProvider);

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
        body: Center(
          child: Text('Erro ao carregar questões',
              style: AppTextStyles.bodyMedium),
        ),
      ),
      data: (questions) => _TrainingContent(questions: questions),
    );
  }
}

class _TrainingContent extends ConsumerStatefulWidget {
  final List<Question> questions;

  const _TrainingContent({required this.questions});

  @override
  ConsumerState<_TrainingContent> createState() => _TrainingContentState();
}

class _TrainingContentState extends ConsumerState<_TrainingContent>
    with TickerProviderStateMixin {
  late AnimationController _explanationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _explanationController = AnimationController(
      vsync: this,
      duration: AppConstants.animMedium,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _explanationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(String letter, Question question) async {
    final notifier = ref.read(_trainingNotifierProvider.notifier);
    notifier.selectAnswer(letter);

    final isCorrect = letter == question.correctAlternative;

    // Feedback tátil
    if (isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    // TODO: Adicionar feedback sonoro com audioplayers
    // if (isCorrect) {
    //   await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    // } else {
    //   await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    // }

    // Registrar nas estatísticas
    ref.read(statsProvider.notifier).recordAnswer(
      subject: question.subject,
      isCorrect: isCorrect,
    );

    // Incrementar contador diário
    final prefs = ref.read(sharedPreferencesProvider);
    final currentCount = prefs.getInt(AppConstants.keyDailyQuestionCount) ?? 0;
    await prefs.setInt(AppConstants.keyDailyQuestionCount, currentCount + 1);

    // Animar explicação para cima
    _explanationController.forward();
  }

  void _nextQuestion(int currentIndex) {
    _explanationController.reset();
    if (currentIndex + 1 >= widget.questions.length) {
      context.go(AppConstants.routeDashboard);
      return;
    }
    ref.read(_trainingNotifierProvider.notifier).nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_trainingNotifierProvider);
    final currentIndex = state.currentIndex;

    if (currentIndex >= widget.questions.length) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Treino concluído!'),
        ),
      );
    }

    final question = widget.questions[currentIndex];
    final progress = (currentIndex + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textTertiary, size: 20),
                            onPressed: () => context.go(AppConstants.routeDashboard),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LictorProgressBar(
                              progress: progress,
                              current: currentIndex + 1,
                              total: widget.questions.length,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Question scroll area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject + difficulty row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                question.subject.toUpperCase(),
                                style: AppTextStyles.labelLarge,
                              ),
                            ),
                            DifficultyBadge(
                                difficulty: question.difficulty.name),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(question.topic, style: AppTextStyles.caption),

                        const SizedBox(height: 24),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 24),

                        // Statement
                        Text(question.statement, style: AppTextStyles.bodyLarge),

                        const SizedBox(height: 28),

                        // Alternatives
                        ...question.alternatives.map((alt) {
                          return _AlternativeCard(
                            alternative: alt,
                            state: state,
                            correctLetter: question.correctAlternative,
                            onTap: state.isAnswered
                                ? null
                                : () => _onAnswerSelected(alt.letter, question),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Explanation panel (slides up after answer)
            if (state.isAnswered)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _ExplanationPanel(
                    question: question,
                    selectedAnswer: state.selectedAnswer ?? '',
                    onNext: () => _nextQuestion(currentIndex),
                    isLast: currentIndex + 1 >= widget.questions.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Alternative Card ─────────────────────────────────────────────────────────
class _AlternativeCard extends StatelessWidget {
  final Alternative alternative;
  final _TrainingState state;
  final String correctLetter;
  final VoidCallback? onTap;

  const _AlternativeCard({
    required this.alternative,
    required this.state,
    required this.correctLetter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    Color letterColor = AppColors.textTertiary;

    if (state.isAnswered) {
      if (alternative.letter == correctLetter) {
        bgColor = AppColors.correctSoft;
        borderColor = AppColors.correctAccent.withOpacity(0.4);
        textColor = AppColors.textPrimary;
        letterColor = AppColors.correctAccent;
      } else if (alternative.letter == state.selectedAnswer &&
          state.selectedAnswer != correctLetter) {
        bgColor = AppColors.wrongSoft;
        borderColor = AppColors.wrongAccent.withOpacity(0.4);
        textColor = AppColors.textSecondary;
        letterColor = AppColors.wrongAccent;
      } else {
        textColor = AppColors.textTertiary;
        letterColor = AppColors.textTertiary;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: AppConstants.animMedium,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    border: Border.all(color: letterColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    alternative.letter,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: letterColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      alternative.text,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: textColor,
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
      ),
    );
  }
}

// ─── Explanation Panel ────────────────────────────────────────────────────────
class _ExplanationPanel extends StatelessWidget {
  final Question question;
  final String selectedAnswer;
  final VoidCallback onNext;
  final bool isLast;

  const _ExplanationPanel({
    required this.question,
    required this.selectedAnswer,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedAnswer == question.correctAlternative;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.62,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: isCorrect
                ? AppColors.correctAccent.withOpacity(0.3)
                : AppColors.wrongAccent.withOpacity(0.3),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 32,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect
                      ? AppColors.correctAccent
                      : AppColors.wrongAccent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isCorrect ? 'Correto!' : 'Incorreto',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: isCorrect
                        ? AppColors.correctAccent
                        : AppColors.wrongAccent,
                    fontSize: 16,
                  ),
                ),
                if (!isCorrect) ...[
                  const Spacer(),
                  Text(
                    'Gabarito: ${question.correctAlternative}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.correctAccent,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),

          // Scrollable explanation
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ExplanationBlock(
                    label: 'CONCEITO',
                    icon: Icons.lightbulb_outline,
                    content: question.explanationConcept,
                  ),
                  const SizedBox(height: 16),
                  _ExplanationBlock(
                    label: 'POR QUE A CORRETA ESTÁ CERTA',
                    icon: Icons.check_outlined,
                    content: question.explanationCorrect,
                  ),
                  const SizedBox(height: 16),
                  _ExplanationBlock(
                    label: 'PADRÃO DE ERRO',
                    icon: Icons.warning_amber_outlined,
                    content: question.explanationWrongPattern,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.silver.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.bookmark_outline,
                            size: 16, color: AppColors.silver),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            question.tip,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Next button
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect
                    ? AppColors.correctAccent.withOpacity(0.9)
                    : AppColors.textPrimary,
                foregroundColor: AppColors.background,
              ),
              child: Text(
                isLast ? 'CONCLUIR TREINO' : 'PRÓXIMA',
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplanationBlock extends StatelessWidget {
  final String label;
  final IconData icon;
  final String content;

  const _ExplanationBlock({
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
            Icon(icon, size: 13, color: AppColors.textTertiary),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
