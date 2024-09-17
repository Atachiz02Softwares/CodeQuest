import 'package:code_quest/firebase/authentication.dart';
import 'package:code_quest/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
        title: const Icon(Icons.settings_rounded, size: 30),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: userAsyncValue.when(
            data: (user) => user == null
                ? const Center(
                    child: CustomText(
                      text: 'Please Sign In!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 50),
                      Header(user: user),
                      const SizedBox(height: 50),
                      const Divider(color: Colours.primary),
                      const SizedBox(height: 50),
                      ListTile(
                        leading: const Icon(Icons.info, size: 30),
                        title: const CustomText(
                          text: 'About',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                                content: AboutDialogContent(
                                  title: 'About CodeQuest',
                                  content:
                                      'Code Quest is a cross-platform educational quiz app designed '
                                      'to help users learn various programming languages.\n\n'
                                      // 'Developed and Powered by Atachiz02 Softwares.\n\n'
                                      'Version: 1.0.0',
                                  buttonText: 'Close',
                                  onTap: Navigator.of(context).pop,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app, size: 30),
                        title: const CustomText(
                          text: 'Exit',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          SystemNavigator.pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, size: 30),
                        title: const CustomText(
                          text: 'Sign Out',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          await Authentication().signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/auth');
                          }
                        },
                      ),
                    ],
                  ),
            loading: () => const Center(child: CustomProgressBar()),
            error: (error, stack) => const Center(
              child: CustomText(
                text: 'An unexpected error occured!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
            ),
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
