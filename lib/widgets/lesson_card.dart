import 'package:flutter/material.dart';

import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    this.isLocked = false,
  });

  final Lesson lesson;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final levelColor = switch (lesson.level) {
      'Debutant' => const Color(0xFF45DCA3),
      'Intermediaire' => const Color(0xFF54B9FF),
      'Avance' => const Color(0xFFC589FF),
      _ => Colors.white,
    };

    return Card(
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    avatar: Icon(Icons.circle, size: 10, color: levelColor),
                    label: Text(lesson.level),
                  ),
                  const Spacer(),
                  if (isLocked)
                    const Icon(Icons.lock_outline)
                  else
                    IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.pinkAccent : null,
                      ),
                    ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ],
              ),
              Text(
                lesson.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isLocked
                    ? 'Lecon verrouillee. Termine la precedente pour la debloquer.'
                    : lesson.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: isLocked ? 0.65 : 0.82),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: lesson.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
