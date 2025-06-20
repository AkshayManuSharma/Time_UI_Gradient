import 'package:flutter/material.dart';

class TimeGradientService {

  static const Color _dawnTop = Color.fromARGB(255, 234, 199, 45);    // Sunny Yellow
  static const Color _dawnBottom = Color.fromARGB(255, 212, 125, 18); // Amber

  static const Color _duskTop = Color(0xFF03A9F4);    // Bright Sky Blue
  static const Color _duskBottom = Color.fromARGB(255, 0, 145, 213); // Lighter Sky Blue

  static const Color _noonTop = Color(0xFFF57C00);    // Orange
  static const Color _noonBottom = Color(0xFFBF360C);  // Deep Orange

  static const Color _nightTop = Color(0xFF263238);   // Dark Blue-Grey
  static const Color _nightBottom = Color(0xFF000000);  // Black

  /// Returns a LinearGradient based on the provided DateTime.
  LinearGradient getGradient(DateTime now) {
    final int hour = now.hour;

    // Transition from Night to Dawn (Midnight - 5am)
    if (hour < 5) {
      double t = hour / 5.0; // 0.0 at midnight, 1.0 at 5am
      return _lerpGradient(_nightTop, _nightBottom, _dawnTop, _dawnBottom, t);
    }
    // Transition from Dawn to Noon (5am - 8am)
    else if (hour < 8) {
      double t = (hour - 5) / 3.0; // 0.0 at 5am, 1.0 at 8am
      return _lerpGradient(_dawnTop, _dawnBottom, _noonTop, _noonBottom, t);
    }
    // Daytime / Noon (8am - 5pm)
    else if (hour < 17) {
      return const LinearGradient(
        colors: [_noonTop, _noonBottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    // Transition from Noon to Dusk (5pm - 8pm)
    else if (hour < 20) {
      double t = (hour - 17) / 3.0; // 0.0 at 5pm, 1.0 at 8pm
      return _lerpGradient(_noonTop, _noonBottom, _duskTop, _duskBottom, t);
    }
    // Transition from Dusk to Night (8pm - Midnight)
    else {
      double t = (hour - 20) / 4.0; // 0.0 at 8pm, 1.0 at midnight
      return _lerpGradient(_duskTop, _duskBottom, _nightTop, _nightBottom, t);
    }
  }

  /// Helper function to linearly interpolate between two gradients.
  LinearGradient _lerpGradient(
      Color topA, Color bottomA, Color topB, Color bottomB, double t) {
    // Clamp t to be between 0.0 and 1.0
    final progress = t.clamp(0.0, 1.0);
    return LinearGradient(
      colors: [
        Color.lerp(topA, topB, progress)!,
        Color.lerp(bottomA, bottomB, progress)!,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}