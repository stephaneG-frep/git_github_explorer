import 'package:flutter/material.dart';

import '../models/command_exercise.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';

class CommandExerciseScreen extends StatefulWidget {
  const CommandExerciseScreen({
    super.key,
    required this.exercise,
  });

  final CommandExercise exercise;

  @override
  State<CommandExerciseScreen> createState() => _CommandExerciseScreenState();
}

class _CommandExerciseScreenState extends State<CommandExerciseScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isDone = false;
  String _feedback = 'Tape la commande puis valide.';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = AppStateScope.of(context);
    _isDone = appState.completedCommandExerciseIds.contains(widget.exercise.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.command,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.exercise.goal),
                  const SizedBox(height: 8),
                  Text(
                    'Indice: ${widget.exercise.hint}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.terminal_rounded),
              hintText: 'Ecris la commande ici...',
            ),
            onSubmitted: (_) => _validate(appState),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () => _validate(appState),
                icon: const Icon(Icons.check),
                label: const Text('Valider'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _controller.text = widget.exercise.command;
                },
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Voir la reponse'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _feedback,
            style: TextStyle(
              color: _feedback.startsWith('OK') ? Colors.greenAccent : Colors.orangeAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: Icon(
                _isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: _isDone ? Colors.greenAccent : Colors.white54,
              ),
              title: Text(_isDone ? 'Exercice valide' : 'Exercice non valide'),
              subtitle: const Text('Valide la commande pour marquer cet exercice termine.'),
            ),
          ),
        ],
      ),
    );
  }

  void _validate(AppState appState) {
    final normalizedInput = _normalize(_controller.text);
    final normalizedExpected = _normalize(widget.exercise.command);

    if (normalizedInput == normalizedExpected) {
      if (!_isDone) {
        appState.markCommandExerciseDone(widget.exercise.id);
      }
      setState(() {
        _isDone = true;
        _feedback = 'OK: commande correcte, excellent.';
      });
      return;
    }

    setState(() {
      _feedback = 'Pas encore. Reessaie avec la syntaxe exacte.';
    });
  }

  String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}
