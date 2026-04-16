import 'package:flutter/material.dart';

class GitSimulatorScreen extends StatefulWidget {
  const GitSimulatorScreen({super.key});

  @override
  State<GitSimulatorScreen> createState() => _GitSimulatorScreenState();
}

class _GitSimulatorScreenState extends State<GitSimulatorScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _expectedCommands = const [
    'git init',
    'git add .',
    'git commit -m "first commit"',
    'git checkout -b feature/login',
    'git merge feature/login',
    'git push -u origin main',
  ];

  final List<String> _history = <String>[];
  int _step = 0;
  String _feedback = 'Entre la premiere commande pour commencer.';

  bool get _isCompleted => _step >= _expectedCommands.length;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _expectedCommands.isEmpty ? 0.0 : _step / _expectedCommands.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Simulateur Git')),
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
                    'Scenario guide',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Initialise un depot, cree un commit, une branche, merge puis push.'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Etape ${_isCompleted ? _expectedCommands.length : _step + 1} / ${_expectedCommands.length}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande attendue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isCompleted ? 'Scenario termine' : _expectedCommands[_step],
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tape une commande Git...',
                      prefixIcon: Icon(Icons.terminal_rounded),
                    ),
                    onSubmitted: (_) => _runCommand(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: _isCompleted ? null : _runCommand,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Executer'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Recommencer'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _feedback,
                    style: TextStyle(
                      color: _feedback.startsWith('OK')
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Etat visuel (simplifie)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buildVisualState(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historique des commandes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_history.isEmpty)
                    const Text('Aucune commande executee.')
                  else
                    ..._history.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(line, style: const TextStyle(fontFamily: 'monospace')),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildVisualState() {
    final nodes = <String>['repo: vide'];

    if (_step >= 1) {
      nodes[0] = 'repo: initialise';
    }
    if (_step >= 2) {
      nodes.add('staging: 1 fichier');
    }
    if (_step >= 3) {
      nodes.add('main: commit C1');
    }
    if (_step >= 4) {
      nodes.add('branche: feature/login');
    }
    if (_step >= 5) {
      nodes.add('main <- merge feature/login');
    }
    if (_step >= 6) {
      nodes.add('origin/main synchronise');
    }

    return nodes
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8),
                const SizedBox(width: 8),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        )
        .toList();
  }

  void _runCommand() {
    final input = _controller.text.trim();
    if (input.isEmpty || _isCompleted) {
      return;
    }

    final expected = _expectedCommands[_step];
    final normalizedInput = input.toLowerCase();
    final normalizedExpected = expected.toLowerCase();

    if (normalizedInput == normalizedExpected) {
      setState(() {
        _history.add('\$ $input');
        _step += 1;
        _feedback = _isCompleted
            ? 'OK: scenario termine, excellent!'
            : 'OK: commande valide. Passe a l etape suivante.';
        _controller.clear();
      });
      return;
    }

    setState(() {
      _history.add('\$ $input');
      _feedback = 'Essaie encore. Indice: ${_expectedCommands[_step]}';
    });
  }

  void _reset() {
    setState(() {
      _step = 0;
      _history.clear();
      _feedback = 'Entre la premiere commande pour commencer.';
      _controller.clear();
    });
  }
}
