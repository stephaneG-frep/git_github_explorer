import 'package:flutter/foundation.dart';

import '../data/app_data.dart';

class AppState extends ChangeNotifier {
  final Set<String> _favoriteLessonIds = <String>{};
  final Set<String> _completedExerciseIds = <String>{};
  final Set<String> _completedChallengeIds = <String>{};
  final Set<String> _earnedBadges = <String>{};

  int _quizScore = 0;
  int _answeredQuestions = 0;

  Set<String> get favoriteLessonIds => _favoriteLessonIds;
  Set<String> get completedExerciseIds => _completedExerciseIds;
  Set<String> get completedChallengeIds => _completedChallengeIds;
  Set<String> get earnedBadges => _earnedBadges;

  int get quizScore => _quizScore;
  int get answeredQuestions => _answeredQuestions;

  double get learningProgress {
    final learned = _favoriteLessonIds.length;
    final total = lessons.length;
    if (total == 0) {
      return 0;
    }
    return learned / total;
  }

  double get practiceProgress {
    final total = guidedExercises.length + simpleChallenges.length;
    final done = _completedExerciseIds.length + _completedChallengeIds.length;
    if (total == 0) {
      return 0;
    }
    return done / total;
  }

  double get globalProgress {
    final quizPart = quizQuestions.isEmpty ? 0 : _answeredQuestions / quizQuestions.length;
    return ((learningProgress + practiceProgress + quizPart) / 3).clamp(0, 1);
  }

  bool isFavorite(String lessonId) => _favoriteLessonIds.contains(lessonId);

  void toggleFavorite(String lessonId) {
    if (_favoriteLessonIds.contains(lessonId)) {
      _favoriteLessonIds.remove(lessonId);
    } else {
      _favoriteLessonIds.add(lessonId);
      _awardBadge('GitHub Navigator');
    }
    notifyListeners();
  }

  void markExerciseDone(String exerciseId) {
    _completedExerciseIds.add(exerciseId);
    if (_completedExerciseIds.isNotEmpty) {
      _awardBadge('Commit Rookie');
    }
    if (_completedExerciseIds.length >= 2) {
      _awardBadge('Branch Explorer');
    }
    notifyListeners();
  }

  void markChallengeDone(String challengeId) {
    _completedChallengeIds.add(challengeId);
    if (_completedChallengeIds.isNotEmpty) {
      _awardBadge('Merge Tamer');
    }
    notifyListeners();
  }

  void answerQuiz({required bool isCorrect}) {
    _answeredQuestions += 1;
    if (isCorrect) {
      _quizScore += 1;
    }

    if (_quizScore >= 3) {
      _awardBadge('Pull Request Hero');
    }

    notifyListeners();
  }

  void resetQuizSession() {
    _quizScore = 0;
    _answeredQuestions = 0;
    notifyListeners();
  }

  void _awardBadge(String badgeName) {
    if (badgeNames.contains(badgeName)) {
      _earnedBadges.add(badgeName);
    }
  }
}
