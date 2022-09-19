import 'dart:developer';
import 'dart:ui';
import 'package:http/http.dart' as http;

class HttpService {

  static sendPicture(Image img) {
    img.toByteData(format: ImageByteFormat.png).then((value)
    async {
      if (value != null) {
        var server_url = 'http://192.168.1.93:8086/text_recognition';
        var request = http.MultipartRequest('POST', Uri.parse(server_url));
        request.files.add(
            http.MultipartFile.fromBytes(
                'text_image', value.buffer.asUint8List()
            )
        );

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201){
          log(await response.stream.bytesToString());
        } else {
          log(response.reasonPhrase);
        }
      }
    });
  }

}