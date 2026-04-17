import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/command_exercise.dart';
import '../models/git_command.dart';
import 'command_exercise_screen.dart';

class CommandGuideScreen extends StatefulWidget {
  const CommandGuideScreen({super.key});

  @override
  State<CommandGuideScreen> createState() => _CommandGuideScreenState();
}

class _CommandGuideScreenState extends State<CommandGuideScreen> {
  String _query = '';
  String _category = 'Toutes';

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Toutes',
      ...{...gitCommands.map((item) => item.category)}.toList()..sort(),
    ];
    final filtered = _filter(gitCommands, _query, _category);

    return Scaffold(
      appBar: AppBar(title: const Text('Guide Commandes Git')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroHeader(commandCount: gitCommands.length, categoryCount: categories.length - 1),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher une commande (init, add, merge...)',
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              return ChoiceChip(
                label: Text(cat),
                selected: _category == cat,
                onSelected: (_) => setState(() => _category = cat),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Aucune commande trouvee avec ce filtre.'),
              ),
            )
          else
            ...filtered.map((item) => _CommandCard(item: item, onPractice: () => _openPractice(item))),
        ],
      ),
    );
  }

  List<GitCommand> _filter(List<GitCommand> source, String query, String category) {
    final q = query.trim().toLowerCase();
    final categoryFiltered = category == 'Toutes'
        ? source
        : source.where((item) => item.category == category).toList();

    if (q.isEmpty) {
      return categoryFiltered;
    }

    return categoryFiltered.where((item) {
      return item.command.toLowerCase().contains(q) ||
          item.title.toLowerCase().contains(q) ||
          item.what.toLowerCase().contains(q) ||
          item.when.toLowerCase().contains(q);
    }).toList();
  }

  void _openPractice(GitCommand command) {
    final exercise = _findMatchingExercise(command);
    if (exercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas encore d exercice pour cette commande.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CommandExerciseScreen(exercise: exercise)),
    );
  }

  CommandExercise? _findMatchingExercise(GitCommand command) {
    final normalized = command.command.toLowerCase();
    for (final exercise in commandExercises) {
      final ex = exercise.command.toLowerCase();
      if (normalized.contains(ex) || ex.contains(normalized.split(' ').first)) {
        return exercise;
      }
    }
    return null;
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.commandCount, required this.categoryCount});

  final int commandCount;
  final int categoryCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF6D28D9), Color(0xFF0F766E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apprends les commandes comme un pro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text('Explication simple, usage concret, puis exercice immediat.'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                Chip(label: Text('$commandCount commandes')),
                Chip(label: Text('$categoryCount categories')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandCard extends StatelessWidget {
  const _CommandCard({required this.item, required this.onPractice});

  final GitCommand item;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(item.category);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.command,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Chip(label: Text(item.category)),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _LabelValue(label: 'A quoi ca sert', value: item.what),
            _LabelValue(label: 'Quand l utiliser', value: item.when),
            _LabelValue(label: 'Exemple', value: item.example, mono: true),
            _LabelValue(label: 'Conseil debutant', value: item.tip),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: onPractice,
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Pratiquer cette commande'),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Base':
        return const Color(0xFF22C55E);
      case 'Branches':
      case 'Fusion':
        return const Color(0xFF3B82F6);
      case 'Remote':
        return const Color(0xFF06B6D4);
      case 'Correction':
        return const Color(0xFFF97316);
      case 'Release':
        return const Color(0xFFA855F7);
      default:
        return const Color(0xFF64748B);
    }
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.72))),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontFamily: mono ? 'monospace' : null)),
        ],
      ),
    );
  }
}
