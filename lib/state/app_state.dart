import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../data/app_data.dart';
import '../services/local_storage_service.dart';

class AppState extends ChangeNotifier {
  static const int backupSchemaVersion = 3;

  final Set<String> _favoriteLessonIds = <String>{};
  final Set<String> _completedLessonIds = <String>{};
  final Set<String> _completedExerciseIds = <String>{};
  final Set<String> _completedCommandExerciseIds = <String>{};
  final Set<String> _completedChallengeIds = <String>{};
  final Set<String> _completedPathDayIds = <String>{};
  final Set<String> _completedMissionIds = <String>{};
  final Set<String> _earnedBadges = <String>{};
  final Map<String, int> _mistakeCounts = <String, int>{};

  int _quizScore = 0;
  int _answeredQuestions = 0;

  Set<String> get favoriteLessonIds => _favoriteLessonIds;
  Set<String> get completedLessonIds => _completedLessonIds;
  Set<String> get completedExerciseIds => _completedExerciseIds;
  Set<String> get completedCommandExerciseIds => _completedCommandExerciseIds;
  Set<String> get completedChallengeIds => _completedChallengeIds;
  Set<String> get completedPathDayIds => _completedPathDayIds;
  Set<String> get completedMissionIds => _completedMissionIds;
  Set<String> get earnedBadges => _earnedBadges;
  Map<String, int> get mistakeCounts => _mistakeCounts;

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
    final total =
        guidedExercises.length +
        commandExercises.length +
        simpleChallenges.length;
    final done =
        _completedExerciseIds.length +
        _completedCommandExerciseIds.length +
        _completedChallengeIds.length;
    if (total == 0) {
      return 0;
    }
    return done / total;
  }

  double get roadmapProgress {
    if (learningPathDays.isEmpty) {
      return 0;
    }
    return _completedPathDayIds.length / learningPathDays.length;
  }

  double get missionProgress {
    if (missionScenarios.isEmpty) {
      return 0;
    }
    return _completedMissionIds.length / missionScenarios.length;
  }

  double get globalProgress {
    final quizPart = quizQuestions.isEmpty
        ? 0
        : _answeredQuestions / quizQuestions.length;
    return ((learningProgress +
                practiceProgress +
                roadmapProgress +
                missionProgress +
                quizPart) /
            5)
        .clamp(0, 1);
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
      ..addAll(
        (data['completed_exercise_ids'] as List<dynamic>).cast<String>(),
      );

    _completedCommandExerciseIds
      ..clear()
      ..addAll(
        (data['completed_command_exercise_ids'] as List<dynamic>)
            .cast<String>(),
      );

    _completedChallengeIds
      ..clear()
      ..addAll(
        (data['completed_challenge_ids'] as List<dynamic>).cast<String>(),
      );

    _completedPathDayIds
      ..clear()
      ..addAll(
        (data['completed_path_day_ids'] as List<dynamic>).cast<String>(),
      );

    _completedMissionIds
      ..clear()
      ..addAll((data['completed_mission_ids'] as List<dynamic>).cast<String>());

    _earnedBadges
      ..clear()
      ..addAll((data['earned_badges'] as List<dynamic>).cast<String>());

    _quizScore = data['quiz_score'] as int;
    _answeredQuestions = data['answered_questions'] as int;
    _mistakeCounts
      ..clear()
      ..addEntries(
        ((data['mistake_counts'] as List<dynamic>).cast<String>()).map((line) {
          final parts = line.split(':');
          final key = parts.first;
          final value = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
          return MapEntry(key, value);
        }),
      );

    _sanitizeProgressData();

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

  void markCommandExerciseDone(String exerciseId) {
    _completedCommandExerciseIds.add(exerciseId);
    if (_completedCommandExerciseIds.length >= 2) {
      _awardBadge('Merge Tamer');
    }
    if (_completedCommandExerciseIds.length >= 5) {
      _awardBadge('GitHub Navigator');
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

  void markPathDayDone(String dayId) {
    _completedPathDayIds.add(dayId);
    if (_completedPathDayIds.length >= 7) {
      _awardBadge('Branch Explorer');
    }
    _afterMutation();
  }

  void markMissionDone(String missionId) {
    _completedMissionIds.add(missionId);
    if (_completedMissionIds.length >= 3) {
      _awardBadge('Pull Request Hero');
    }
    _afterMutation();
  }

  void answerQuiz({required bool isCorrect, required String conceptKey}) {
    _answeredQuestions += 1;
    if (isCorrect) {
      _quizScore += 1;
    } else {
      _mistakeCounts[conceptKey] = (_mistakeCounts[conceptKey] ?? 0) + 1;
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

  void resetMistakeInsights() {
    _mistakeCounts.clear();
    _afterMutation();
  }

  String exportProgressJson() {
    final payload = <String, dynamic>{
      'version': backupSchemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'favoriteLessonIds': _favoriteLessonIds.toList(),
      'completedLessonIds': _completedLessonIds.toList(),
      'completedExerciseIds': _completedExerciseIds.toList(),
      'completedCommandExerciseIds': _completedCommandExerciseIds.toList(),
      'completedChallengeIds': _completedChallengeIds.toList(),
      'completedPathDayIds': _completedPathDayIds.toList(),
      'completedMissionIds': _completedMissionIds.toList(),
      'earnedBadges': _earnedBadges.toList(),
      'quizScore': _quizScore,
      'answeredQuestions': _answeredQuestions,
      'mistakeCounts': _mistakeCounts,
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<bool> importProgressJson(String rawJson) async {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map) {
        return false;
      }
      final payload = decoded.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      _favoriteLessonIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'favoriteLessonIds',
              'favorite_lesson_ids',
            ]),
          ),
        );
      _completedLessonIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'completedLessonIds',
              'completed_lesson_ids',
            ]),
          ),
        );
      _completedExerciseIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'completedExerciseIds',
              'completed_exercise_ids',
            ]),
          ),
        );
      _completedCommandExerciseIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'completedCommandExerciseIds',
              'completed_command_exercise_ids',
            ]),
          ),
        );
      _completedChallengeIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'completedChallengeIds',
              'completed_challenge_ids',
            ]),
          ),
        );
      _completedPathDayIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'completedPathDayIds',
              'completed_path_day_ids',
            ]),
          ),
        );
      _completedMissionIds
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const [
              'completedMissionIds',
              'completed_mission_ids',
            ]),
          ),
        );
      _earnedBadges
        ..clear()
        ..addAll(
          _readStringSet(
            _readAliased(payload, const ['earnedBadges', 'earned_badges']),
          ),
        );

      _quizScore =
          (_readAliased(payload, const ['quizScore', 'quiz_score']) as num?)
              ?.toInt() ??
          0;
      _answeredQuestions =
          (_readAliased(payload, const [
                    'answeredQuestions',
                    'answered_questions',
                  ])
                  as num?)
              ?.toInt() ??
          0;

      _mistakeCounts
        ..clear()
        ..addAll(
          _readMistakeMap(
            _readAliased(payload, const ['mistakeCounts', 'mistake_counts']),
          ),
        );

      _sanitizeProgressData();

      _afterMutation();
      return true;
    } catch (_) {
      return false;
    }
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
      completedCommandExerciseIds: _completedCommandExerciseIds,
      completedChallengeIds: _completedChallengeIds,
      completedPathDayIds: _completedPathDayIds,
      completedMissionIds: _completedMissionIds,
      earnedBadges: _earnedBadges,
      quizScore: _quizScore,
      answeredQuestions: _answeredQuestions,
      mistakeCounts: _mistakeCounts,
    );
  }

  Set<String> _readStringSet(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toSet();
    }
    return <String>{};
  }

  Map<String, int> _readMistakeMap(dynamic value) {
    if (value is Map) {
      final result = <String, int>{};
      for (final entry in value.entries) {
        final key = entry.key.toString();
        final count = (entry.value as num?)?.toInt() ?? 0;
        result[key] = count < 0 ? 0 : count;
      }
      return result;
    }
    return <String, int>{};
  }

  dynamic _readAliased(Map<String, dynamic> source, List<String> aliases) {
    for (final key in aliases) {
      if (source.containsKey(key)) {
        return source[key];
      }
    }
    return null;
  }

  void _sanitizeProgressData() {
    _favoriteLessonIds.removeWhere((id) => !_knownLessonIds.contains(id));
    _completedLessonIds.removeWhere((id) => !_knownLessonIds.contains(id));
    _completedExerciseIds.removeWhere((id) => !_knownExerciseIds.contains(id));
    _completedCommandExerciseIds.removeWhere(
      (id) => !_knownCommandExerciseIds.contains(id),
    );
    _completedChallengeIds.removeWhere(
      (id) => !_knownChallengeIds.contains(id),
    );
    _completedPathDayIds.removeWhere((id) => !_knownPathDayIds.contains(id));
    _completedMissionIds.removeWhere((id) => !_knownMissionIds.contains(id));
    _earnedBadges.removeWhere((name) => !badgeNames.contains(name));
    _mistakeCounts.removeWhere((key, _) => !_knownConceptKeys.contains(key));

    final maxAnswers = quizQuestions.length;
    _answeredQuestions = _answeredQuestions.clamp(0, maxAnswers);
    _quizScore = _quizScore.clamp(0, _answeredQuestions);
  }

  Set<String> get _knownLessonIds => lessons.map((item) => item.id).toSet();
  Set<String> get _knownExerciseIds =>
      guidedExercises.map((item) => item.id).toSet();
  Set<String> get _knownCommandExerciseIds =>
      commandExercises.map((item) => item.id).toSet();
  Set<String> get _knownChallengeIds =>
      simpleChallenges.map((item) => item.id).toSet();
  Set<String> get _knownPathDayIds =>
      learningPathDays.map((item) => item.id).toSet();
  Set<String> get _knownMissionIds =>
      missionScenarios.map((item) => item.id).toSet();
  Set<String> get _knownConceptKeys =>
      quizQuestions.map((item) => item.conceptKey).toSet();
}
