import 'package:flutter/material.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({
    super.key,
    required this.title,
    required this.progress,
    required this.subtitle,
  });

  final String title;
  final double progress;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Semantics(
      label: '$title, progression $pct pourcent. $subtitle',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text('$pct%'),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.74)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
