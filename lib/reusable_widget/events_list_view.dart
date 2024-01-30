import 'package:dima_project/events_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsListView extends StatefulWidget {
  final List<dynamic> events;
  final bool isPage;

  const EventsListView(this.events, {this.isPage = true, super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ListView.builder(
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
              child: SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    ClipOval(child: Image.asset(event["icon"])),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            event["name"],
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          )),
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
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });

    if (widget.isPage) {
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
          body: body);
    } else {
      return body;
    }
  }
}
