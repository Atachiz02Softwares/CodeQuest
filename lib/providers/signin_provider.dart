import 'package:code_quest/firebase/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signinProvider = StateNotifierProvider<SigninNotifier, User?>((ref) {
  return SigninNotifier();
});

class SigninNotifier extends StateNotifier<User?> {
  SigninNotifier() : super(null) {
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    state = FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithGoogle() async {
    await Authentication().signInWithGoogle();
    state = FirebaseAuth.instance.currentUser;
  }

  Future<void> signOut() async {
    await Authentication().signOut();
    state = null;
  }
}