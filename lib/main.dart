import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: CodeQuest()));
}

class CodeQuest extends ConsumerWidget {
  const CodeQuest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    final themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Code Quest',
      theme: themeNotifier.darkTheme
          ? ThemeData(brightness: Brightness.dark)
          : ThemeData(brightness: Brightness.light),
      home: userAsyncValue.when(
        data: (user) =>
            user == null ? const SplashScreen() : const HomeScreen(),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => const Text('Error occurred'),
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/quiz': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return QuizScreen(
            language: args['language']!,
            difficulty: args['difficulty']!,
          );
        },
        '/progress': (context) => const ProgressScreen(),
        '/study': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return StudyScreen(
            fileUrl: args['fileUrl']!,
            bookName: args['bookName']!,
          );
        },
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
