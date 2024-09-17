import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<Offset> _iconAnimation;
  late AnimationController _textController;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _iconAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.bounceOut,
    ));
    _iconController.forward();

    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.bounceOut,
    ));
    _textController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/auth');
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _iconAnimation,
              child: Image.asset('assets/images/ic_launcher.png', width: 200),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _textAnimation,
              child: const CustomText(
                text: 'Welcome to NurtureCode',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                align: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
