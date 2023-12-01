import 'package:flutter/material.dart';

import '../../../data/task.dart';

class TaskDurationIcon extends StatefulWidget {
  final Task task;

  const TaskDurationIcon({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  createState() => _TaskDurationIconState();
}

class _TaskDurationIconState extends State<TaskDurationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<Offset> bubblePositions = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.task.taskDuration,
    );

    DateTime std = widget.task.startTaskDay;
    Duration durationEverPassed = DateTime.now().difference(std);
    double debut,
        fin,
        rapport =
            durationEverPassed.inSeconds / widget.task.taskDuration.inSeconds;
    if (rapport.isNegative) {
      debut = 0;
      fin = 0;
    } else {
      if (rapport < 1) {
        debut = rapport;
        fin = 1;
      } else {
        debut = 1;
        fin = 1;
      }
    }
    _animation = Tween<double>(begin: debut, end: fin).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          height: 75,
          width: 75,
          child: CustomPaint(
            painter: CirclePainter(_animation.value),
            child: _animation.value == 1
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : const SizedBox(),
          ),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final circleRadius = size.width / 3;
    final flowAngle = 2 * 3.14 * progress;

    final circlePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final flowPaint = Paint()
      ..color = const Color(0xFFFF741F)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      circleRadius,
      circlePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: circleRadius,
      ),
      -3.14 / 2,
      flowAngle,
      true,
      flowPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
