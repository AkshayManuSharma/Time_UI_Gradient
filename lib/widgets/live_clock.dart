
import 'dart:async';
import 'package:flutter/material.dart';


class LiveClock extends StatefulWidget {
  final Color textColor; 

  const LiveClock({Key? key, required this.textColor}) : super(key: key);

  @override
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late DateTime _currentTime;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  String _formatTime(DateTime time) { // ... same as before
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
  String _getGreeting(DateTime time) { // ... same as before
    int hour = time.hour;
    if (hour < 12) { return 'Good Morning'; }
    else if (hour < 17) { return 'Good Afternoon'; }
    else { return 'Good Evening'; }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      color: widget.textColor,
      shadows: const [Shadow(blurRadius: 5.0, color: Colors.black38)],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _getGreeting(_currentTime),
          style: baseStyle.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatTime(_currentTime),
          style: baseStyle.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}