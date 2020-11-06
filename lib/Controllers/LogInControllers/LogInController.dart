import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mestre_de_obra/Models/auth.dart';
import 'package:mestre_de_obra/Views/homeScreen.dart';

// TODO Add a loading indication to the login action
class LogInController extends GetxController {
  RxString _email = ''.obs;
  RxString _password = ''.obs;
  FocusNode loginFocus;
  String _title;
  String _message;
  Auth _auth;

  /// Returns the email value
  String get email => _email.value;

  /// Returns the password value
  String get password => _password.value;

  /// Updates the email variable
  void updatedEmail(String newEmail) {
    _email.value = newEmail;
  }

  /// Updates the password variable
  void updatedPassword(String newPassword) {
    _password.value = newPassword;
  }

  /// Request focus for the loginFocus
  void requestFocus() {
    loginFocus.requestFocus();
  }

  /// Sign in the user and push to the home screen
  void signInUserAndPushToHome() async {
    if (_email.value.trim() != null &&
        _password.value != null &&
        await _auth.signInUser(_email.value.trim(), _password.value)) {
      Get.offAllNamed(HomeScreen.id);
    } else {
      _loginErrorTitleAndMessage();
      Get.snackbar(
          _title ?? 'Erro', _message ?? 'Ocorreu um erro desconhecido');
    }
  }

  void googleSignIn() async {
    if (await _auth.googleAuth()) {
      Get.offAllNamed('/home');
    } else {
      _loginErrorTitleAndMessage();
      Get.snackbar(_title ?? 'Erro', _message ?? 'Ocorreu um erro inesperado');
    }
  }

  /// Checks the sign in error and sets the corresponding title and message to be used in the snackbar
  void _loginErrorTitleAndMessage() {
    switch (_auth.authErrorCode) {
      case 'ERROR_INVALID_EMAIL':
        _title = 'E-mail invalido';
        _message = 'Favor verificar a formatação do campo de e-mail';
        break;
      case 'ERROR_WRONG_PASSWORD':
        _title = 'Senha incorreta';
        _message = 'Favor verificar a senha informada';
        break;
      case 'ERROR_USER_NOT_FOUND':
        _title = 'Usuário não encontrado';
        _message = 'Favor verificar os dados ou criar uma nova conta';
        break;
      case 'ERROR_USER_DISABLED':
        _title = 'Usuário desativado';
        _message = 'Este usuário foi desativado';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        _title = 'Muitas requisições';
        _message = 'Muitas requisições simultaneas, favor tentar novamente';
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        _title = 'Operação não permitida';
        _message = 'Usuário não possuio permissão para realizar essa atividade';
        break;
      default:
        _title = 'Ocorreu um erro inesperado';
        _message = 'Favor tentar novamente';
    }
  }

  @override
  void onInit() {
    loginFocus = FocusNode();
    _auth = Get.find<Auth>();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  static LogInController get to => Get.find();
}
