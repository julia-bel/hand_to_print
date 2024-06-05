import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'CanvasProvider.dart';
import 'Painter.dart';
import 'Coords.dart';

class Draw extends StatefulWidget {
  @override
  DrawState createState() => DrawState();
}

// class CustomDetector extends GestureDetector {
//     void Function(ui.Image image, Coords coords)? onUpload;
//     CustomDetector({
//       super.key,
//       super.child,
//       super.onPanUpdate,
//       super.onPanStart,
//       super.onPanEnd,
//       this.onUpload});
// }

class DrawState extends State<Draw> {

  @override
  Widget build(BuildContext context) {

    CanvasProvider canvasProvider = Provider.of<CanvasProvider>(context);

    var customPaint = CustomPaint(
      child:
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      foregroundPainter: Painter(
          pointsList: canvasProvider.pointsLists[canvasProvider.curList],
          coordsList: canvasProvider.coordsLists[canvasProvider.curList],
          imagesList: canvasProvider.imagesLists[canvasProvider.curList]),
    );

    return
      GestureDetector(
        // onUpload: (ui.Image image, Coords coords) {
        //   setState(() {
        //     RenderObject? renderBox = context.findRenderObject();
        //     canvasProvider.imagesList[canvasProvider.curList].add(image);
        //     canvasProvider.coordsList[canvasProvider.curList].add(coords);
        //   });
        // },
        onPanUpdate: (details) {
          setState(() {
            RenderObject? renderBox = context.findRenderObject();
            canvasProvider.pointsLists[canvasProvider.curList].add(DrawingPoints(
                points: details.localPosition,
                paint: Paint()
                  ..strokeCap = StrokeCap.round
                  ..isAntiAlias = true
                  ..strokeWidth = 5,
                isSpace: false));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderObject? renderBox = context.findRenderObject();
            canvasProvider.pointsLists[canvasProvider.curList].add(DrawingPoints(
            points: details.localPosition,
            paint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..strokeWidth = 5,
            isSpace: false));
          });
        },
        onPanEnd: (details) {
          setState(() {
            canvasProvider.pointsLists[canvasProvider.curList].add(
                DrawingPoints(points: Offset(0,0), paint: Paint(), isSpace: true));
          });
        },
        child:
          ClipRRect(
            child: customPaint
          )
      );
  }
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({
    required this.points,
    required this.paint,
    required this.isSpace});
  bool isSpace;
}


