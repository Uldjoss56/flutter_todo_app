import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/task.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  Duration _taskDuration = const Duration(seconds: 0),
      tdreel = const Duration(seconds: 0);
  DateTime st = DateTime.now(), ed = DateTime.now(), now = DateTime.now();
  Timer _timer = Timer(
    const Duration(seconds: 0),
    () {},
  );

  @override
  void initState() {
    super.initState();
    st = widget.task.startTaskDay;
    tdreel = widget.task.taskDuration;
    ed = st.add(Duration(seconds: tdreel.inSeconds));
    _taskDuration = ed.difference(now);
    /*if (_taskDuration.isNegative) {
      _taskDuration = const Duration(seconds: 0);
    }*/
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(
          () {
            if (_taskDuration.inSeconds > 0) {
              _taskDuration = _taskDuration - const Duration(seconds: 1);
            } else {
              timer.cancel();
            }
          },
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String days = duration.inDays.toString();

    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');

    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$days Days $hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return !_taskDuration.isNegative
        ? Center(
            child: RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                    child: Center(
                      child: Text(
                        'Time over in',
                        style: TextStyle(
                          color: Color(0x99FF741F),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Center(
                      child: Text(
                        formatDuration(_taskDuration),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
            heightFactor: 2,
            child: Text(
              "Time duration is already ended",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          );
  }
}
