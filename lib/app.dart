import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/local_storage_service.dart';
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
  bool _onboardingDone = false;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await _appState.loadPersistedState();
      _onboardingDone = await LocalStorageService.isOnboardingDone();
    } catch (_) {
      // In test environments, persistence plugins might be unavailable.
      _onboardingDone = true;
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
            ? (_onboardingDone
                  ? const HomeScreen()
                  : OnboardingScreen(
                      onFinish: () async {
                        await LocalStorageService.setOnboardingDone(true);
                        if (!mounted) {
                          return;
                        }
                        setState(() => _onboardingDone = true);
                      },
                    ))
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
