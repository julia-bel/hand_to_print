import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'Painter.dart';

class Draw extends StatefulWidget {
  @override
  DrawState createState() => DrawState();
}

class DrawState extends State<Draw> {

  @override
  Widget build(BuildContext context) {

    CanvasProvider canvasProvider = Provider.of<CanvasProvider>(context);

    var customPaint = CustomPaint(
      child: Container(
        height: () {
          var canvasHeight = (MediaQuery.of(context).size.height - canvasProvider.appBarHeight) * 0.7;
          canvasProvider.setHeight(canvasHeight);
          return canvasHeight;
        }.call(),

        width: () {
          var canvasWidth = MediaQuery.of(context).size.width;
          canvasProvider.setWidth(canvasWidth);
          return canvasWidth;
        }.call(),

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
      ),
      foregroundPainter: Painter(pointsList: canvasProvider.pointsList),
    );

    return
      GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderObject? renderBox = context.findRenderObject();
            canvasProvider.pointsList.add(DrawingPoints(
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
            canvasProvider.pointsList.add(DrawingPoints(
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
            canvasProvider.pointsList.add(DrawingPoints(points: Offset(0,0), paint: Paint(), isSpace: true));
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
  DrawingPoints({required this.points, required this.paint, required this.isSpace});
  bool isSpace;
}


