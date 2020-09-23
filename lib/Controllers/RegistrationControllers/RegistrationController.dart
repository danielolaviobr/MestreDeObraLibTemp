import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mestre_de_obra/Models/auth.dart';
import 'package:mestre_de_obra/Models/database.dart';
import 'package:mestre_de_obra/Views/homeScreen.dart';

enum FocusState { Phone, Password, PasswordRepeat, SignUp }

class RegistrationController extends GetxController {
  Auth _auth;
  Database _db;
  FocusNode phoneFocus;
  FocusNode passwordFocus;
  FocusNode passwordRepeatFocus;
  FocusScopeNode focus = FocusScopeNode();
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  String _userEmail;
  String _userPassword;
  String _userPasswordRepeat;
  String _userPhone;

  /// Switches over the possible focus states on the textinputfields
  void focusState(FocusState focusState) {
    print(FocusScope.of(Get.context).ancestors);
    switch (focusState) {
      case FocusState.Phone:
        phoneFocus.requestFocus();
        break;
      case FocusState.Password:
        passwordFocus.requestFocus();
        break;
      case FocusState.PasswordRepeat:
        passwordRepeatFocus.requestFocus();
        break;
      case FocusState.SignUp:
        print('perform SignUp');
        break;
      default:
        print(focusState.toString());
        break;
    }
  }

  /// Updates the _userEmail variables
  void updateEmail(String email) {
    _userEmail = email;
  }

  /// Updates the _userPassword variables
  void updatePassword(String password) {
    _userPassword = password;
  }

  /// Updates the _userPasswordRepeat variables
  void updatePasswordRepeat(String password) {
    _userPasswordRepeat = password;
  }

  /// Updates the _userPhone variables
  void updatePhone(String phone) {
    _userPhone = phone;
  }

  /// Performs the sign up routine using the provided data in the registration fields
  void performSignUp() async {
    if (_checkEmail(_userEmail) &&
        _checkPasswords(_userPassword, _userPasswordRepeat) &&
        _checkPhone(_userPhone)) {
      if (await createUser()) {
        String userID = await _auth.currentUserID();
        print(userID);
        _db.getUsers(userID).listen((doc) async {
          if (doc.exists) {
            print(doc);
            if (doc.data()['UID'] == userID) {
              _toggleLoadingSignUp(true);
              await addUserPhoneNumber(maskFormatter.getUnmaskedText(), userID);
              _toggleLoadingSignUp(false);
              Get.offNamed(HomeScreen.id);
            }
          }
        });
      }
    }
  }

  // TODO tratar erros possiveis ao criar usuario
  Future<bool> createUser() async {
    if (await _auth.signUpUser(_userEmail, _userPassword)) {
      return true;
    }
    Get.snackbar('Ocorreu um erro ao criar o usuário', _auth.authErrorCode);
    return false;
  }

  /// Validates if the provided phone number is the correct length - (00) 00000 0000
  bool _checkPhone(phone) {
    // Todo fazer caso para telefones sem o 9 no início, ver mask
    if (phone.length != 15) {
      Get.snackbar('Numero de telefone inválido',
          'Favor inserir o telegone com o DDD e com dígito 9 na frente');
      return false;
    }
    return true;
  }

  /// Validates if the email provided is valid
  bool _checkEmail(String email) {
    if (email.isEmail) {
      return true;
    }
    Get.snackbar('Email invalido', 'Favor indicar um email valido');
    return false;
  }

  /// Validates if the provided passwords are equal
  bool _checkPasswords(String password, String passwordRepeat) {
    if (password != passwordRepeat) {
      Get.snackbar(
          'Senha invalida', 'As senhas devem informadas devem ser iguais');
      return false;
    }
    return true;
  }

  /// Calls the Firebase Cloud Function that writes the phone number to the corresponding userID
  Future<void> addUserPhoneNumber(
    String phone,
    String userID,
  ) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'addUserPhoneNumber',
    );
    await callable.call({'uid': userID, 'phone': phone});
    print('Call made');
  }

  /// Toggles the loading indicator to display waiting for the registries to be created on the database
  void _toggleLoadingSignUp(bool isLoading) {
    if (isLoading) {
      Get.dialog(
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              color: Colors.black,
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      if (Get.isDialogOpen) {
        Get.back(closeOverlays: true);
      }
    }
  }

  @override
  void onInit() {
    _db = Get.find<Database>();
    _auth = Get.find<Auth>();
    phoneFocus = FocusNode();
    passwordFocus = FocusNode();
    passwordRepeatFocus = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    phoneFocus.dispose();
    passwordFocus.dispose();
    passwordRepeatFocus.dispose();
  }
}
