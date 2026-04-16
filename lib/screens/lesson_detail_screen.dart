import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state_scope.dart';

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _markedRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_markedRead) {
      AppStateScope.of(context).markLessonRead(widget.lesson.id);
      _markedRead = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          AnimatedBuilder(
            animation: appState,
            builder: (context, _) {
              final isFavorite = appState.isFavorite(widget.lesson.id);
              return IconButton(
                onPressed: () => appState.toggleFavorite(widget.lesson.id),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.pinkAccent : null,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Chip(label: Text('Niveau: ${widget.lesson.level}')),
          const SizedBox(height: 12),
          Text(
            widget.lesson.summary,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            widget.lesson.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: widget.lesson.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
        ],
      ),
    );
  }
}
