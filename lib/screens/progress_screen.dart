import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/provider.dart';
import '../widgets/widgets.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final progressAsyncValue = ref.watch(progressProvider(userId!));

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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: progressAsyncValue.when(
              data: (quizzes) {
                if (quizzes.isEmpty) {
                  return const CustomText(
                    text: "Score: 0",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                }

                final totalScore = quizzes
                    .map((quiz) =>
                        (quiz.data() as Map<String, dynamic>)['score'])
                    .reduce((value, element) => value + element);
                final averageScore = totalScore / quizzes.length;

                return CustomText(
                  text: "Average Score: ${averageScore.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              loading: () => const CustomProgressBar(),
              error: (error, stack) => const CustomText(
                text: "Score: 0",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: progressAsyncValue.when(
        data: (quizzes) {
          if (quizzes.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No progress data available yet...",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            );
          }

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
        loading: () => const Center(child: CustomProgressBar()),
        error: (error, stack) => const Center(
          child: CustomText(
            text: "Error loading progress data!",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
