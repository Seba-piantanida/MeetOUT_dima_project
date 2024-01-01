import 'dart:ui';

import 'package:dima_project/reusable_widget/map_viewer.dart';
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
                  child: Text(
                    event["name"],
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color),
                  ),
                )
              ]),
              background: event["images"].isEmpty
                  ? Stack(
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
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    )
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
