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
                _buildSignInButton(
                  context,
                  ref,
                  'assets/images/google.png',
                  'Continue with Google',
                  () async {
                    await ref.read(signinProvider.notifier).signInWithGoogle();
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null && context.mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeScreen(user: user),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 20),
                _buildSignInButton(
                  context,
                  ref,
                  'assets/images/apple.png',
                  'Continue with Apple',
                  () async {
                    // TODO: Add Apple sign-in logic here
                    CustomSnackBar.showSnackBar(
                      context,
                      'Apple sign-in is not yet supported',
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildSignInButton(
                  context,
                  ref,
                  'assets/images/facebook.png',
                  'Continue with Facebook',
                  () async {
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

  Widget _buildSignInButton(
    BuildContext context,
    WidgetRef ref,
    String assetPath,
    String buttonText,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: FrostedGlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(assetPath, height: 40),
              const SizedBox(width: 20),
              Expanded(
                child: CustomText(
                  text: buttonText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
