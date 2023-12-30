import 'package:dima_project/map_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final dynamic event;
  const EventDetailsPage(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Image.asset(
                  event["icon"],
                  scale: 2.8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(event["name"]),
                )
              ]),
              background: event["images"].isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.indigo.shade900,
                        Colors.blue.shade800,
                      ],
                    )))
                  : Image.network(
                      event["images"][0],
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverList.list(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    event["all-day"]
                        ? DateFormat("dd-MM-yy")
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                event["date-time"].seconds * 1000))
                            .toString()
                        : DateFormat("dd-MM-yy  hh:mm")
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                event["date-time"].seconds * 1000))
                            .toString(),
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Text(event["description"])),
            ),
            event["images"].length == 0
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: event["images"].length == 0
                              ? 0
                              : event["images"].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                          event["images"][index]))),
                            );
                          }),
                    ),
                  ),
            Text("data"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MapView(
                    center: LatLng(
                      event["location"]["lat"],
                      event["location"]["lng"],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 200,
            )
          ]),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          FloatingActionButton.extended(label: Text("Join"), onPressed: () {}),
    );
  }
}
