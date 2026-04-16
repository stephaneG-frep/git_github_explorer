import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state_scope.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          AnimatedBuilder(
            animation: appState,
            builder: (context, _) {
              final isFavorite = appState.isFavorite(lesson.id);
              return IconButton(
                onPressed: () => appState.toggleFavorite(lesson.id),
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
          Chip(label: Text('Niveau: ${lesson.level}')),
          const SizedBox(height: 12),
          Text(
            lesson.summary,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            lesson.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: lesson.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
        ],
      ),
    );
  }
}
