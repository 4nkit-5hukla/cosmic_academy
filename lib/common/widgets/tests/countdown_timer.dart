import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;

  const CountdownTimer({super.key, required this.seconds});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _seconds;

  String get timerString {
    Duration duration = _controller.duration! * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: _seconds,
      ),
    );
    _controller.reverse(
      from: _controller.value == 0.0 ? 1.0 : _controller.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timerString,
      style: const TextStyle(fontSize: 36),
    );
  }
}
