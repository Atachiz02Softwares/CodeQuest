import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top Left: User Name
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              user.displayName ?? 'Anonymous',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Top Right: Profile Picture or Avatar
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundImage:
                  user.photoURL != null ? NetworkImage(user.photoURL!) : null,
              radius: 25,
              child: user.photoURL == null ? const Icon(Icons.person) : null,
            ),
          ),
          // Center: Programming language container
          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Choose a Language",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text("Python"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => _showDifficultySelector(context, "Python"),
                  ),
                  // Add more languages here
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _showDifficultySelector(BuildContext context, String language) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedDifficulty;
        return AlertDialog(
          title: const Text("Select Difficulty"),
          content: DropdownButton<String>(
            value: selectedDifficulty,
            items: ["Beginner", "Junior Dev", "Professional"]
                .map((level) =>
                    DropdownMenuItem(value: level, child: Text(level)))
                .toList(),
            onChanged: (value) {
              selectedDifficulty = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedDifficulty != null) {
                  Navigator.of(context).pop();
                  _confirmSelection(context, language, selectedDifficulty!);
                }
              },
              child: const Text("Proceed"),
            ),
          ],
        );
      },
    );
  }

  void _confirmSelection(
      BuildContext context, String language, String difficulty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: Text("You selected $difficulty difficulty. Proceed?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      QuizScreen(language: language, difficulty: difficulty),
                ));
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }
}
