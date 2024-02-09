import 'dart:ui';

import 'package:dima_project/events_manager.dart';
import 'package:dima_project/im/chat.dart';
import 'package:dima_project/reusable_widget/map_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {
  final dynamic event;
  const EventDetailsPage(this.event, {super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  String _address = '';
  bool loaded = false;
  bool imOwner = true;
  bool isInMyevents = false;

  @override
  void initState() {
    _isInMyEvents();
    _imOwner();
    _getAddress();
    super.initState();
  }

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
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Image.asset(
                    widget.event["icon"],
                    scale: 2.8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.event["name"],
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleMedium?.color),
                      ),
                    ),
                  )
                ]),
              ),
              background: widget.event["images"].isEmpty
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
                      widget.event["images"][0],
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(14),
            sliver: SliverList.list(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    widget.event["all-day"]
                        ? DateFormat("dd-MM-yy")
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                widget.event["date-time"].seconds * 1000))
                            .toString()
                        : DateFormat("dd-MM-yy  hh:mm")
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                widget.event["date-time"].seconds * 1000))
                            .toString(),
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              ),
              Text(widget.event["description"]),
              const Divider(),
              widget.event["images"].length == 0
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 200,
                      width: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.event["images"].length == 0
                              ? 0
                              : widget.event["images"].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                          widget.event["images"][index]))),
                            );
                          }),
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Location",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                    minHeight: 150, maxHeight: 150, maxWidth: 600),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MapView(
                    center: LatLng(
                      widget.event["location"]["lat"],
                      widget.event["location"]["lng"],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _address != '' ? Text(_address) : const SizedBox.shrink(),
              const SizedBox(
                height: 100,
              )
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: !imOwner && loaded,
        child: isInMyevents
            ? FloatingActionButton.extended(
                label: const Text("Quit"),
                onPressed: () async {
                  await quitEvent(widget.event['id'], widget.event);
                  _isInMyEvents();
                })
            : FloatingActionButton.extended(
                label: const Text("Join"),
                onPressed: () async {
                  await joinEvent(widget.event['id'], widget.event, (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            selectedConversation: value,
                          ),
                        ));
                  });

                  _isInMyEvents();
                }),
      ),
    );
  }

  _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.event["location"]["lat"], widget.event["location"]["lng"]);
      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.street}, ${place.locality},  ${place.country}";
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  _imOwner() async {
    imOwner = widget.event['owner'] == FirebaseAuth.instance.currentUser?.uid;
  }

  _deleteEvent() {}

  _isInMyEvents() async {
    isInMyevents = await isInMyEvents(widget.event['id']);
    loaded = true;
    setState(() {});
  }
}
