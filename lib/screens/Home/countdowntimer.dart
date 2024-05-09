import 'dart:async';

import 'package:flutter/cupertino.dart';

class CountdownTimer extends StatefulWidget {
  final int endTime;
  final Widget Function(BuildContext, CurrentRemainingTime?) widgetBuilder;
  final VoidCallback? onEnd;

  CountdownTimer({
    required this.endTime,
    required this.widgetBuilder,
    this.onEnd,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    final endTime = DateTime.fromMillisecondsSinceEpoch(widget.endTime);
    final currentTime = DateTime.now();
    final remainingTime = endTime.difference(currentTime).inSeconds;

    if (remainingTime > 0) {
      _timer = Timer(Duration(seconds: remainingTime), () {
        widget.onEnd?.call();
      });
    } else {
      widget.onEnd?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final endTime = DateTime.fromMillisecondsSinceEpoch(widget.endTime);
    final currentTime = DateTime.now();
    final remainingTime = endTime.difference(currentTime).inSeconds;

    if (remainingTime < 0) {
      return widget.widgetBuilder(context, null);
    }

    final hours = (remainingTime ~/ 3600).toInt();
    final minutes = ((remainingTime % 3600) ~/ 60).toInt();
    final seconds = (remainingTime % 60).toInt();

    return widget.widgetBuilder(
        context,
        CurrentRemainingTime(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
        ));
  }
}

class CurrentRemainingTime {
  final int hours;
  final int minutes;
  final int seconds;

  CurrentRemainingTime({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
}
