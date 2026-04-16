import 'package:flutter/material.dart';

class BadgeStrip extends StatelessWidget {
  const BadgeStrip({super.key, required this.badges});

  final Set<String> badges;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Aucun badge pour le moment. Continue les exercices pour debloquer des recompenses.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: badges
              .map(
                (badge) => Chip(
                  avatar: const Icon(Icons.workspace_premium, size: 18),
                  label: Text(badge),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
