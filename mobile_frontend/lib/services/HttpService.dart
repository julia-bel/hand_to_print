import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

class HttpService {

  static sendPicture(Image img) {
    img.toByteData(format: ImageByteFormat.png).then((value)
    {
      if (value != null) {
        log(base64.encode(value.buffer.asUint8List()));
      }
    });
  }

}