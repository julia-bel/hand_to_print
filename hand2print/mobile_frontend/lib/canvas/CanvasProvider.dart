import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'Draw.dart';
import 'Coords.dart';

class CanvasProvider extends ChangeNotifier {
  double width = 0;
  double height = 0;

  List<List<DrawingPoints>> pointsLists = [[]];
  List<List<ui.Image>> imagesLists = [[]];
  List<List<Coords>> coordsLists = [[]];
  int curList = 0;

  void setWidth(double value) {
    width = value;
  }

  void setHeight(double value) {
    height = value;
  }
}