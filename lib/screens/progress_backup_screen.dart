import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/app_state_scope.dart';

class ProgressBackupScreen extends StatefulWidget {
  const ProgressBackupScreen({super.key});

  @override
  State<ProgressBackupScreen> createState() => _ProgressBackupScreenState();
}

class _ProgressBackupScreenState extends State<ProgressBackupScreen> {
  final TextEditingController _importController = TextEditingController();
  String? _status;
  bool _isError = false;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final exportJson = appState.exportProgressJson();

    return Scaffold(
      appBar: AppBar(title: const Text('Sauvegarde Hors-ligne')),
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
                    'Mode hors-ligne actif',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aucune connexion n est necessaire. Tes donnees restent locales et tu peux les exporter/importer manuellement.',
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
                    'Exporter la progression',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withValues(alpha: 0.22),
                    ),
                    child: SelectableText(
                      exportJson,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: exportJson));
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _status = 'JSON copie dans le presse-papiers.';
                        _isError = false;
                      });
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copier le JSON'),
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
                    'Importer une progression',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _importController,
                    minLines: 6,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      hintText: 'Colle ici un JSON exporte...',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () async {
                      final ok = await appState.importProgressJson(
                        _importController.text,
                      );
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _status = ok
                            ? 'Import reussi. Progression mise a jour.'
                            : 'Import invalide. Verifie le JSON.';
                        _isError = !ok;
                      });
                    },
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Importer'),
                  ),
                ],
              ),
            ),
          ),
          if (_status != null) ...[
            const SizedBox(height: 10),
            Text(
              _status!,
              style: TextStyle(
                color: _isError ? Colors.orangeAccent : Colors.greenAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
