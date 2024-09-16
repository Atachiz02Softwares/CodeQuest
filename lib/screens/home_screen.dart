import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/providers.dart';
import '../utilities/utilities.dart';
import '../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _expandedButton;

  void _onDifficultySelected(String language, String difficulty) {
    Navigator.of(context).pushNamed('/quiz', arguments: {
      'language': language,
      'difficulty': difficulty,
    });
  }

  void _onButtonExpanded(String buttonText) {
    setState(() {
      _expandedButton = _expandedButton == buttonText ? null : buttonText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(signinProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Header(user: user!),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Choose a programming language to proceed 👇",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      ExpansibleButton(
                        assetPath: 'assets/images/python.svg',
                        buttonText: 'Python',
                        isExpanded: _expandedButton == 'Python',
                        onExpand: () => _onButtonExpanded('Python'),
                        onDifficultySelected: (difficulty) {
                          _onDifficultySelected('Python', difficulty);
                        },
                      ),
                      const SizedBox(height: 20),
                      ExpansibleButton(
                        assetPath: 'assets/images/java.svg',
                        buttonText: 'Java',
                        isExpanded: _expandedButton == 'Java',
                        onExpand: () => _onButtonExpanded('Java'),
                        onDifficultySelected: (difficulty) {
                          _onDifficultySelected('Java', difficulty);
                        },
                      ),
                      const SizedBox(height: 20),
                      ExpansibleButton(
                        assetPath: 'assets/images/html.svg',
                        buttonText: 'HTML',
                        isExpanded: _expandedButton == 'HTML',
                        onExpand: () => _onButtonExpanded('HTML'),
                        onDifficultySelected: (difficulty) {
                          _onDifficultySelected('HTML', difficulty);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () => Utils.showFilePicker(context),
                        icon: const Icon(Icons.book_rounded,
                            size: 30, color: Colours.primary),
                        label: const CustomText(
                          text: 'Study',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        iconSize: 30,
        selectedItemColor: Colours.tertiary,
        selectedLabelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed('/progress');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/settings');
          }
        },
      ),
    );
  }
}
