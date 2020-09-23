import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Database extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getProjects(List<String> userProjects) {
    return _firestore
        .collection('projects')
        .where('project', whereIn: userProjects)
        .snapshots();
  }

  Stream<QuerySnapshot> getFiles(String selectedProject) {
    return _firestore
        .collection('files')
        .where('project', isEqualTo: selectedProject)
        .snapshots();
  }

//  A stream of DocumentSnapshots that return the document with the userID as name in the users collection
  Stream<DocumentSnapshot> getUsers(String userID) {
    return _firestore.collection('users').doc(userID).snapshots();
  }

  static Database get to => Get.find();
}
