import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'state/app_state.dart';
import 'state/app_state_scope.dart';
import 'theme/app_theme.dart';

class GitGithubExplorerApp extends StatefulWidget {
  const GitGithubExplorerApp({super.key});

  @override
  State<GitGithubExplorerApp> createState() => _GitGithubExplorerAppState();
}

class _GitGithubExplorerAppState extends State<GitGithubExplorerApp> {
  late final AppState _appState;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await _appState.loadPersistedState();
    } catch (_) {
      // In test environments, persistence plugins might be unavailable.
    }
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Git & GitHub Explorer',
        theme: AppTheme.darkTheme,
        home: _isReady
            ? const HomeScreen()
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
