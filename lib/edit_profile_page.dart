import 'dart:io';
import 'dart:ui';

import 'package:dima_project/reusable_widget/reusable_widget.dart';
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              "SAVE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Edit profile",
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
}
