import 'dart:ffi' as ui;

import 'package:dima_project/events_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  dynamic selectedEvents;
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

  final LatLng _center = const LatLng(45.46427, 9.18951);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  void initState() {
    _generateMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 14),
        markers: _markers.values.toSet(),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: selectedEvents != null
              ? EventDetails(selectedEvents)
              : SizedBox.expand(),
        ),
      )
    ]);
  }

  _generateMarkers() async {
    for (int i = 0; i < events.length; i++) {
      BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), events[i]["icon"]);

      _markers[i.toString()] = Marker(
          markerId: MarkerId(events[i]["id"]),
          position: events[i]["location"],
          icon: markerIcon,
          onTap: () {
            selectedEvents = events[i];
            print(events[i]);
            print("selected event: $selectedEvents");
            setState(() {});
          });

      setState(() {});
    }
  }
}

class EventDetails extends StatelessWidget {
  final dynamic event;
  const EventDetails(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  event["icon"],
                  scale: 2,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event["name"],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Expanded(
                        child: Text(
                          event["description"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        children: [
                          Text(DateFormat("dd-MM-yy  hh:mm")
                              .format(event["date-time"])
                              .toString()),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {}, child: const Text("Join"))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
