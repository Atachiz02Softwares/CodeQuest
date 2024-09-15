import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class QuizScreen extends StatefulWidget {
  final String language;
  final String difficulty;

  const QuizScreen({
    super.key,
    required this.language,
    required this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<DocumentSnapshot> questions = [];
  List<Map<String, dynamic>> incorrectAnswers = [];
  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  Future<void> fetchQuizQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('quiz_questions')
        .where('language', isEqualTo: widget.language)
        .where('difficulty', isEqualTo: widget.difficulty)
        .get();

    setState(() {
      questions = snapshot.docs;
    });
  }

  void _submitAnswer() {
    if (selectedAnswer != null) {
      String correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
      if (selectedAnswer == correctAnswer) {
        score++;
      } else {
        // Store incorrect answers with correct answers for review
        incorrectAnswers.add({
          'question': questions[currentQuestionIndex]['question'],
          'selectedAnswer': selectedAnswer,
          'correctAnswer': correctAnswer,
        });
      }

      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
        });
      } else {
        _showScoreDialog();
      }
    }
  }

// After showing score, allow review of incorrect answers
  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const CustomText(text: "Quiz Finished!"),
          content: CustomText(text: "Your Score: $score/${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  '/review_incorrect_answers',
                  arguments: incorrectAnswers,
                );
              },
              child: const CustomText(text: "Review Incorrect Answers"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to home
              },
              child: const CustomText(text: "OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CustomProgressBar(),
        ),
      );
    }

    DocumentSnapshot currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
            text: "Quiz - ${widget.language} (${widget.difficulty})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Question ${currentQuestionIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomText(
              text: currentQuestion['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Column(
              children: (currentQuestion['options'] as List<dynamic>)
                  .map((option) => RadioListTile<String>(
                        title: CustomText(text: option),
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = value;
                          });
                        },
                      ))
                  .toList(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _submitAnswer,
                  child: CustomText(
                      text: currentQuestionIndex < questions.length - 1
                          ? "Next"
                          : "Submit"),
                ),
                CustomText(
                  text: "Score: $score",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
