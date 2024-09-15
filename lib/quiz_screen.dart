import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quiz Finished!"),
          content: Text("Your Score: $score/${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to home
              },
              child: const Text("OK"),
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
          child: CircularProgressIndicator(),
        ),
      );
    }

    DocumentSnapshot currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz - ${widget.language} (${widget.difficulty})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Column(
              children: (currentQuestion['options'] as List<dynamic>)
                  .map((option) => RadioListTile<String>(
                        title: Text(option),
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
                  child: Text(currentQuestionIndex < questions.length - 1
                      ? "Next"
                      : "Submit"),
                ),
                Text(
                  "Score: $score",
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
