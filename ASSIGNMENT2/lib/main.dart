import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/todo_screen.dart';
import 'services/database_service.dart';
import 'services/session_service.dart';
import 'services/sync_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Holds the current theme; persisted via SessionService.
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  static void setDarkMode(bool dark) {
    themeNotifier.value = dark ? ThemeMode.dark : ThemeMode.light;
    SessionService.instance.setDarkMode(dark);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'TaskFlow Pro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const _RootGate(),
        );
      },
    );
  }
}

/// Initializes services, then routes to Login or Home based on the saved
/// session. Implements "skip login if already logged in".
class _RootGate extends StatefulWidget {
  const _RootGate();

  @override
  State<_RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<_RootGate> {
  late final Future<bool> _bootstrap = _init();

  Future<bool> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SessionService.instance.init();
    await DatabaseService.instance.init();

    // Apply the saved theme.
    final dark = await SessionService.instance.isDarkMode();
    MyApp.themeNotifier.value = dark ? ThemeMode.dark : ThemeMode.light;

    final loggedIn = await SessionService.instance.isLoggedIn();
    if (loggedIn) {
      // Push any pending local changes to the server in the background.
      SyncService.instance.syncInBackground();
    }
    return loggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _bootstrap,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashScreen();
        }
        final loggedIn = snapshot.data ?? false;
        return loggedIn ? const TodoScreen() : const LoginScreen();
      },
    );
  }
}
