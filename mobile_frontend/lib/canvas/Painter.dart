import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Draw.dart';

class Painter extends CustomPainter {
  List<DrawingPoints> pointsList;
  int curListLen = 0;
  Painter({required this.pointsList}) {
    curListLen = this.pointsList.length;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (!pointsList[i].isSpace && !pointsList[i+1].isSpace) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) => oldDelegate.curListLen != curListLen;
}
