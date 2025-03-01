import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import '../../core/app_color.dart';
import '../../logic/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    SplashServices.checkLogin();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: 0, end: 0.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.user, size: 50, color: Colors.white),
                const SizedBox(width: 20),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(FontAwesomeIcons.arrowsRotate,
                      size: 40, color: Colors.pinkAccent),
                ),
                const SizedBox(width: 20),
                Icon(FontAwesomeIcons.user, size: 50, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "xChange",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}