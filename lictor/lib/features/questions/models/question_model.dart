// lib/features/questions/models/question_model.dart

enum Difficulty { easy, medium, hard }

class Alternative {
  final String letter;
  final String text;

  const Alternative({
    required this.letter,
    required this.text,
  });

  factory Alternative.fromJson(Map<String, dynamic> json) => Alternative(
    letter: json['letter'] as String,
    text: json['text'] as String,
  );

  Map<String, dynamic> toJson() => {
    'letter': letter,
    'text': text,
  };
}

class Question {
  final String id;
  final String subject;         // Disciplina (ex: Direito Civil)
  final String topic;           // Tema (ex: Contratos)
  final String statement;       // Enunciado
  final Difficulty difficulty;
  final List<Alternative> alternatives;
  final String correctAlternative; // Letra da correta (ex: "B")
  final String explanationConcept;   // Conceito central
  final String explanationCorrect;   // Por que a correta está certa
  final String explanationWrongPattern; // Padrão de erro comum
  final String tip;              // Dica prática

  const Question({
    required this.id,
    required this.subject,
    required this.topic,
    required this.statement,
    required this.difficulty,
    required this.alternatives,
    required this.correctAlternative,
    required this.explanationConcept,
    required this.explanationCorrect,
    required this.explanationWrongPattern,
    required this.tip,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as String,
    subject: json['subject'] as String,
    topic: json['topic'] as String,
    statement: json['statement'] as String,
    difficulty: Difficulty.values.byName(json['difficulty'] as String),
    alternatives: (json['alternatives'] as List)
        .map((e) => Alternative.fromJson(e as Map<String, dynamic>))
        .toList(),
    correctAlternative: json['correct_alternative'] as String,
    explanationConcept: json['explanation_concept'] as String,
    explanationCorrect: json['explanation_correct'] as String,
    explanationWrongPattern: json['explanation_wrong_pattern'] as String,
    tip: json['tip'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'topic': topic,
    'statement': statement,
    'difficulty': difficulty.name,
    'alternatives': alternatives.map((e) => e.toJson()).toList(),
    'correct_alternative': correctAlternative,
    'explanation_concept': explanationConcept,
    'explanation_correct': explanationCorrect,
    'explanation_wrong_pattern': explanationWrongPattern,
    'tip': tip,
  };
}
