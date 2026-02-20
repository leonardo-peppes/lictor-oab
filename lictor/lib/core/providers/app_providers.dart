// lib/core/providers/app_providers.dart
// Providers globais do aplicativo usando Riverpod

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/questions/repositories/mock_question_repository.dart';
import '../../features/questions/repositories/question_repository.dart';
import '../../core/constants/app_constants.dart';

// ─── SharedPreferences ────────────────────────────────────────────────────────
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences before using this provider');
});

// ─── Question Repository ──────────────────────────────────────────────────────
/// Trocar MockQuestionRepository por SupabaseQuestionRepository aqui
/// quando o backend estiver pronto
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return MockQuestionRepository();
});

// ─── Auth State ───────────────────────────────────────────────────────────────
final isLoggedInProvider = StateProvider<bool>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
});

// ─── Subscription State ───────────────────────────────────────────────────────
/// isSubscriber = true → acesso premium completo
/// isSubscriber = false → plano free com limitações
final isSubscriberProvider = StateProvider<bool>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getBool(AppConstants.keyIsSubscriber) ?? false;
});

// ─── Daily Question Counter ───────────────────────────────────────────────────
final dailyQuestionCountProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final savedDate = prefs.getString(AppConstants.keyDailyQuestionDate) ?? '';

  if (savedDate != today) {
    // Reset diário
    prefs.setString(AppConstants.keyDailyQuestionDate, today);
    prefs.setInt(AppConstants.keyDailyQuestionCount, 0);
    return 0;
  }

  return prefs.getInt(AppConstants.keyDailyQuestionCount) ?? 0;
});

// ─── Stats State ──────────────────────────────────────────────────────────────
class StatsState {
  final int totalAnswered;
  final int totalCorrect;
  final Map<String, int> answeredBySubject;
  final Map<String, int> correctBySubject;

  const StatsState({
    this.totalAnswered = 0,
    this.totalCorrect = 0,
    this.answeredBySubject = const {},
    this.correctBySubject = const {},
  });

  double get overallAccuracy =>
      totalAnswered == 0 ? 0 : totalCorrect / totalAnswered;

  StatsState copyWith({
    int? totalAnswered,
    int? totalCorrect,
    Map<String, int>? answeredBySubject,
    Map<String, int>? correctBySubject,
  }) {
    return StatsState(
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      answeredBySubject: answeredBySubject ?? this.answeredBySubject,
      correctBySubject: correctBySubject ?? this.correctBySubject,
    );
  }
}

class StatsNotifier extends StateNotifier<StatsState> {
  final SharedPreferences _prefs;

  StatsNotifier(this._prefs) : super(const StatsState()) {
    _loadStats();
  }

  void _loadStats() {
    final totalAnswered = _prefs.getInt(AppConstants.keyTotalAnswered) ?? 0;
    final totalCorrect = _prefs.getInt(AppConstants.keyTotalCorrect) ?? 0;
    state = StatsState(
      totalAnswered: totalAnswered,
      totalCorrect: totalCorrect,
    );
  }

  void recordAnswer({
    required String subject,
    required bool isCorrect,
  }) {
    final newTotal = state.totalAnswered + 1;
    final newCorrect = state.totalCorrect + (isCorrect ? 1 : 0);

    final answeredBySubject = Map<String, int>.from(state.answeredBySubject);
    final correctBySubject = Map<String, int>.from(state.correctBySubject);

    answeredBySubject[subject] = (answeredBySubject[subject] ?? 0) + 1;
    if (isCorrect) {
      correctBySubject[subject] = (correctBySubject[subject] ?? 0) + 1;
    }

    state = state.copyWith(
      totalAnswered: newTotal,
      totalCorrect: newCorrect,
      answeredBySubject: answeredBySubject,
      correctBySubject: correctBySubject,
    );

    _prefs.setInt(AppConstants.keyTotalAnswered, newTotal);
    _prefs.setInt(AppConstants.keyTotalCorrect, newCorrect);
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return StatsNotifier(prefs);
});
