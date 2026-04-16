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

  @override
  void initState() {
    super.initState();
    _appState = AppState();
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
        home: const HomeScreen(),
      ),
    );
  }
}
