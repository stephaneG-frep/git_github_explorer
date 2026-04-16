enum QuizDifficulty { easy, medium, hard }

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
    required this.conceptKey,
  });

  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final QuizDifficulty difficulty;
  final String conceptKey;
}
