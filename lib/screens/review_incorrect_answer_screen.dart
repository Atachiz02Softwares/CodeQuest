import 'package:flutter/material.dart';

import '../utilities/colours.dart';
import '../widgets/widgets.dart';

class ReviewIncorrectAnswersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> incorrectAnswers;

  const ReviewIncorrectAnswersScreen({
    super.key,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: "Review Incorrect Answers"),
      ),
      body: ListView.builder(
        itemCount: incorrectAnswers.length,
        itemBuilder: (context, index) {
          final question = incorrectAnswers[index]['question'];
          final selectedAnswer = incorrectAnswers[index]['selectedAnswer'];
          final correctAnswer = incorrectAnswers[index]['correctAnswer'];

          return ListTile(
            title: CustomText(text: question),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Your Answer: $selectedAnswer",
                  style: const TextStyle(color: Colours.red),
                ),
                CustomText(
                  text: "Correct Answer: $correctAnswer",
                  style: const TextStyle(color: Colours.primary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
