import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../widgets/section_title.dart';
import '../widgets/visual_concept_card.dart';

class VisualizerScreen extends StatelessWidget {
  const VisualizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualiser')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle(title: 'Concepts Git en schema simple'),
          const SizedBox(height: 8),
          ...visualConcepts.map((concept) => VisualConceptCard(concept: concept)),
        ],
      ),
    );
  }
}
