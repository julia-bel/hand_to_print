import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class HttpService {
  static Future<void> createPDF(String text) async {
    debugPrint(text);
    final font = await rootBundle.load("lib/assets/font.ttf");
    final ttf = pw.Font.ttf(font);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
              text,
              style: pw.TextStyle(font: ttf)),
        ),
      ),
    );

    var current_time = DateTime.now();
    var timestamper = DateFormat('yy-mm-dd');
    String timestamp = timestamper.format(current_time);
    final path = await getExternalStorageDirectory();
    final filename = '${path?.path}/${timestamp}-note.pdf';

    final file = File(filename);
    file.create(recursive: true);
    await file.writeAsBytes(await pdf.save());
    await file.writeAsBytes(await pdf.save(), flush: true);
    await OpenFile.open(filename);
  }

  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = await getExternalStorageDirectory();
    final file = File('${path?.path}/${fileName}');
    file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    await OpenFile.open('${path?.path}/${fileName}');
  }

  static sendPictures(List<Image> images) async {
    var server_url = 'http://83.147.246.168:5648/upload';
    log('Create request to ' + server_url);
    var request = http.MultipartRequest('POST', Uri.parse(server_url));
    for (int i = 0; i < images.length; i++) {
      var value = await images[i].toByteData(format: ImageByteFormat.png);
      if (value != null) {
        request.files.add(
            http.MultipartFile.fromBytes(
                'image', value.buffer.asUint8List(),
                filename: 'image.png'
            )
        );
      }
    }
    log('Images files successfully added to request object');
    http.StreamedResponse streamedResponse = await request.send().timeout(const Duration(seconds: 120));
    log('Got response from server');
    if (streamedResponse.statusCode == 200) {
      var response = await http.Response.fromStream(streamedResponse);
      var jsonResponse = await jsonDecode(utf8.decode(response.bodyBytes));
      var text = jsonResponse['text'];
      log('Start creating .pdf');
      await createPDF(text);
      log('Finish creating .pdf');
    } else if (streamedResponse.statusCode == 409) {
        throw Exception('Server error');
    } else {
      log(streamedResponse.reasonPhrase ?? '');
      throw Exception(streamedResponse.reasonPhrase);
    }
  }
}