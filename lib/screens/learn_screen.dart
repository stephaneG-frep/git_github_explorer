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
  final TextEditingController _searchController = TextEditingController();
  static const List<String> _orderedLevels = [
    'Debutant',
    'Intermediaire',
    'Avance',
  ];
  static const List<String> _recommendedOrder = [
    'git-basics',
    'github-basics',
    'git-vs-github',
    'clone',
    'remote-origin',
    'commit',
    'gitignore',
    'push-pull',
    'daily-workflow',
    'branch-merge',
    'fork-pr',
    'read-history',
    'stash',
    'rebase-basics',
    'revert-vs-reset',
    'conflicts-resolution',
    'interactive-rebase',
    'merge-vs-rebase-vs-cherry-pick',
    'resolve-complex-conflicts',
    'safe-history-rewrite',
    'reflog-recovery',
    'bisect-debugging',
    'git-blame-basics',
    'worktree-parallel',
    'submodule-basics',
    'sparse-checkout',
    'rerere-conflicts',
    'git-hooks-quality',
    'commit-signing',
    'release-tagging-strategy',
    'hotfix-release-flow',
    'fork-pr-advanced',
  ];
  String _query = '';
  String _levelFilter = 'Tous';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final orderedLessons = _sortLessons(lessons);
    final filteredLessons = _filterLessons(
      orderedLessons,
      _query,
      _levelFilter,
    );
    final groupedLessons = _groupByLevel(filteredLessons);
    final beginnerCount = groupedLessons['Debutant']?.length ?? 0;
    final intermediateCount = groupedLessons['Intermediaire']?.length ?? 0;
    final advancedCount = groupedLessons['Avance']?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Apprendre')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF20365C),
                      Color(0xFF4B2FA6),
                      Color(0xFF0D7C8E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apprendre Git pas a pas',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Un parcours progressif, du premier commit aux workflows avances.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _StatPill(
                            label: 'Debutant',
                            value: beginnerCount,
                            icon: Icons.school_outlined,
                          ),
                          _StatPill(
                            label: 'Intermediaire',
                            value: intermediateCount,
                            icon: Icons.build_circle_outlined,
                          ),
                          _StatPill(
                            label: 'Avance',
                            value: advancedCount,
                            icon: Icons.rocket_launch_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                      MaterialPageRoute(
                        builder: (_) => const CommandGuideScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.route_rounded),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Parcours conseille: Debutant -> Intermediaire -> Avance',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                          hintText:
                              'Rechercher un concept (commit, branch, pull...)',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: ['Tous', ..._orderedLevels].map((level) {
                          return ChoiceChip(
                            label: Text(level),
                            selected: _levelFilter == level,
                            onSelected: (_) =>
                                setState(() => _levelFilter = level),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${filteredLessons.length} resultat(s)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _query = '';
                        _levelFilter = 'Tous';
                      });
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                    label: const Text('Reset filtres'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
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
                ..._orderedLevels.expand(
                  (level) => _buildLessonGroup(
                    context: context,
                    appState: appState,
                    title: level,
                    items: groupedLessons[level] ?? const [],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Lesson> _sortLessons(List<Lesson> source) {
    final orderById = <String, int>{
      for (var i = 0; i < _recommendedOrder.length; i++)
        _recommendedOrder[i]: i,
    };
    final copy = [...source];
    copy.sort((a, b) {
      final levelDiff = _levelRank(a.level).compareTo(_levelRank(b.level));
      if (levelDiff != 0) {
        return levelDiff;
      }
      final aOrder = orderById[a.id] ?? 9999;
      final bOrder = orderById[b.id] ?? 9999;
      final orderDiff = aOrder.compareTo(bOrder);
      if (orderDiff != 0) {
        return orderDiff;
      }
      return a.title.compareTo(b.title);
    });
    return copy;
  }

  int _levelRank(String level) {
    final index = _orderedLevels.indexOf(level);
    if (index >= 0) {
      return index;
    }
    return _orderedLevels.length;
  }

  List<Lesson> _filterLessons(
    List<Lesson> source,
    String query,
    String levelFilter,
  ) {
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

  Map<String, List<Lesson>> _groupByLevel(List<Lesson> items) {
    final map = <String, List<Lesson>>{};
    for (final level in _orderedLevels) {
      map[level] = <Lesson>[];
    }

    for (final lesson in items) {
      map.putIfAbsent(lesson.level, () => <Lesson>[]).add(lesson);
    }

    return map;
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
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _levelColor(title).withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _levelIcon(title),
                size: 18,
                color: _levelColor(title),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${items.length})',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          _levelDescription(title),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
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

  String _levelDescription(String level) {
    switch (level) {
      case 'Debutant':
        return 'Fondations et commandes indispensables.';
      case 'Intermediaire':
        return 'Workflow d equipe, analyse d historique et annulation securisee.';
      case 'Avance':
        return 'Strategie, secours, industrialisation et collaboration pro.';
      default:
        return '';
    }
  }

  Color _levelColor(String level) {
    switch (level) {
      case 'Debutant':
        return const Color(0xFF45DCA3);
      case 'Intermediaire':
        return const Color(0xFF54B9FF);
      case 'Avance':
        return const Color(0xFFC589FF);
      default:
        return Colors.white;
    }
  }

  IconData _levelIcon(String level) {
    switch (level) {
      case 'Debutant':
        return Icons.auto_stories_rounded;
      case 'Intermediaire':
        return Icons.account_tree_rounded;
      case 'Avance':
        return Icons.bolt_rounded;
      default:
        return Icons.school_outlined;
    }
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text('$label: $value'),
        ],
      ),
    );
  }
}
