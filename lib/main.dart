import 'package:dima_project/create_event_page.dart';
import 'package:dima_project/find_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
        textTheme: GoogleFonts.latoTextTheme()
        //titleMedium: TextStyle(fontSize: , fontWeight: FontWeight.w700)
        ,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue, brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.dark,
      home: const NavBar(),
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
        const FindPage(),
        const CreateEventPage(),
        const Placeholder()
      ][pageIndex],
    );
  }
}
