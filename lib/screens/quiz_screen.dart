import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/crud.dart';
import '../utilities/colours.dart';
import '../utilities/utils.dart';
import '../widgets/widgets.dart';

class QuizScreen extends StatefulWidget {
  final String language;
  final String difficulty;

  const QuizScreen({
    required this.language,
    required this.difficulty,
    super.key,
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
    CRUD crud = CRUD();
    List<DocumentSnapshot> fetchedQuestions =
        await crud.fetchQuizQuestions(widget.language, widget.difficulty);
    setState(() {
      questions = fetchedQuestions;
    });
  }

  Future<void> _submitAnswer() async {
    if (selectedAnswer != null) {
      String correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
      if (selectedAnswer == correctAnswer) {
        score++;
      } else {
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
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user.uid;

          CRUD crud = CRUD();
          await crud.saveQuizScore(
            userId,
            score,
            widget.language,
            widget.difficulty,
            DateTime.now(),
          );
        }

        _showScoreDialog();
      }
    }
  }

  void _showScoreDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: AboutDialogContent(
            title: 'Quiz Finished!',
            content: 'Your Score: $score/${questions.length}',
            buttonText: 'Review Incorrect Answers',
            onTap: () {
              Navigator.of(context).pop();
              Utils.showReviewIncorrectAnswers(context, incorrectAnswers);
            },
          ),
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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.quiz_rounded, size: 30),
            CustomText(
              text: "Score: $score",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: CustomText(
                        text: "${widget.language} (${widget.difficulty})",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                    FrostedGlassContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: currentQuestion['question'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children:
                                  (currentQuestion['options'] as List<dynamic>)
                                      .map((option) => RadioListTile<String>(
                                            activeColor: Colours.primary,
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                          text:
                              "Question ${currentQuestionIndex + 1}/${questions.length}",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colours.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                size: 30,
                color: Colours.primary,
              ),
              label: const CustomText(
                text: "Quit",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _submitAnswer,
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: Colours.primary,
              ),
              label: CustomText(
                text: currentQuestionIndex < questions.length - 1
                    ? "Next"
                    : "Submit",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
