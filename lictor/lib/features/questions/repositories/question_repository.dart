// lib/features/questions/repositories/question_repository.dart
// Interface abstrata - pronta para troca por SupabaseQuestionRepository

import '../models/question_model.dart';

/// Interface do repositório de questões.
/// Trocar MockQuestionRepository por SupabaseQuestionRepository
/// quando o backend estiver pronto. Nenhuma outra mudança necessária.
abstract class QuestionRepository {
  Future<List<Question>> getQuestions({
    String? subject,
    String? topic,
    Difficulty? difficulty,
    int? limit,
  });

  Future<Question?> getQuestionById(String id);

  Future<List<String>> getSubjects();

  Future<List<String>> getTopicsBySubject(String subject);
}
