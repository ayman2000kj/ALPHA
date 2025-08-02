import 'package:flutter/material.dart';

class LoginAnimations {
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
  }

  static Animation<Offset> createSlideAnimation(
      AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
  }

  static Animation<double> createScaleAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));
  }

  static AnimationController createMainController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );
  }
}
