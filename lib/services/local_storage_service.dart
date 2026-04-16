import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _favoriteLessonIdsKey = 'favorite_lesson_ids';
  static const _completedLessonIdsKey = 'completed_lesson_ids';
  static const _completedExerciseIdsKey = 'completed_exercise_ids';
  static const _completedChallengeIdsKey = 'completed_challenge_ids';
  static const _earnedBadgesKey = 'earned_badges';
  static const _quizScoreKey = 'quiz_score';
  static const _answeredQuestionsKey = 'answered_questions';

  static Future<Map<String, dynamic>> loadAppState() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      _favoriteLessonIdsKey: prefs.getStringList(_favoriteLessonIdsKey) ?? <String>[],
      _completedLessonIdsKey: prefs.getStringList(_completedLessonIdsKey) ?? <String>[],
      _completedExerciseIdsKey: prefs.getStringList(_completedExerciseIdsKey) ?? <String>[],
      _completedChallengeIdsKey: prefs.getStringList(_completedChallengeIdsKey) ?? <String>[],
      _earnedBadgesKey: prefs.getStringList(_earnedBadgesKey) ?? <String>[],
      _quizScoreKey: prefs.getInt(_quizScoreKey) ?? 0,
      _answeredQuestionsKey: prefs.getInt(_answeredQuestionsKey) ?? 0,
    };
  }

  static Future<void> saveAppState({
    required Set<String> favoriteLessonIds,
    required Set<String> completedLessonIds,
    required Set<String> completedExerciseIds,
    required Set<String> completedChallengeIds,
    required Set<String> earnedBadges,
    required int quizScore,
    required int answeredQuestions,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_favoriteLessonIdsKey, favoriteLessonIds.toList());
    await prefs.setStringList(_completedLessonIdsKey, completedLessonIds.toList());
    await prefs.setStringList(_completedExerciseIdsKey, completedExerciseIds.toList());
    await prefs.setStringList(_completedChallengeIdsKey, completedChallengeIds.toList());
    await prefs.setStringList(_earnedBadgesKey, earnedBadges.toList());
    await prefs.setInt(_quizScoreKey, quizScore);
    await prefs.setInt(_answeredQuestionsKey, answeredQuestions);
  }
}
