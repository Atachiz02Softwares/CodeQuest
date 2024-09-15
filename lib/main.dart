import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/providers.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences
      .getInstance(); // Ensure SharedPreferences is initialized
  runApp(const ProviderScope(child: CodeQuest()));
}

class CodeQuest extends ConsumerWidget {
  const CodeQuest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signinProvider);
    final themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Code Quest',
      theme: themeNotifier.darkTheme
          ? ThemeData(brightness: Brightness.dark)
          : ThemeData(brightness: Brightness.light),
      home: user == null ? const SplashScreen() : HomeScreen(user: user),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
