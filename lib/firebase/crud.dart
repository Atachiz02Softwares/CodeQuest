import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;

class CRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<DocumentSnapshot>> fetchQuiz(String language, String difficulty) async {
    QuerySnapshot snapshot = await _firestore
        .collection('quiz_questions')
        .where('language', isEqualTo: language)
        .where('difficulty', isEqualTo: difficulty)
        .get();

    return snapshot.docs;
  }

  Future<void> uploadQuiz() async {
    String jsonString =
        await rootBundle.loadString('assets/raw/quiz_questions.json');
    List<dynamic> questions = json.decode(jsonString)['questions'];

    for (var question in questions) {
      await _firestore.collection('quiz_questions').add(question);
    }
  }

  Future<void> saveQuiz(
    String userId,
    int score,
    String language,
    String difficulty,
    DateTime date,
  ) async {
    await _firestore.collection('progress').add({
      'userId': userId,
      'score': score,
      'language': language,
      'difficulty': difficulty,
      'date': date,
    });
  }

  Future<List<DocumentSnapshot>> fetchProgress(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('progress')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs;
  }

  Future<List<String>> fetchBooks() async {
    ListResult result = await _storage.ref('books').listAll();
    List<String> bookUrls = [];
    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      bookUrls.add(url);
    }

    return bookUrls;
  }
}
