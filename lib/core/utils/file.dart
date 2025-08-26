import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:nets/core/utils/utils.dart' show printDM;
//import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class FileDetails {
  static Future<File?> urlToFile({required String url, required String nameFile}) async {
    // Get the temporary directory on the device.
    final tempDirectory = await getTemporaryDirectory();

    // Create a unique filename for the file.
    final filename = '${DateTime.now().millisecondsSinceEpoch}$nameFile';
    try {
      // Download the file from the URL.
      final response = await http.get(Uri.parse(url));

      // Save the file to the temporary directory.
      final file = File('${tempDirectory.path}/$filename');
      await file.writeAsBytes(response.bodyBytes, flush: true); // Ensures immediate writing
      printDM('File Before $filename $file');
      file.open();
      //await openDownloadedFile(file.path);
      // Return the File object.
      return file;
    } catch (e) {
      //  Utils.showToast(title: 'file_path_error', state: UtilState.error);
      return null;
    }
  }

  static Future<File> uint8ListToFile(Uint8List imageBytes, String fileName) async {
    // Get the directory for saving images
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/$fileName';

    // Create the file and write the bytes
    final imageFile = File(imagePath);
    return imageFile.writeAsBytes(imageBytes, flush: true);
  }

  static Future<void> openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  /*static Future<void> openDownloadedFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Error handling
      printDM(result.message);
    }
  }*/
}
