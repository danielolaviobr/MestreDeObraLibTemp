import 'package:cloud_firestore/cloud_firestore.dart';

class FileData {
  final String name;
  final String project;
  final Timestamp updatedAt;
  final String docId;
  bool downloaded;

  FileData(
      {this.name, this.project, this.updatedAt, this.docId, this.downloaded});
}
