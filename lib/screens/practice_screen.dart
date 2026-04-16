import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/practice_item.dart';
import '../models/quiz_question.dart';
import '../state/app_state_scope.dart';
import '../widgets/badge_strip.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/section_title.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _questionIndex = 0;
  int? _selectedOption;
  bool _hasValidated = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final currentQuestion = quizQuestions[_questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratiquer'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _questionIndex = 0;
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
                  appState.answerQuiz(isCorrect: isCorrect);
                  setState(() => _hasValidated = true);
                },
                onNext: () {
                  if (!_hasValidated) {
                    return;
                  }

                  setState(() {
                    _questionIndex = (_questionIndex + 1) % quizQuestions.length;
                    _selectedOption = null;
                    _hasValidated = false;
                  });
                },
              ),
              const SizedBox(height: 14),
              const SectionTitle(title: 'Exercices guides'),
              const SizedBox(height: 8),
              ...guidedExercises.map(
                (item) => _PracticeCard(
                  item: item,
                  isDone: appState.completedExerciseIds.contains(item.id),
                  onDone: () => appState.markExerciseDone(item.id),
                ),
              ),
              const SizedBox(height: 8),
              const SectionTitle(title: 'Defis simples'),
              const SizedBox(height: 8),
              ...simpleChallenges.map(
                (item) => _PracticeCard(
                  item: item,
                  isDone: appState.completedChallengeIds.contains(item.id),
                  onDone: () => appState.markChallengeDone(item.id),
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
}

class _QuizSection extends StatelessWidget {
  const _QuizSection({
    required this.question,
    required this.selectedOption,
    required this.hasValidated,
    required this.score,
    required this.answered,
    required this.total,
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
            const SectionTitle(title: 'Quiz QCM'),
            const SizedBox(height: 4),
            Text('Score: $score / $answered  |  Questions: $answered / $total'),
            const SizedBox(height: 12),
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium,
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
