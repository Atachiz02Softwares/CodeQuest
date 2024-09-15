import 'package:code_quest/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(signinProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                ),
              ),
              const SizedBox(width: 50),
              Header(user: user!),
              const SizedBox(height: 50),
              const Divider(color: Colours.primary),
              const SizedBox(height: 50),
              ListTile(
                leading: const Icon(Icons.info, size: 30),
                title: const CustomText(
                  text: 'About',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Show about dialog or screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, size: 30),
                title: const CustomText(
                  text: 'Exit',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Exit the app
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, size: 30),
                title: const CustomText(
                  text: 'Sign Out',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  await ref.read(signinProvider.notifier).signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/auth');
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final themeProvider = ref.watch(themeNotifierProvider);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: child,
              );
            },
            child: IconButton(
              tooltip: themeProvider.darkTheme
                  ? 'Switch to Light Theme'
                  : 'Switch to Dark Theme',
              onPressed: () {
                ref.read(themeNotifierProvider).toggleTheme();
              },
              icon: themeProvider.darkTheme
                  ? const Icon(Icons.nightlight_rounded, size: 30)
                  : const Icon(Icons.wb_sunny_rounded, size: 30),
            ),
          );
        },
      ),
    );
  }
}
