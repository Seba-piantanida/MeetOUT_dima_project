import 'dart:io';
import 'dart:ui';

import 'package:dima_project/main.dart';
import 'package:dima_project/reusable_widget/reusable_widget.dart';
import 'package:dima_project/signin_page.dart';
import 'package:dima_project/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  XFile? _profilePic;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: _undoRegistration,
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
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
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(children: [
                  GestureDetector(
                    onTap: () async {
                      _profilePic = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle),
                      height: 150,
                      width: 150,
                      child: _profilePic == null
                          ? const Icon(Icons.add_a_photo_outlined)
                          : ClipOval(
                              child: Image.file(
                                File(_profilePic!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  TextField(
                    controller: _bioController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    minLines: 4,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Tell us something more about you!",
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.9)),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                  ),
                  firebaseUIButton(context, "Finish", _completeSignUp),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _undoRegistration() async {
    bool? res = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Undo registration'),
          content: const Text('Are you sure to cancel registration procedure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Chiudi il dialog e ritorna false (non annullare la procedura).
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Chiudi il dialog e ritorna true (annulla la procedura).
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (res != null && res) {
      try {
        await FirebaseAuth.instance.currentUser!.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == "requires-recent-login") {
        } else {
          // Handle other Firebase exceptions
        }
      } catch (e) {
        // Handle general exception
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
      print("account rimosso con successo");
    }
  }

  void _completeSignUp() {
    if (_userNameController.text.length <= 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('The username is too short'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    try {
      createUserDetails(
          _userNameController.text, _bioController.text, _profilePic);
    } finally {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavBar()),
          (route) => false);
    }
  }
}
