import 'package:dima_project/check_auth.dart';
import 'package:dima_project/create_event_page.dart';
import 'package:dima_project/find_page.dart';
import 'package:dima_project/firebase_options.dart';
import 'package:dima_project/my_profile_page.dart';
import 'package:dima_project/tablet_find_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //fontFamily: GoogleFonts.manropeTextTheme(baseTheme.textTheme),

        //titleMedium: TextStyle(fontSize: , fontWeight: FontWeight.w700)

        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(255, 180, 50, 1.0),
            brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(80, 100, 200, 1.0),
            brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.system,
      home: const AuthCheck(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.message), label: "Chat"),
          NavigationDestination(icon: Icon(Icons.pin_drop), label: "Find"),
          NavigationDestination(icon: Icon(Icons.add), label: "Create"),
          NavigationDestination(icon: Icon(Icons.person), label: "Me"),
        ],
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
      body: <Widget>[
        const Placeholder(),
        MediaQuery.of(context).size.width <= 600
            ? const FindPage()
            : const TabletFindPage(),
        const CreateEventPage(),
        const MyProfilePage()
      ][pageIndex],
    );
  }
}
