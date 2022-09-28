import 'dart:ui';
import 'HttpService.dart';
import '../canvas/Painter.dart';

class ImageService {

  static createImage (canvasWidth, canvasHeight, pointsLists) async {
    List<Image> imgs = [];

    for (final pointsList in pointsLists) {
      var pictureRecorder = new PictureRecorder();
      Canvas canvas = new Canvas(pictureRecorder);
      Painter painter = new Painter(pointsList: pointsList);

      painter.paint(canvas, new Size(canvasWidth, canvasHeight));

      Image img = await pictureRecorder.endRecording().toImage(canvasWidth.floor(), canvasHeight.floor());
      imgs.add(img);
    }
    HttpService.sendPictures(imgs);
  }
}