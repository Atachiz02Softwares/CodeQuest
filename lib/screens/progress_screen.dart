import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('progress').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomProgressBar());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: CustomText(
                text: "No progress data available.",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final int quizzesTaken = data['quizzesTaken'] ?? 0;
          final double averageScore = data['averageScore'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomText(
                  text: "Quizzes Taken: $quizzesTaken",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomText(
                  text: "Average Score: ${averageScore.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
