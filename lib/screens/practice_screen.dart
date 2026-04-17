import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/command_exercise.dart';
import '../models/practice_item.dart';
import '../models/quiz_question.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../widgets/badge_strip.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/section_title.dart';
import 'command_exercise_screen.dart';
import 'git_simulator_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  QuizDifficulty _selectedDifficulty = QuizDifficulty.easy;
  String _currentQuestionId = quizQuestions.first.id;
  int? _selectedOption;
  bool _hasValidated = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final currentQuestion =
        quizQuestions.firstWhere((question) => question.id == _currentQuestionId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratiquer'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDifficulty = QuizDifficulty.easy;
                _currentQuestionId = _poolForDifficulty().first.id;
                _selectedOption = null;
                _hasValidated = false;
              });
              appState.resetQuizSession();
            },
            tooltip: 'Reinitialiser quiz',
            icon: const Icon(Icons.replay_rounded),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProgressOverviewCard(
                title: 'Progression pratique',
                progress: appState.practiceProgress,
                subtitle: 'Exercices et defis completes',
              ),
              const SizedBox(height: 12),
              _QuizSection(
                question: currentQuestion,
                selectedOption: _selectedOption,
                hasValidated: _hasValidated,
                score: appState.quizScore,
                answered: appState.answeredQuestions,
                total: quizQuestions.length,
                selectedDifficulty: _selectedDifficulty,
                onDifficultyChanged: (difficulty) {
                  final pool = _poolForDifficulty(difficulty);
                  setState(() {
                    _selectedDifficulty = difficulty;
                    _currentQuestionId = _pickBestQuestionId(
                      appState: appState,
                      pool: pool,
                      excludedId: null,
                    );
                    _selectedOption = null;
                    _hasValidated = false;
                  });
                },
                onSelect: (index) {
                  if (_hasValidated) {
                    return;
                  }
                  setState(() => _selectedOption = index);
                },
                onValidate: () {
                  if (_selectedOption == null || _hasValidated) {
                    return;
                  }

                  final isCorrect = _selectedOption == currentQuestion.correctIndex;
                  appState.answerQuiz(
                    isCorrect: isCorrect,
                    conceptKey: currentQuestion.conceptKey,
                  );
                  setState(() => _hasValidated = true);
                },
                onNext: () {
                  if (!_hasValidated) {
                    return;
                  }

                  final isCorrect = _selectedOption == currentQuestion.correctIndex;
                  final nextId = _chooseNextQuestion(
                    appState: appState,
                    current: currentQuestion,
                    lastAnswerCorrect: isCorrect,
                  );

                  setState(() {
                    _currentQuestionId = nextId;
                    _selectedOption = null;
                    _hasValidated = false;
                  });
                },
              ),
              const SizedBox(height: 12),
              _MistakeInsightsCard(appState: appState),
              const SizedBox(height: 14),
              _SectionPanel(
                title: 'Exercices guides',
                subtitle: '${appState.completedExerciseIds.length}/${guidedExercises.length} termines',
                initiallyExpanded: true,
                child: Column(
                  children: guidedExercises
                      .map(
                        (item) => _PracticeCard(
                          item: item,
                          isDone: appState.completedExerciseIds.contains(item.id),
                          onDone: () => appState.markExerciseDone(item.id),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              _SectionPanel(
                title: 'Exercices par commande',
                subtitle:
                    '${appState.completedCommandExerciseIds.length}/${commandExercises.length} termines',
                child: Column(
                  children: commandExercises
                      .map(
                        (exercise) => _CommandExerciseCard(
                          exercise: exercise,
                          isDone: appState.completedCommandExerciseIds.contains(exercise.id),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              _SectionPanel(
                title: 'Defis simples',
                subtitle:
                    '${appState.completedChallengeIds.length}/${simpleChallenges.length} termines',
                child: Column(
                  children: simpleChallenges
                      .map(
                        (item) => _PracticeCard(
                          item: item,
                          isDone: appState.completedChallengeIds.contains(item.id),
                          onDone: () => appState.markChallengeDone(item.id),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              const SectionTitle(title: 'Simulateur interactif'),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.terminal_rounded),
                  title: const Text('Lancer le mini simulateur Git'),
                  subtitle: const Text('Scenario guide: init -> commit -> branch -> merge -> push'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GitSimulatorScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const SectionTitle(title: 'Badges simules'),
              const SizedBox(height: 8),
              BadgeStrip(badges: appState.earnedBadges),
            ],
          );
        },
      ),
    );
  }

  List<QuizQuestion> _poolForDifficulty([QuizDifficulty? difficulty]) {
    final target = difficulty ?? _selectedDifficulty;
    final pool = quizQuestions
        .where((question) => question.difficulty == target)
        .toList(growable: false);
    return pool.isEmpty ? quizQuestions : pool;
  }

  String _chooseNextQuestion({
    required AppState appState,
    required QuizQuestion current,
    required bool lastAnswerCorrect,
  }) {
    final pool = _poolForDifficulty();

    if (!lastAnswerCorrect) {
      final sameConcept = pool.where(
        (question) =>
            question.conceptKey == current.conceptKey && question.id != current.id,
      );
      if (sameConcept.isNotEmpty) {
        return sameConcept.first.id;
      }
    }

    return _pickBestQuestionId(
      appState: appState,
      pool: pool,
      excludedId: current.id,
    );
  }

  String _pickBestQuestionId({
    required AppState appState,
    required List<QuizQuestion> pool,
    required String? excludedId,
  }) {
    if (pool.isEmpty) {
      return quizQuestions.first.id;
    }

    final candidates = pool.where((question) => question.id != excludedId).toList();
    final safeCandidates = candidates.isEmpty ? pool : candidates;

    safeCandidates.sort((a, b) {
      final aMistakes = appState.mistakeCounts[a.conceptKey] ?? 0;
      final bMistakes = appState.mistakeCounts[b.conceptKey] ?? 0;
      return bMistakes.compareTo(aMistakes);
    });

    return safeCandidates.first.id;
  }
}

class _QuizSection extends StatelessWidget {
  const _QuizSection({
    required this.question,
    required this.selectedOption,
    required this.hasValidated,
    required this.score,
    required this.answered,
    required this.total,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.onSelect,
    required this.onValidate,
    required this.onNext,
  });

  final QuizQuestion question;
  final int? selectedOption;
  final bool hasValidated;
  final int score;
  final int answered;
  final int total;
  final QuizDifficulty selectedDifficulty;
  final ValueChanged<QuizDifficulty> onDifficultyChanged;
  final ValueChanged<int> onSelect;
  final VoidCallback onValidate;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedOption == question.correctIndex;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Quiz QCM adaptatif'),
            const SizedBox(height: 4),
            Text('Score: $score / $answered  |  Questions: $answered / $total'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: QuizDifficulty.values.map((difficulty) {
                final selected = selectedDifficulty == difficulty;
                return ChoiceChip(
                  label: Text(_difficultyLabel(difficulty)),
                  selected: selected,
                  onSelected: (_) => onDifficultyChanged(difficulty),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Concept cible: ${question.conceptKey}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
            ),
            const SizedBox(height: 10),
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedOption == index;
              final isAnswer = question.correctIndex == index;

              Color? tileColor;
              if (hasValidated && isAnswer) {
                tileColor = Colors.green.withValues(alpha: 0.18);
              } else if (hasValidated && isSelected && !isAnswer) {
                tileColor = Colors.red.withValues(alpha: 0.16);
              }

              return Card(
                color: tileColor,
                child: ListTile(
                  onTap: () => onSelect(index),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(question.options[index]),
                ),
              );
            }),
            if (hasValidated) ...[
              const SizedBox(height: 8),
              Text(
                isCorrect ? 'Bonne reponse!' : 'Pas encore, continue.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isCorrect ? Colors.greenAccent : Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 6),
              Text(question.explanation),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                FilledButton(
                  onPressed: onValidate,
                  child: const Text('Valider'),
                ),
                OutlinedButton(
                  onPressed: onNext,
                  child: const Text('Question suivante'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _difficultyLabel(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return 'Facile';
      case QuizDifficulty.medium:
        return 'Moyen';
      case QuizDifficulty.hard:
        return 'Difficile';
    }
  }
}

class _MistakeInsightsCard extends StatelessWidget {
  const _MistakeInsightsCard({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final sorted = appState.mistakeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.where((entry) => entry.value > 0).take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: SectionTitle(title: 'Erreurs frequentes')),
                TextButton(
                  onPressed: appState.resetMistakeInsights,
                  child: const Text('Effacer'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (top.isEmpty)
              const Text('Aucune erreur recurrente pour le moment, continue comme ca.')
            else
              ...top.map((entry) {
                final tip = conceptTips[entry.key] ?? 'Relis la lecon associee a ce concept.';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}  •  ${entry.value} erreurs',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(tip),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.item,
    required this.isDone,
    required this.onDone,
  });

  final PracticeItem item;
  final bool isDone;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? Colors.greenAccent : Colors.white54,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.goal),
            const SizedBox(height: 10),
            ...item.steps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(step)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isDone ? null : onDone,
                icon: Icon(isDone ? Icons.check : Icons.play_arrow),
                label: Text(isDone ? 'Termine' : 'Marquer termine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandExerciseCard extends StatelessWidget {
  const _CommandExerciseCard({
    required this.exercise,
    required this.isDone,
  });

  final CommandExercise exercise;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_circle : Icons.terminal_rounded,
          color: isDone ? Colors.greenAccent : null,
        ),
        title: Text(exercise.title),
        subtitle: Text('${exercise.command}\n${exercise.goal}'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommandExerciseScreen(exercise: exercise),
            ),
          );
        },
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.title,
    required this.subtitle,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text(title),
        subtitle: Text(subtitle),
        childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        children: [child],
      ),
    );
  }
}
