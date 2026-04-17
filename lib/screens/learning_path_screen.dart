import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../state/app_state_scope.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Parcours 30 Jours Git')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Objectif: 1 action par jour',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${appState.completedPathDayIds.length}/${learningPathDays.length} jours completes',
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: appState.roadmapProgress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...learningPathDays.map((day) {
                final done = appState.completedPathDayIds.contains(day.id);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: done
                          ? Colors.green.withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.08),
                      child: Text('${day.dayNumber}'),
                    ),
                    title: Text(day.title),
                    subtitle: Text('${day.task}\nDuree: ~${day.expectedMinutes} min'),
                    isThreeLine: true,
                    trailing: IconButton(
                      onPressed: done ? null : () => appState.markPathDayDone(day.id),
                      icon: Icon(
                        done ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: done ? Colors.greenAccent : Colors.white54,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
