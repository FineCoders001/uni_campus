import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class FilesIO {
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv']);
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  Future readFile(String path) async {
    // PlatformFile file = result.files.first;
    final input = File(path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    //print("$fields");
    return fields;
  }
}
