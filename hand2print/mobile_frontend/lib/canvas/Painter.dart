import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Draw.dart';
import 'Coords.dart';

class Painter extends CustomPainter {
  List<DrawingPoints> pointsList;
  List<ui.Image> imagesList;
  List<Coords> coordsList;
  int curListLen = 0;
  Painter({
    required this.pointsList,
    required this.imagesList,
    required this.coordsList}) {
    curListLen = this.pointsList.length;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < imagesList.length; i++) {
      canvas.drawImage(imagesList[i],
          Offset(coordsList[i].left, coordsList[i].top), Paint());
    }
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (!pointsList[i].isSpace && !pointsList[i + 1].isSpace) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) => oldDelegate.curListLen != curListLen;
}
