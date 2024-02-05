import 'dart:io';
import 'dart:ui';

import 'package:dima_project/reusable_widget/reusable_widget.dart';
import 'package:dima_project/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  XFile? _profilePic;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: updateProfile,
              child: const Text(
                "SAVE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Edit profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Edit your bio",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
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
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateProfile() async {
    if (_profilePic != null) {
      try {
        await changeProfilePic(_profilePic!);
        Navigator.of(context).pop();
      } catch (e) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('error updating profile picture, try leter'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    if (_userNameController.text.length >= 4) {
      try {
        await changeProfileName(_userNameController.text);
        Navigator.of(context).pop();
      } catch (e) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('error updating profile picture, try leter'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    if (_bioController.text.isNotEmpty) {
      try {
        await changeProfileBio(_bioController.text);
        Navigator.of(context).pop();
      } catch (e) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('error updating profile picture, try leter'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
