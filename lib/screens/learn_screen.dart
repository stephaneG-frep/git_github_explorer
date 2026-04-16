import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/lesson.dart';
import '../state/app_state_scope.dart';
import '../widgets/lesson_card.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/section_title.dart';
import 'lesson_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final filteredLessons = _filterLessons(lessons, _query);

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
                    '${appState.completedLessonIds.length}/${lessons.length} lecons lues | ${appState.unlockedLessonCount} debloquees',
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un concept (commit, branch, pull...)',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              const SectionTitle(title: 'Lecons'),
              const SizedBox(height: 8),
              if (filteredLessons.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Aucune lecon ne correspond a ta recherche.'),
                  ),
                )
              else
                ...filteredLessons.map(
                  (lesson) {
                    final isLocked = !appState.isLessonUnlocked(lesson.id);
                    return LessonCard(
                      lesson: lesson,
                      isFavorite: appState.isFavorite(lesson.id),
                      isLocked: isLocked,
                      onFavorite: () => appState.toggleFavorite(lesson.id),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LessonDetailScreen(lesson: lesson),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  List<Lesson> _filterLessons(List<Lesson> source, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return source;
    }

    return source.where((lesson) {
      final inTitle = lesson.title.toLowerCase().contains(q);
      final inSummary = lesson.summary.toLowerCase().contains(q);
      final inTags = lesson.tags.any((tag) => tag.toLowerCase().contains(q));
      return inTitle || inSummary || inTags;
    }).toList();
  }
}
