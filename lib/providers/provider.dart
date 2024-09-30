import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/crud.dart';

// User ID Provider
final userIdProvider = Provider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? '';
});

// User Provider
final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Fetched Files Provider
final fetchedFilesProvider = FutureProvider<List<String>>((ref) async {
  return CRUD().fetchBooks();
});

// Fetched Quizzes Provider
final quizProvider = FutureProvider.family
    .autoDispose<List<DocumentSnapshot>, Map<String, String>>(
        (ref, params) async {
  return await CRUD().fetchQuiz(params['language']!, params['difficulty']!);
});

// Progress Provider
final progressProvider =
    FutureProvider.family<List<DocumentSnapshot>, String>((ref, userId) async {
  return CRUD().fetchProgress(userId);
});

// General State Management Provider
final generalStateProvider = StateProvider<int>((ref) => 0);
