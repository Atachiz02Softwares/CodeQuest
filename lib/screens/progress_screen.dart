import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/crud.dart';
import '../widgets/widgets.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
        title: const Icon(Icons.bar_chart_rounded, size: 30),
        actions: [
          FutureBuilder<List<DocumentSnapshot>>(
            future: CRUD().fetchQuizzes(userId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: CustomText(
                    text: "No progress data available.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }

              final quizzes = snapshot.data!;
              int totalScore = 0;
              int totalQuizzes = quizzes.length;

              for (var quiz in quizzes) {
                final data = quiz.data() as Map<String, dynamic>;
                totalScore += data['score'] as int;
              }

              final totalAverageScore = totalScore / totalQuizzes;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CustomText(
                    text:
                        "Average Score: ${totalAverageScore.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/progress_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<List<DocumentSnapshot>>(
            future: CRUD().fetchQuizzes(userId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomProgressBar());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: CustomText(
                    text: "No progress data available.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }

              final quizzes = snapshot.data!;
              final Map<String, Map<String, dynamic>> progressMetrics = {};

              for (var quiz in quizzes) {
                final data = quiz.data() as Map<String, dynamic>;
                final difficulty = data['difficulty'];
                final language = data['language'];
                final score = data['score'];

                if (!progressMetrics.containsKey(difficulty)) {
                  progressMetrics[difficulty] = {
                    'totalQuizzes': 0,
                    'totalScore': 0,
                    'languages': <String>{},
                  };
                }

                progressMetrics[difficulty]!['totalQuizzes'] += 1;
                progressMetrics[difficulty]!['totalScore'] += score;
                progressMetrics[difficulty]!['languages'].add(language);
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: progressMetrics.entries.map((entry) {
                    final difficulty = entry.key;
                    final metrics = entry.value;
                    final totalQuizzes = metrics['totalQuizzes'];
                    final totalScore = metrics['totalScore'];
                    final languages = metrics['languages'] as Set<String>;
                    final averageScore = totalScore / totalQuizzes;

                    return FrostedGlassContainer(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Difficulty: $difficulty",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomText(
                              text: "Total Quizzes: $totalQuizzes",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text: "Languages Taken: ${languages.length}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text:
                                  "Average Score: ${averageScore.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
