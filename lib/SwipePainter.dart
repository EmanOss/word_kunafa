import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_styles.dart';

class SwipePainter extends CustomPainter{

  final myPoints;
  final vertices;
  // final p1,p2;

  SwipePainter(this.myPoints, this.vertices): super();

  Paint p = Paint()
    ..color = Colors.teal
    ..strokeWidth = 5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(vertices.last,myPoints.last, p);
    for(int i = 0; i < vertices.length - 1; i++)
      canvas.drawLine(vertices[i],vertices[i+1], p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}