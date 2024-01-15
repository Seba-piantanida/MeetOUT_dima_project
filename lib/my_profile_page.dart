import 'dart:ui';

import 'package:dima_project/edit_profile_page.dart';
import 'package:dima_project/events_manager.dart';
import 'package:dima_project/profile_search_page.dart';
import 'package:dima_project/reusable_widget/events_list_view.dart';
import 'package:dima_project/signin_page.dart';
import 'package:dima_project/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Image? profilePic;
  bool isLoaded = false;

  List<Map<String, dynamic>> myEvents = [];
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> contacts = [];

  Map<String, dynamic> user = {};

  @override
  void initState() {
    _getUser();
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
                      PopupMenuButton(
                        onSelected: (value) async {
                          switch (value) {
                            case 'edit':
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage()));
                              break;
                            case 'logout':
                              try {
                                // Sign out the user
                                await FirebaseAuth.instance.signOut();

                                // Navigate to the home page
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInPage(), // Replace LoginPage with your home page widget
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                print('Error during sign out: $e');
                              }
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit_outlined),
                              title: Text('Edit profile'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'settings',
                            child: ListTile(
                              leading: Icon(Icons.settings),
                              title: Text('Settings'),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: ListTile(
                              leading: Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.red.shade300,
                              ),
                              title: Text('Logout'),
                            ),
                          ),
                        ],
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
                              shape: BoxShape.circle,
                            ),
                            height: 50,
                            width: 50,
                            child: profilePic == null
                                ? const Center(child: Text("S"))
                                : ClipOval(child: profilePic),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user["username"],
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                              ),
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
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255, 180, 50, 1.0),
                                    Color.fromRGBO(200, 90, 120, 1.0),
                                  ],
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
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
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(120, 80, 180, 1.0),
                                    Color.fromRGBO(80, 100, 200, 1.0),
                                  ],
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
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
                        user["bio"],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                    ]),
                  ),
                ];
              },
              body: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints.expand(height: 70),
                      child: const TabBar(
                        tabs: [
                          Tab(
                              icon: Icon(Icons.list_rounded),
                              text: "my events"),
                          Tab(
                              icon: Icon(Icons.list_alt_rounded),
                              text: "events"),
                          Tab(
                              icon: Icon(Icons.person_outline),
                              text: "contacts"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: myEvents.isEmpty
                                ? const Center(child: Text('No events yet'))
                                : EventsListView(myEvents, isPage: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: events.isEmpty
                                ? const Center(child: Text('No events yet'))
                                : EventsListView(events, isPage: false),
                          ),
                          Flex(
                            direction: Axis.vertical,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchProfilePage(),
                                      ),
                                    );
                                    _getContacts();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.search),
                                        Text("Search people"),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _getUser() async {
    try {
      user = await getUserById(FirebaseAuth.instance.currentUser?.uid);
      _getData();
    } catch (e) {
      print("error fetching data");
    }
    if (user.isEmpty) {
      return;
    }
    setState(() {
      if (user["profile-pic"] != null) {
        profilePic = Image.network(
          user["profile-pic"],
          fit: BoxFit.cover,
        );
      }
      isLoaded = true;
    });
  }

  _getData() async {
    for (var eventsId in user['my-events']) {
      try {
        var event = await getEventById(eventsId as String);
        myEvents.add(event);
      } catch (e) {
        print('error: $e');
      }
    }

    for (var eventsId in user['events']) {
      try {
        var event = await getEventById(eventsId as String);
        events.add(event);
      } catch (e) {
        print('error: $e');
      }
    }

    for (var contact in user['contacts']) {
      try {
        var con = await getUserById(contact as String);
        contacts.add(con);
      } catch (e) {
        print('error getting contacts');
      }
    }
    setState(() {});
  }

  _getContacts() async {
    for (var contact in user['contacts']) {
      try {
        var con = await getUserById(contact as String);
        contacts.add(con);
      } catch (e) {
        print('error getting contacts');
      }
    }
    setState(() {});
  }
}
