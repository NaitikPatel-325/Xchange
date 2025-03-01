import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const FadeInAnimation({super.key, required this.child, this.delay = const Duration(milliseconds: 300)});

  @override
  Widget build(BuildContext context) {
    return child.animate().fade(duration: delay).slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
