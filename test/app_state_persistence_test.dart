import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_github_explorer/data/app_data.dart';
import 'package:git_github_explorer/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'import accepts legacy snake_case keys and sanitizes unknown ids',
    () async {
      final state = AppState();

      final payload = {
        'version': 1,
        'favorite_lesson_ids': ['git-basics', 'unknown-lesson'],
        'completed_lesson_ids': ['git-basics', 'fake-lesson'],
        'completed_exercise_ids': ['e1', 'not-real'],
        'completed_command_exercise_ids': ['ce-init', 'ghost-cmd'],
        'completed_challenge_ids': ['c1', 'ghost-challenge'],
        'completed_path_day_ids': ['day-1', 'day-999'],
        'completed_mission_ids': ['m1', 'm404'],
        'earned_badges': ['Commit Rookie', 'Badge Inconnu'],
        'quiz_score': 99,
        'answered_questions': 999,
        'mistake_counts': {'git-basics': 2, 'unknown-concept': 8},
      };

      final imported = await state.importProgressJson(jsonEncode(payload));

      expect(imported, isTrue);
      expect(state.favoriteLessonIds, contains('git-basics'));
      expect(state.favoriteLessonIds, isNot(contains('unknown-lesson')));
      expect(state.completedLessonIds, contains('git-basics'));
      expect(state.completedLessonIds, isNot(contains('fake-lesson')));
      expect(state.completedExerciseIds, contains('e1'));
      expect(state.completedExerciseIds, isNot(contains('not-real')));
      expect(state.completedCommandExerciseIds, contains('ce-init'));
      expect(state.completedCommandExerciseIds, isNot(contains('ghost-cmd')));
      expect(state.completedChallengeIds, contains('c1'));
      expect(state.completedChallengeIds, isNot(contains('ghost-challenge')));
      expect(state.completedPathDayIds, contains('day-1'));
      expect(state.completedPathDayIds, isNot(contains('day-999')));
      expect(state.completedMissionIds, contains('m1'));
      expect(state.completedMissionIds, isNot(contains('m404')));
      expect(state.earnedBadges, contains('Commit Rookie'));
      expect(state.earnedBadges, isNot(contains('Badge Inconnu')));
      expect(state.answeredQuestions, lessThanOrEqualTo(quizQuestions.length));
      expect(state.quizScore, lessThanOrEqualTo(state.answeredQuestions));
      expect(state.mistakeCounts.keys, contains('git-basics'));
      expect(state.mistakeCounts.keys, isNot(contains('unknown-concept')));
    },
  );

  test('export includes schema metadata', () {
    final state = AppState();

    final raw = state.exportProgressJson();
    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    expect(decoded['version'], AppState.backupSchemaVersion);
    expect(decoded['exportedAt'], isA<String>());
    expect(DateTime.tryParse(decoded['exportedAt'] as String), isNotNull);
  });

  test('loadPersistedState sanitizes persisted values', () async {
    SharedPreferences.setMockInitialValues({
      'favorite_lesson_ids': ['git-basics', 'invalid-lesson'],
      'completed_lesson_ids': ['github-basics', 'invalid-lesson'],
      'completed_exercise_ids': ['e1', 'invalid-ex'],
      'completed_command_exercise_ids': ['ce-init', 'invalid-cmd'],
      'completed_challenge_ids': ['c1', 'invalid-ch'],
      'completed_path_day_ids': ['day-1', 'invalid-day'],
      'completed_mission_ids': ['m1', 'invalid-mission'],
      'earned_badges': ['Commit Rookie', 'Wrong Badge'],
      'quiz_score': 999,
      'answered_questions': 999,
      'mistake_counts': ['git-basics:3', 'invalid-key:2'],
    });

    final state = AppState();
    await state.loadPersistedState();

    expect(state.favoriteLessonIds, contains('git-basics'));
    expect(state.favoriteLessonIds, isNot(contains('invalid-lesson')));
    expect(state.completedLessonIds, contains('github-basics'));
    expect(state.completedLessonIds, isNot(contains('invalid-lesson')));
    expect(state.completedExerciseIds, contains('e1'));
    expect(state.completedExerciseIds, isNot(contains('invalid-ex')));
    expect(state.completedCommandExerciseIds, contains('ce-init'));
    expect(state.completedCommandExerciseIds, isNot(contains('invalid-cmd')));
    expect(state.completedChallengeIds, contains('c1'));
    expect(state.completedChallengeIds, isNot(contains('invalid-ch')));
    expect(state.completedPathDayIds, contains('day-1'));
    expect(state.completedPathDayIds, isNot(contains('invalid-day')));
    expect(state.completedMissionIds, contains('m1'));
    expect(state.completedMissionIds, isNot(contains('invalid-mission')));
    expect(state.earnedBadges, contains('Commit Rookie'));
    expect(state.earnedBadges, isNot(contains('Wrong Badge')));
    expect(state.answeredQuestions, lessThanOrEqualTo(quizQuestions.length));
    expect(state.quizScore, lessThanOrEqualTo(state.answeredQuestions));
    expect(state.mistakeCounts.keys, contains('git-basics'));
    expect(state.mistakeCounts.keys, isNot(contains('invalid-key')));
  });
}
