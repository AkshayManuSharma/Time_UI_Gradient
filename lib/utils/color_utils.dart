
import 'package:flutter/material.dart';

/// A utility class for color-related operations.
class ColorUtils {

  static Color getContrastingColor(Color backgroundColor, {double luminanceThreshold = 0.4}) {
    //returns a value from black to white.
    if (backgroundColor.computeLuminance() > luminanceThreshold) {
      // Background is light, return a dark color for text/icons
      return Colors.black87;
    } else {
      // Background is dark, return a light color for text/icons
      return Colors.white;
    }
  }
}