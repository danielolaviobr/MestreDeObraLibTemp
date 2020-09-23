import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class Storage extends GetxController {
  StorageReference _storage;
  String _errorTitle;
  String _errorMessage;

  /// Returns the error title to be displayed
  String get errorTitle => _errorTitle;

  /// Returns the error message to be displayed
  String get errorMessage => _errorMessage;

  /// Returns a dynamic that is the download Url, given the file and project
  Future<dynamic> getDownloadLink(String fileName, String project) async {
    try {
      print(await _storage.child('$project/$fileName').getDownloadURL());
      return await _storage.child('$project/$fileName').getDownloadURL();
    } catch (e) {
      _errorTitle = 'Arquivo não encontrado';
      _errorMessage = 'O arquivo não foi encontrado em nossos servidores';
    }
  }

  @override
  void onInit() {
    _storage = FirebaseStorage().ref();
    print('Download URL');
    super.onInit();
  }

  static Storage get to => Get.find();
}
