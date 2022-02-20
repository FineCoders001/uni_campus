import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class UploadDownload {
  Future uploadFile(FilePickerResult fileSelected,String path) async {
    final fileName = fileSelected.files.single.name;
    final destination = "ExamFiles/$path/$fileName";
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final path = fileSelected.files.single.path;

      File file = File(path!);
      UploadTask task = ref.putFile(file);
      final snapshot = await task.whenComplete(() => null);
      final downloadLink = await snapshot.ref.getDownloadURL();
      return downloadLink;
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future downloadFile(String path, String fileName) async {
    final ref = FirebaseStorage.instance.ref('$path/$fileName');
    final dir = await getExternalStorageDirectory();
    final file = File("${dir?.path}/$fileName");
    await ref.writeToFile(file);
    
  }
}
