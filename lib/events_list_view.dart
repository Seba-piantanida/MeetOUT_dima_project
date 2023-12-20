import 'package:dima_project/events_details_page.dart';
import 'package:dima_project/events_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsListView extends StatefulWidget {
  final List<dynamic> events;

  const EventsListView(this.events, {super.key});

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
      body: ListView.builder(
          itemCount: widget.events.length,
          itemBuilder: (constext, index) {
            dynamic event = widget.events[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetailsPage(event)));
              },
              child: Card(
                child: Container(
                  height: 70,
                  child: Row(children: [
                    Image.asset(event["icon"]),
                    Column(
                      children: [
                        Text(event["name"]),
                        Text(event["all-day"]
                            ? DateFormat("dd-MM-yy")
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    event["date-time"].seconds * 1000))
                                .toString()
                            : DateFormat("dd-MM-yy  hh:mm")
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    event["date-time"].seconds * 1000))
                                .toString()),
                      ],
                    )
                  ]),
                ),
              ),
            );
          }),
    );
  }
}
