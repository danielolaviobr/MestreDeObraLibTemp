import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Models/Bindings/RegistrationBindings.dart';
import 'package:mestre_de_obra/Models/Bindings/homeBindings.dart';
import 'package:mestre_de_obra/Models/Bindings/logInBindings.dart';
import 'package:mestre_de_obra/Views/paymentScreen.dart';

import 'Models/Bindings/PaymentBindings.dart';
import 'Models/auth.dart';
import 'Views/homeScreen.dart';
import 'Views/loginScreen.dart';
import 'Views/registrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool loggedIn = await Auth().isLoggedIn();
  runApp(MestreDeObra(loggedIn));
}

class MestreDeObra extends StatelessWidget {
  final bool loggedIn;
  MestreDeObra(this.loggedIn);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(accentColor: Color(0x00000000)),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      initialBinding: this.loggedIn ? HomeBindings() : LogInBindings(),
      getPages: [
        GetPage(
          name: '/',
          page: () => this.loggedIn ? HomeScreen() : LogInScreen(),
        ),
        GetPage(
          name: LogInScreen.id,
          page: () => LogInScreen(),
          binding: LogInBindings(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: RegistrationScreen.id,
          page: () => RegistrationScreen(),
          binding: RegistrationBindings(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: HomeScreen.id,
          page: () => HomeScreen(),
          binding: HomeBindings(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: PaymentScreen.id,
          page: () => PaymentScreen(),
          binding: PaymentBindings(),
          transition: Transition.leftToRight,
        ),
      ],
    );
  }
}
