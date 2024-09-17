import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/provider.dart';
import '../widgets/widgets.dart';
import 'colours.dart';

class Utils {
  static void showReviewIncorrectAnswers(
    BuildContext context,
    List<Map<String, dynamic>> incorrectAnswers,
  ) {
    showModalBottomSheet(
      context: context,
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

  // static void showFilePicker(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null &&
  //       result.files.single.path != null &&
  //       result.files.isNotEmpty &&
  //       context.mounted) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             StudyScreen(filePath: result.files.single.path!),
  //       ),
  //     );
  //   }
  // }

  static void showBooks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final booksAsyncValue = ref.watch(fetchedFilesProvider);

                return booksAsyncValue.when(
                  data: (bookUrls) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount: bookUrls.length,
                          itemBuilder: (context, index) {
                            String bookUrl = bookUrls[index],
                                bookName = Uri.decodeFull(bookUrl
                                        .split('/')
                                        .last
                                        .split('?')
                                        .first
                                        .replaceAll('%20', ' '))
                                    .replaceAll('books/', '')
                                    .replaceAll(RegExp(r'\(.*\)\.pdf'), ''),
                                bookAuthor = Uri.decodeFull(bookUrl
                                        .split('/')
                                        .last
                                        .split('?')
                                        .first
                                        .replaceAll('%20', ' '))
                                    .split('(')
                                    .last
                                    .split(')')[0];

                            return FrostedGlassContainer(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ListTile(
                                title: CustomText(
                                  text: bookName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: CustomText(
                                  text: bookAuthor,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/study',
                                    arguments: {
                                      'fileUrl': bookUrl,
                                      'bookName': bookName
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CustomProgressBar()),
                  error: (error, stack) => const Center(
                    child: CustomText(
                      text: 'Error loading books!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
