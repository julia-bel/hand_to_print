import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Painter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    var style = const TextStyle(
      color: Colors.pink,
      fontSize: 50,
    );

    final ParagraphBuilder paragraphBuilder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
        )
    )
      ..pushStyle(style.getTextStyle())
      ..addText("hand to print");
    final Paragraph paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width));
    canvas.drawParagraph(paragraph, Offset(0, size.height * 0.4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
