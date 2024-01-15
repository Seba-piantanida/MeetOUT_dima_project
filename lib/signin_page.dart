import 'dart:ui';

import 'package:dima_project/main.dart';
import 'package:dima_project/reusable_widget/reusable_widget.dart';
import 'package:dima_project/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black26,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            left: -100,
            top: 10,
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(255, 180, 50, 1.0),
                  Color.fromRGBO(200, 90, 120, 1.0),
                ]),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            right: -330,
            bottom: -330,
            child: Container(
              height: 660,
              width: 660,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(120, 80, 180, 1.0),
                  Color.fromRGBO(80, 100, 200, 1.0)
                ]),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                child: Column(children: [
                  Image.asset(
                    "assets/logo/logo_white_s.png",
                    height: 150,
                    width: 150,
                  ),
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Username", Icons.person_outlined, false,
                      _userNameController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Password", Icons.lock_outline, true,
                      _passwordController),
                  const SizedBox(
                    height: 20,
                  ),
                  firebaseUIButton(context, "Login", _signin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signin() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _userNameController.text, password: _passwordController.text)
        .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
              (route) => false,
            ));
  }
}
