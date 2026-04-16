import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../state/app_state_scope.dart';
import '../widgets/command_of_day_card.dart';
import '../widgets/mode_card.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/section_title.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'visualizer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final dayIndex = DateTime.now().day % commandOfTheDay.length;
    final command = commandOfTheDay[dayIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Git & GitHub Explorer')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF161E3D), Color(0xFF0D1B2A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionTitle(title: 'Ton parcours'),
                const SizedBox(height: 10),
                ProgressOverviewCard(
                  title: 'Progression globale',
                  progress: appState.globalProgress,
                  subtitle: 'Apprendre + Pratiquer + Quiz',
                ),
                const SizedBox(height: 14),
                const SectionTitle(title: 'Modes principaux'),
                const SizedBox(height: 8),
                ModeCard(
                  title: 'Apprendre',
                  subtitle: 'Lecons courtes et progressives',
                  icon: Icons.menu_book_rounded,
                  gradient: const [Color(0xFF334155), Color(0xFF1E293B)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LearnScreen()),
                    );
                  },
                ),
                ModeCard(
                  title: 'Pratiquer',
                  subtitle: 'Quiz, exercices guides et defis',
                  icon: Icons.code_rounded,
                  gradient: const [Color(0xFF5B21B6), Color(0xFF312E81)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PracticeScreen()),
                    );
                  },
                ),
                ModeCard(
                  title: 'Visualiser',
                  subtitle: 'Schemas simples des concepts Git',
                  icon: Icons.account_tree_rounded,
                  gradient: const [Color(0xFF0F766E), Color(0xFF164E63)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VisualizerScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                CommandOfDayCard(
                  command: command,
                  tip: 'Essaie cette commande dans un petit projet test pour memoriser.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
