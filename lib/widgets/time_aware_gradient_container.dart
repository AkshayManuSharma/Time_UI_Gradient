
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/time_gradient_service.dart';
import '../utils/color_utils.dart'; // Import our new utility

// A function signature for our builder.
// It provides the context and the three calculated contrast colors.
typedef TimeAwareChildBuilder = Widget Function(
  BuildContext context,
  Color topContrastColor,
  Color centerContrastColor,
  Color bottomContrastColor,
);

class TimeAwareGradientContainer extends StatefulWidget {
  final TimeAwareChildBuilder builder;

  // THIS IS THE CORRECTED CONSTRUCTOR
  const TimeAwareGradientContainer({Key? key, required this.builder}) : super(key: key);

  @override
  _TimeAwareGradientContainerState createState() =>
      _TimeAwareGradientContainerState();
}

class _TimeAwareGradientContainerState extends State<TimeAwareGradientContainer> {
  late final Timer _timer;
  final TimeGradientService _gradientService = TimeGradientService();
  
  // State for the gradient AND the contrast colors
  late LinearGradient _currentGradient;
  late Color _topContrastColor;
  late Color _centerContrastColor;
  late Color _bottomContrastColor;

  @override
  void initState() {
    super.initState();
    _updateColors(); // Set initial colors

    // Set up a timer to update everything every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateColors();
        });
      }
    });
  }

  void _updateColors() {
    // 1. Get the current gradient
    _currentGradient = _gradientService.getGradient(DateTime.now());

    // 2. Extract the background colors at the top, center, and bottom
    final topBgColor = _currentGradient.colors[0];
    final bottomBgColor = _currentGradient.colors[1];
    // The center color is a 50/50 mix of the top and bottom colors
    final centerBgColor = Color.lerp(topBgColor, bottomBgColor, 0.5)!;

    // 3. Calculate the contrasting foreground color for each position
    _topContrastColor = ColorUtils.getContrastingColor(topBgColor);
    _centerContrastColor = ColorUtils.getContrastingColor(centerBgColor);
    _bottomContrastColor = ColorUtils.getContrastingColor(bottomBgColor);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2), // Smoothly animate the gradient change
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: _currentGradient,
      ),
      // Use the builder to pass the calculated colors to the child widget tree
      child: widget.builder(
        context,
        _topContrastColor,
        _centerContrastColor,
        _bottomContrastColor,
      ),
    );
  }
}