import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/signin_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: CodeQuest()));
}

class CodeQuest extends ConsumerWidget {
  const CodeQuest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signinProvider);

    return MaterialApp(
      title: 'Code Quest',
      theme: ThemeData(brightness: Brightness.dark),
      home: user == null ? const SplashScreen() : HomeScreen(user: user),
      routes: {
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}
