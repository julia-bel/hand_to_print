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
          var canvasHeight = (MediaQuery.of(context).size.height - canvasProvider.appBarHeight) * 0.85;
          canvasProvider.setHeight(canvasHeight);
          return canvasHeight;
        }.call(),

        width: () {
          var canvasWidth = MediaQuery.of(context).size.width;
          canvasProvider.setWidth(canvasWidth);
          return canvasWidth;
        }.call(),

        color: Colors.black,
      ),
      foregroundPainter: Painter(),
    );

    return CustomPaint(
      child: customPaint,
      foregroundPainter: Painter(),
    );

  }
}


