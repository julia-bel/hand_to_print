import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class HttpService {
  static Future<void> createPDF(String text) async {
    PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
// Create a new PDF text element class and draw the flow layout text.
    final PdfLayoutResult layoutResult = PdfTextElement(
        text: text,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;


    List<int> bytes = await document.save();
    document.dispose();
    
    saveAndLaunchFile(bytes, 'Output.pdf');
  }

  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = await getApplicationDocumentsDirectory();
    final file = File(path.path + '/' + fileName);
    file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(path.path + '/' + fileName);
  }


  static sendPictures(List<Image> images) async {
    var server_url = 'http://192.168.1.93:8086/text_recognition';
    log('Create request to ' + server_url);
    var request = http.MultipartRequest('POST', Uri.parse(server_url));
    for (int i = 0; i < images.length; i++) {
      var value = await images[i].toByteData(format: ImageByteFormat.png);
      if (value != null) {
        request.files.add(
            http.MultipartFile.fromBytes(
                'text_image', value.buffer.asUint8List()
            )
        );
      }
    }
    log('Images files successfully added to request object');
    http.StreamedResponse streamedResponse = await request.send();
    log('Got response from server');
    if (streamedResponse.statusCode == 201) {
      var response = await http.Response.fromStream(streamedResponse);
      var jsonResponse = await jsonDecode(response.body);
      var text = jsonResponse['text'];
      log('Start creating pdf');
      await createPDF(text);
      log('Finish creating pdf');
    } else {
      log(streamedResponse.reasonPhrase);
    }
  }
}