import 'dart:ui';
import 'HttpService.dart';
import '../canvas/Painter.dart';

class ImageService {

  static createImage(canvasWidth, canvasHeight, points) {

    var pictureRecorder = new PictureRecorder();
    Canvas canvas = new Canvas(pictureRecorder);
    Painter painter = new Painter(pointsList: points);

    painter.paint(canvas, new Size(canvasWidth, canvasHeight));

    pictureRecorder.endRecording().toImage(canvasWidth.floor(), canvasHeight.floor()).then((img) {
      HttpService.sendPicture(img);
    });
  }
}