import 'dart:ui';
import 'HttpService.dart';
import '../canvas/Painter.dart';

class ImageService {

  static createImage(canvasWidth, canvasHeight) {

    var pictureRecorder = new PictureRecorder();
    Canvas canvas = new Canvas(pictureRecorder);
    Painter painter = new Painter();

    painter.paint(canvas, new Size(canvasWidth, canvasHeight));

    pictureRecorder.endRecording().toImage(canvasWidth.floor(), canvasHeight.floor()).then((img) {
      HttpService.sendPicture(img);
    });
  }
}