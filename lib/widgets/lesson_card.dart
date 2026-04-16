import 'package:flutter/material.dart';

import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  final Lesson lesson;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(label: Text(lesson.level)),
                  const Spacer(),
                  IconButton(
                    onPressed: onFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pinkAccent : null,
                    ),
                  ),
                ],
              ),
              Text(
                lesson.title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                lesson.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: lesson.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
