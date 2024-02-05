import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "App theme",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      DropdownButton(
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          underline: SizedBox(),
                          value: 'system',
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'system',
                              child: Text("System"),
                            ),
                            DropdownMenuItem<String>(
                              value: 'light',
                              child: Text("Light"),
                            ),
                            DropdownMenuItem<String>(
                              value: 'dark',
                              child: Text("Dark"),
                            )
                          ],
                          onChanged: (value) {})
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: GestureDetector(
                onTap: () async {
                  bool? res = false;
                  res = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: const Text(
                              'Are you sure you want to delate ur account?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // User selected 'OK'
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // User selected 'Cancel'
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      });

                  if (res!) {
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
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Delete account",
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
