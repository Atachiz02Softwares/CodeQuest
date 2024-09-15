import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/signin_provider.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/ic_launcher.png', height: 200),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  await ref.read(signinProvider.notifier).signInWithGoogle();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && context.mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomeScreen(user: user),
                    ));
                  }
                },
                child: FrostedGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Image.asset('assets/images/google_logo.png',
                            height: 50),
                        const Expanded(
                          child: CustomText(
                            text: "Continue with Google",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
