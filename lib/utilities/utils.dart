import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'colours.dart';

class Utils {
  static void showReviewIncorrectAnswers(
    BuildContext context,
    List<Map<String, dynamic>> incorrectAnswers,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: incorrectAnswers.length,
                  itemBuilder: (context, index) {
                    final question = incorrectAnswers[index]['question'];
                    final selectedAnswer =
                        incorrectAnswers[index]['selectedAnswer'];
                    final correctAnswer =
                        incorrectAnswers[index]['correctAnswer'];

                    return FrostedGlassContainer(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomText(
                              text: "Your Answer: $selectedAnswer",
                              style: const TextStyle(
                                color: Colours.red,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text: "Correct Answer: $correctAnswer",
                              style: const TextStyle(
                                color: Colours.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
