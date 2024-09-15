import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class CRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchQuizQuestions(
      String language, String difficulty) async {
    QuerySnapshot snapshot = await _firestore
        .collection('quiz_questions')
        .where('language', isEqualTo: language)
        .where('difficulty', isEqualTo: difficulty)
        .get();

    return snapshot.docs;
  }

  Future<void> uploadQuestions() async {
    String jsonString =
        await rootBundle.loadString('assets/raw/quiz_questions.json');
    List<dynamic> questions = json.decode(jsonString)['questions'];

    for (var question in questions) {
      await _firestore.collection('quiz_questions').add(question);
    }
  }

  Future<void> saveQuizScore(
    String userId,
    int score,
    String language,
    String difficulty,
    DateTime date,
  ) async {
    await _firestore.collection('quiz_scores').add({
      'userId': userId,
      'score': score,
      'language': language,
      'difficulty': difficulty,
      'date': date,
    });
  }
}
