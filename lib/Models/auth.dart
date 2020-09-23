import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends GetxController {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;
  String authErrorCode;

  /// Returns a Future<bool> indicating if there is a user logged in
  Future<bool> isLoggedIn() async {
    try {
      return _auth.currentUser != null ? true : false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Sign in the user using email and password and returns a Future<bool> indicating the success [true] or failure [false] of the process
  Future<bool> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      authErrorCode = e.code;
      return false;
    }
  }

  /// Creates a new user, provided a email and a password and returns a Future<bool> indicating the success [true] or failure [false] of the process
  Future<bool> signUpUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      authErrorCode = e.code;
      return false;
    }
  }

  /// Sign out the current user and returns a Future<bool> indicating the success [true] or failure [false] of the process
  Future<bool> signOutUser() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      authErrorCode = e.code;
      return false;
    }
  }

  ///Returns a Future<String> with the email of the currentUser, if there is a logged in user, if there isn't it return null
  Future<String> currentUserEmail() async {
    try {
      if (await isLoggedIn()) {
        return _auth.currentUser.email;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> currentUserID() async {
    try {
      if (await isLoggedIn()) {
        return _auth.currentUser.uid;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> googleAuth() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleToken = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleToken.accessToken,
        idToken: googleToken.accessToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      // TODO Handle error when user cancels google sign in
      // signInErrorCode = e.code;
      return false;
    }
  }

  @override
  void onInit() {
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
