import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static const screenTransition = Duration(milliseconds: 350);
  static const buttonTap = Duration(milliseconds: 100);
  static const neonPulse = Duration(seconds: 2);
  static const typewriter = Duration(milliseconds: 50);
  static const cardReveal = Duration(milliseconds: 1500);
  static const buttonPulse = Duration(seconds: 3);

  static const defaultCurve = Curves.easeInOut;
}
