import 'dart:ui';

import 'package:dima_project/events_manager.dart';
import 'package:dima_project/reusable_widget/contacts_list_view.dart';
import 'package:dima_project/reusable_widget/events_list_view.dart';
import 'package:dima_project/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage(this.user, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Image? profilePic;
  bool isLoaded = false;
  bool _isInMyContacts = false;

  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    actions: [
                      _isInMyContacts
                          ? Visibility(
                              visible:
                                  !(FirebaseAuth.instance.currentUser?.uid ==
                                      widget.user['user-id']),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await removeContact(
                                          widget.user['user-id']);
                                      _isInMyContacts = false;
                                      setState(() {});
                                    } catch (e) {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Error removing Contact'),
                                            content: const Text(
                                                'An error occurred while removing contact. Please try again.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.grey.shade700,
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white.withOpacity(0.5)
                                            : Colors.black.withOpacity(0.1),
                                    side: BorderSide(
                                        color: Colors.grey.shade700,
                                        width: 2.0),
                                  ),
                                  child: const Text("Remove"),
                                ),
                              ),
                            )
                          : Visibility(
                              visible:
                                  !(FirebaseAuth.instance.currentUser?.uid ==
                                      widget.user['user-id']),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    print('adding');
                                    try {
                                      await addContact(widget.user['user-id']);
                                      _isInMyContacts = true;
                                      setState(() {});
                                    } catch (e) {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Error Adding Contact'),
                                            content: const Text(
                                                'An error occurred while adding contact. Please try again.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white.withOpacity(0.5)
                                            : Colors.black.withOpacity(0.1),
                                    side: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  child: const Text("Add"),
                                ),
                              ),
                            )
                    ],
                    pinned: true,
                    floating: true,
                    snap: true,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle),
                            height: 50,
                            width: 50,
                            child: profilePic == null
                                ? Center(
                                    child: Text(widget.user["username"][0]))
                                : ClipOval(child: profilePic),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.user["username"],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.color),
                            ),
                          )
                        ],
                      ),
                      background: Stack(
                        children: [
                          Positioned(
                            left: -70,
                            top: -20,
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(255, 180, 50, 1.0),
                                  Color.fromRGBO(200, 90, 120, 1.0),
                                ]),
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -200,
                            top: 70,
                            child: Container(
                              height: 400,
                              width: 400,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(120, 80, 180, 1.0),
                                  Color.fromRGBO(80, 100, 200, 1.0)
                                ]),
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverList.list(children: <Widget>[
                      Text(
                        widget.user["bio"],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                    ]),
                  ),
                ];
              },
              body: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(height: 50),
                      child: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.list_rounded)),
                          Tab(icon: Icon(Icons.person_outline)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: events.isEmpty
                                ? const Center(child: Text('No events yet'))
                                : EventsListView(events, isPage: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: contacts.isEmpty
                                ? const Center(child: Text("No contacts"))
                                : ContactsListView(contacts),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _getData() async {
    if (widget.user["profile-pic"] != null) {
      profilePic = Image.network(
        widget.user["profile-pic"],
        fit: BoxFit.cover,
      );
    }
    print('user visualizzato: ${widget.user}');
    for (var eventsId in widget.user['my-events']) {
      try {
        var event = await getEventById(eventsId as String);
        events.add(event);
      } catch (e) {
        print('errore: $e');
      }
    }

    for (var contact in widget.user['contacts']) {
      try {
        var con = await getUserById(contact as String);
        contacts.add(con);
      } catch (e) {
        print('error getting contacts');
      }
    }
    try {
      //_isInMyContacts = await isInMyContacts(widget.user['user-id']);
    } catch (e) {
      print('error cheching contacts');
    }
    setState(() {
      isLoaded = true;
    });
  }
}
