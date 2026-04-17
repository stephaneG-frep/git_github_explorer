import 'package:flutter/material.dart';

class CommandOfDayCard extends StatelessWidget {
  const CommandOfDayCard({super.key, required this.command, required this.tip});

  final String command;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Commande du jour. $command. Astuce: $tip',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commande du jour',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.24),
                ),
                child: SelectableText(
                  command,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tip,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
