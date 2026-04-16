import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/app_data.dart';
import '../services/local_storage_service.dart';

class AppState extends ChangeNotifier {
  final Set<String> _favoriteLessonIds = <String>{};
  final Set<String> _completedLessonIds = <String>{};
  final Set<String> _completedExerciseIds = <String>{};
  final Set<String> _completedChallengeIds = <String>{};
  final Set<String> _earnedBadges = <String>{};

  int _quizScore = 0;
  int _answeredQuestions = 0;

  Set<String> get favoriteLessonIds => _favoriteLessonIds;
  Set<String> get completedLessonIds => _completedLessonIds;
  Set<String> get completedExerciseIds => _completedExerciseIds;
  Set<String> get completedChallengeIds => _completedChallengeIds;
  Set<String> get earnedBadges => _earnedBadges;

  int get quizScore => _quizScore;
  int get answeredQuestions => _answeredQuestions;

  int get unlockedLessonCount {
    if (lessons.isEmpty) {
      return 0;
    }
    return (_completedLessonIds.length + 1).clamp(1, lessons.length);
  }

  double get learningProgress {
    final total = lessons.length;
    if (total == 0) {
      return 0;
    }
    return _completedLessonIds.length / total;
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

  Future<void> loadPersistedState() async {
    final data = await LocalStorageService.loadAppState();

    _favoriteLessonIds
      ..clear()
      ..addAll((data['favorite_lesson_ids'] as List<dynamic>).cast<String>());

    _completedLessonIds
      ..clear()
      ..addAll((data['completed_lesson_ids'] as List<dynamic>).cast<String>());

    _completedExerciseIds
      ..clear()
      ..addAll((data['completed_exercise_ids'] as List<dynamic>).cast<String>());

    _completedChallengeIds
      ..clear()
      ..addAll((data['completed_challenge_ids'] as List<dynamic>).cast<String>());

    _earnedBadges
      ..clear()
      ..addAll((data['earned_badges'] as List<dynamic>).cast<String>());

    _quizScore = data['quiz_score'] as int;
    _answeredQuestions = data['answered_questions'] as int;

    notifyListeners();
  }

  bool isFavorite(String lessonId) => _favoriteLessonIds.contains(lessonId);

  bool isLessonUnlocked(String lessonId) {
    final index = lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (index == -1) {
      return false;
    }
    return index < unlockedLessonCount;
  }

  void toggleFavorite(String lessonId) {
    if (_favoriteLessonIds.contains(lessonId)) {
      _favoriteLessonIds.remove(lessonId);
    } else {
      _favoriteLessonIds.add(lessonId);
      _awardBadge('GitHub Navigator');
    }
    _afterMutation();
  }

  void markLessonRead(String lessonId) {
    _completedLessonIds.add(lessonId);
    if (_completedLessonIds.isNotEmpty) {
      _awardBadge('Commit Rookie');
    }
    if (_completedLessonIds.length >= 3) {
      _awardBadge('Branch Explorer');
    }
    _afterMutation();
  }

  void markExerciseDone(String exerciseId) {
    _completedExerciseIds.add(exerciseId);
    if (_completedExerciseIds.isNotEmpty) {
      _awardBadge('Commit Rookie');
    }
    if (_completedExerciseIds.length >= 2) {
      _awardBadge('Branch Explorer');
    }
    _afterMutation();
  }

  void markChallengeDone(String challengeId) {
    _completedChallengeIds.add(challengeId);
    if (_completedChallengeIds.isNotEmpty) {
      _awardBadge('Merge Tamer');
    }
    _afterMutation();
  }

  void answerQuiz({required bool isCorrect}) {
    _answeredQuestions += 1;
    if (isCorrect) {
      _quizScore += 1;
    }

    if (_quizScore >= 3) {
      _awardBadge('Pull Request Hero');
    }

    _afterMutation();
  }

  void resetQuizSession() {
    _quizScore = 0;
    _answeredQuestions = 0;
    _afterMutation();
  }

  void _awardBadge(String badgeName) {
    if (badgeNames.contains(badgeName)) {
      _earnedBadges.add(badgeName);
    }
  }

  void _afterMutation() {
    notifyListeners();
    unawaited(_persist());
  }

  Future<void> _persist() {
    return LocalStorageService.saveAppState(
      favoriteLessonIds: _favoriteLessonIds,
      completedLessonIds: _completedLessonIds,
      completedExerciseIds: _completedExerciseIds,
      completedChallengeIds: _completedChallengeIds,
      earnedBadges: _earnedBadges,
      quizScore: _quizScore,
      answeredQuestions: _answeredQuestions,
    );
  }
}
