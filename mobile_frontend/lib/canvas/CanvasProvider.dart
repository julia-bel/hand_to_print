import 'package:flutter/cupertino.dart';

import 'Draw.dart';

class CanvasProvider extends ChangeNotifier {
  double width = 0;
  double height = 0;

  List<List<DrawingPoints>> pointsLists = [[]];
  int curList = 0;

  void setWidth(double value) {
    width = value;
  }

  void setHeight(double value) {
    height = value;
  }
}