import 'dart:ui';
import 'HttpService.dart';
import '../canvas/Painter.dart';

class ImageService {

  static Future<void> getFile (
      canvasWidth,
      canvasHeight,
      pointsLists,
      imagesLists,
      coordsLists) async {
    List<Image> imgs = [];

    for (int i = 0; i < pointsLists.length; i++) {
      var pictureRecorder = PictureRecorder();
      Canvas canvas = Canvas(pictureRecorder);
      Painter painter = Painter(
          pointsList: pointsLists[i],
          imagesList: imagesLists[i],
          coordsList: coordsLists[i]);

      painter.paint(canvas, Size(canvasWidth, canvasHeight));

      Image img = await pictureRecorder.endRecording().toImage(canvasWidth.floor(), canvasHeight.floor());
      imgs.add(img);
    }
    await HttpService.sendPictures(imgs);
  }
}