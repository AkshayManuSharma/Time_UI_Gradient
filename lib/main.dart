
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/time_aware_gradient_container.dart';
import 'widgets/live_clock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Make status bar icons dark on light backgrounds and vice versa
      statusBarBrightness: Brightness.light, 
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeScreen(),
    );
  }
}

class TimeScreen extends StatelessWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use our container's builder to get the contrast colors
      body: TimeAwareGradientContainer(
        builder: (context, topColor, centerColor, bottomColor) {
          // Use a SafeArea to avoid UI overlapping with system notches/islands
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- TOP WIDGETS ---
                  _buildTopWidgets(context, topColor),

                  // --- CENTER WIDGET ---
                  LiveClock(textColor: centerColor),

                  // --- BOTTOM WIDGETS ---
                  _buildBottomWidgets(context, bottomColor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to build top widgets for cleanliness
  Widget _buildTopWidgets(BuildContext context, Color contrastColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Top Section Text',
          style: TextStyle(color: contrastColor, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.settings, color: contrastColor),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings icon pressed!')),
            );
          },
        ),
      ],
    );
  }

  // Helper method to build bottom widgets
  Widget _buildBottomWidgets(BuildContext context, Color contrastColor) {
    // Style the button to use the dynamic contrast color
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: contrastColor.withOpacity(0.15), // Button background
      foregroundColor: contrastColor, // Text and icon color
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: contrastColor.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );

    return ElevatedButton.icon(
      style: buttonStyle,
      icon: const Icon(Icons.refresh),
      label: const Text('Test Button', style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Button at the bottom pressed!')),
        );
      },
    );
  }
}