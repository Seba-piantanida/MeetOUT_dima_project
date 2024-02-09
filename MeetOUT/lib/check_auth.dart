import 'package:dima_project/main.dart';
import 'package:dima_project/signin_page.dart';
import 'package:dima_project/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'im/im.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Attendi il caricamento dello stato di autenticazione
        } else if (snapshot.hasData) {
          // why not have it?
          im().initIMSDK();
          getMyUser();
          return const NavBar();
          //this is the merged version
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
