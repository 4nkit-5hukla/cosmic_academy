// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:flutter/material.dart';

class TimerButton extends StatefulWidget {
  final String label;
  final int seconds;
  final String retryLabel;
  final void Function()? onPressed;
  final TextStyle? style;

  const TimerButton({
    Key? key,
    required this.label,
    required this.seconds,
    this.onPressed,
    this.style,
    this.retryLabel = "Retry in",
  }) : super(key: key);

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  late int _secondsLeft;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.seconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (
      timer,
    ) {
      if (_secondsLeft < 1) {
        timer.cancel();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _secondsLeft < 1
        ? GestureDetector(
            onTap: (() {
              widget.onPressed!();
              setState(() {
                _secondsLeft = widget.seconds;
              });
              _startTimer();
            }),
            child: Body2(
              text: widget.label,
              bold: false,
              color: Theme.of(context).primaryColor,
            ),
          )
        : GestureDetector(
            onTap: null,
            child: Body2(
              text: '${widget.retryLabel} ${_secondsLeft}s',
              bold: false,
              color: Theme.of(context).primaryColor,
            ),
          );
  }
}
