import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/git_command.dart';

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
    final categories = <String>{'Toutes', ...gitCommands.map((item) => item.category)};
    final filtered = _filter(gitCommands, _query, _category);

    return Scaffold(
      appBar: AppBar(title: const Text('Guide Commandes Git')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Chaque commande est expliquee simplement: a quoi elle sert, quand l utiliser, et un exemple concret.',
          ),
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
            ...filtered.map((item) => _CommandCard(item: item)),
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
          item.what.toLowerCase().contains(q);
    }).toList();
  }
}

class _CommandCard extends StatelessWidget {
  const _CommandCard({required this.item});

  final GitCommand item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
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
          ],
        ),
      ),
    );
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
          Text(
            value,
            style: TextStyle(
              fontFamily: mono ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}
