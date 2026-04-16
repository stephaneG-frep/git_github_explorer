import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/lesson.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../widgets/lesson_card.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/section_title.dart';
import 'command_guide_screen.dart';
import 'lesson_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _query = '';
  String _levelFilter = 'Tous';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final orderedLessons = _sortLessons(lessons);
    final filteredLessons = _filterLessons(orderedLessons, _query, _levelFilter);
    final beginnerLessons =
        filteredLessons.where((lesson) => lesson.level == 'Debutant').toList();
    final intermediateLessons =
        filteredLessons.where((lesson) => lesson.level == 'Intermediaire').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Apprendre')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProgressOverviewCard(
                title: 'Progression apprentissage',
                progress: appState.learningProgress,
                subtitle:
                    '${appState.completedLessonIds.length}/${lessons.length} lecons lues',
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.terminal_rounded),
                  title: const Text('Apprendre les commandes Git'),
                  subtitle: const Text(
                    'Guide pedagogique: a quoi ca sert, quand l utiliser, exemple',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CommandGuideScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un concept (commit, branch, pull...)',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: ['Tous', 'Debutant', 'Intermediaire'].map((level) {
                  return ChoiceChip(
                    label: Text(level),
                    selected: _levelFilter == level,
                    onSelected: (_) => setState(() => _levelFilter = level),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const SectionTitle(title: 'Lecons organisees'),
              const SizedBox(height: 8),
              if (filteredLessons.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Aucune lecon ne correspond a ta recherche.'),
                  ),
                )
              else
                ..._buildLessonGroup(
                  context: context,
                  appState: appState,
                  title: 'Debutant',
                  items: beginnerLessons,
                ),
              if (filteredLessons.isNotEmpty)
                ..._buildLessonGroup(
                  context: context,
                  appState: appState,
                  title: 'Intermediaire',
                  items: intermediateLessons,
                ),
            ],
          );
        },
      ),
    );
  }

  List<Lesson> _sortLessons(List<Lesson> source) {
    final copy = [...source];
    copy.sort((a, b) {
      final levelDiff = _levelRank(a.level).compareTo(_levelRank(b.level));
      if (levelDiff != 0) {
        return levelDiff;
      }
      return a.title.compareTo(b.title);
    });
    return copy;
  }

  int _levelRank(String level) {
    switch (level) {
      case 'Debutant':
        return 0;
      case 'Intermediaire':
        return 1;
      default:
        return 2;
    }
  }

  List<Lesson> _filterLessons(List<Lesson> source, String query, String levelFilter) {
    final q = query.trim().toLowerCase();
    final levelFiltered = levelFilter == 'Tous'
        ? source
        : source.where((lesson) => lesson.level == levelFilter).toList();

    if (q.isEmpty) {
      return levelFiltered;
    }

    return levelFiltered.where((lesson) {
      final inTitle = lesson.title.toLowerCase().contains(q);
      final inSummary = lesson.summary.toLowerCase().contains(q);
      final inTags = lesson.tags.any((tag) => tag.toLowerCase().contains(q));
      return inTitle || inSummary || inTags;
    }).toList();
  }

  List<Widget> _buildLessonGroup({
    required BuildContext context,
    required AppState appState,
    required String title,
    required List<Lesson> items,
  }) {
    if (items.isEmpty) {
      return const [];
    }

    return [
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
      ...items.map(
        (lesson) => LessonCard(
          lesson: lesson,
          isFavorite: appState.isFavorite(lesson.id),
          isLocked: false,
          onFavorite: () => appState.toggleFavorite(lesson.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonDetailScreen(lesson: lesson),
              ),
            );
          },
        ),
      ),
    ];
  }
}
