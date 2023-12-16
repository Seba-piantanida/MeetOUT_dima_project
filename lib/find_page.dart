import 'package:dima_project/events_list_view.dart';
import 'package:dima_project/events_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

const kGoogleApiKey = 'AIzaSyCMtEMbBqDdj3td0jpQb2x0nx4hBona7-s';

class _FindPageState extends State<FindPage> {
  final TextEditingController _locationInput = TextEditingController();

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
      SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        onSubmitted: (value) {
                          _getCoordinates(value);
                        },
                        controller: _locationInput,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EventsListView()));
                        },
                        icon: const Icon(Icons.align_horizontal_left_rounded)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: selectedEvents != null
              ? EventDetailsCard(
                  selectedEvents,
                  onClose: closeEventDetails,
                )
              : const SizedBox.expand(),
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

            setState(() {});
          });

      setState(() {});
    }
  }

  _getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        await mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(locations.first.latitude, locations.first.longitude),
        ));
      } else {
        print("indirizzo non trovato");
      }
    } catch (e) {
      print('Errore durante il recupero delle coordinate: $e');
    }
  }

  void closeEventDetails() {
    setState(() {
      selectedEvents = null;
    });
  }
}

class EventDetailsCard extends StatelessWidget {
  final dynamic event;
  final VoidCallback onClose;
  const EventDetailsCard(this.event, {super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
          elevation: 20,
          child: Stack(children: [
            Padding(
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
                          overflow: TextOverflow.ellipsis,
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
                                onPressed: () {}, child: const Text("Details"))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child:
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
            ),
          ])),
    );
  }
}
