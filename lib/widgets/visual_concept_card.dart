import 'package:flutter/material.dart';

import '../models/visual_concept.dart';

class VisualConceptCard extends StatelessWidget {
  const VisualConceptCard({super.key, required this.concept});

  final VisualConcept concept;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              concept.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(concept.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < concept.nodes.length; i++)
                  _NodePill(label: concept.nodes[i], isKeyNode: i == concept.nodes.length - 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NodePill extends StatelessWidget {
  const _NodePill({required this.label, required this.isKeyNode});

  final String label;
  final bool isKeyNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isKeyNode
            ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
