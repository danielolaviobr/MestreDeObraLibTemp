import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum DownloadStatus { NotStarted, Started, Downloading, Completed }

class DownloadController extends GetxController {
  StreamSubscription _downloadSubscription;
  DownloadStatus _status = DownloadStatus.NotStarted;
  int _bytesDownloaded = 0;
  int _downloadProgress = 0;
  List<List<int>> _chunks = [];
  // String _downloadedFile;
  String _savingDirectory;
  String _documentsDirectory;
  String _filePath;
  String _errorTitle;
  String _errorMessage;
  bool _permissionStatus;
  RxBool _shouldOpen = false.obs;

  DownloadStatus get status => _status;

  int get downloadProgress => _downloadProgress;

  // ? Why is this here?
  // String get downloadedFile => _downloadedFile;

  /// Returns the error title to be displayed
  String get errorTitle => _errorTitle;

  /// Returns the error message to be displayed
  String get errorMessage => _errorMessage;

  /// Iindicates if the download is on going or not
  RxBool get isDownloading => _shouldOpen;

  Future<void> getPermission() async =>
      _permissionStatus = await Permission.storage.request().isGranted;

  void _updateDownloadStatus(DownloadStatus newStatus) {
    _status = newStatus;
    print('Download Status: $_status');
  }

  void _onDownloading(
      List<int> chunk, http.StreamedResponse streamResponse) async {
    try {
      print('Download Progress onListen : $_downloadProgress');
      _chunks.add(chunk);
      _bytesDownloaded += chunk.length;
      _downloadProgress =
          (_bytesDownloaded / streamResponse.contentLength * 100).round();
    } catch (e) {
      _errorTitle = 'Erro no download';
      _errorMessage =
          'Ocorreu um erro durante o download do arquivo, favor tentar fazer o download novamente';
      print(e);
    }
    update();
  }

  void _onDownloadCompleted(http.StreamedResponse streamResponse) async {
    try {
      _downloadProgress =
          (_bytesDownloaded / streamResponse.contentLength * 100).round();
      print(_filePath);
      File file = File(_filePath);

      final Uint8List bytes = Uint8List(streamResponse.contentLength);
      int offset = 0;
      for (List<int> chunk in _chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      await file.writeAsBytes(bytes);

      _updateDownloadStatus(DownloadStatus.Completed);
      if (_shouldOpen.value) {
        OpenFile.open(_filePath);
      }
      _shouldOpen.value = false;
      _downloadSubscription?.cancel();
      _downloadProgress = 0;
      _chunks = [];
    } catch (e) {
      _errorTitle = 'Erro no download';
      _errorMessage =
          'Ocorreu um erro ao salvar o arquivo no aparelho, favor tentar fazer o download novamente';
      print(e);
    }
    print('DownloadFile: Completed');
    update();
  }

  Future<String> getDownloadFilePath([String fileName]) async {
    _documentsDirectory = (await getApplicationDocumentsDirectory()).path;
    Directory('$_documentsDirectory/projects')
        .create(recursive: true)
        .then((dir) => _savingDirectory = dir.path);
    if (fileName != null) {
      _filePath = '$_savingDirectory/$fileName';
    }
    return _filePath;
  }

  Future<void> _downloadFile(String url, String fileName) async {
    if (_permissionStatus) {
      await getDownloadFilePath(fileName);
      try {
        http.Client httpClient = http.Client();
        http.Request request = new http.Request('GET', Uri.parse(url));
        Future<http.StreamedResponse> response = httpClient.send(request);
        _updateDownloadStatus(DownloadStatus.Started);
        _downloadSubscription =
            response.asStream().listen((http.StreamedResponse streamResponse) {
          _updateDownloadStatus(DownloadStatus.Downloading);
          return streamResponse.stream.listen(
            (List<int> chunk) => _onDownloading(chunk, streamResponse),
            onDone: () => _onDownloadCompleted(streamResponse),
          );
        });
      } catch (e) {
        _errorTitle = 'Erro de requisição';
        _errorMessage =
            'Ocorreu um erro ao requisitar o arquivo para download, favor tentar novamente';
        print(e);
      }
    } else {
      _errorTitle = 'Erro de permissão';
      _errorMessage =
          'É necessário permitir que o aplicativo faça downloads no aparelho';
      getPermission();
    }
  }

  void downloadAndOpenFile(String url, String fileName) async {
    // Should open indicates if the file should be open after downloaded, it can also indicates if the file is downloading or not
    _shouldOpen.value = true;
    await _downloadFile(url, fileName);
  }

  void openFileFromName(String fileName) {
    try {
      OpenFile.open(_savingDirectory + '/$fileName');
    } catch (e) {
      _errorTitle = 'Erro ao abrir o arquivo';
      _errorMessage =
          'Arquivo não encontrado no diretório padrão, verificar se o arquivo foi baixado corretamente';
    }
  }

  void clearErrors() {
    _errorTitle = null;
    _errorMessage = null;
  }

  @override
  void onInit() {
    getPermission();
    getDownloadFilePath();
    super.onInit();
  }

  

  static DownloadController get to => Get.find();
}
