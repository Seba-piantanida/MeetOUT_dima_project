import 'package:flutter/material.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Events"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            )),
      ),
    );
  }
}
