import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipePainter extends CustomPainter{

  final myPoints;

  SwipePainter(this.myPoints): super();

  Paint p = Paint()
    ..color = Colors.teal
    ..strokeWidth = 10;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(PointMode.points, myPoints, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  
}