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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/ic_launcher.png', height: 200),
                const SizedBox(height: 20),
                GlassButton(
                  widgetRef: ref,
                  assetPath: 'assets/images/google.svg',
                  buttonText: 'Continue with Google',
                  onTap: () async {
                    await ref.read(signinProvider.notifier).signInWithGoogle();
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null && context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                ),
                const SizedBox(height: 20),
                GlassButton(
                  widgetRef: ref,
                  assetPath: 'assets/images/apple.svg',
                  buttonText: 'Continue with Apple',
                  onTap: () async {
                    // TODO: Add Apple sign-in logic here
                    CustomSnackBar.showSnackBar(
                      context,
                      'Apple sign-in is not yet supported',
                    );
                  },
                ),
                const SizedBox(height: 20),
                GlassButton(
                  widgetRef: ref,
                  assetPath: 'assets/images/facebook.svg',
                  buttonText: 'Continue with Facebook',
                  onTap: () async {
                    // TODO: Add Facebook sign-in logic here
                    CustomSnackBar.showSnackBar(
                      context,
                      'Facebook sign-in is not yet supported',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
