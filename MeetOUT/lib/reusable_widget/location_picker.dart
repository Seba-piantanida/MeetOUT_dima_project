import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final Set<Marker> _markers = {};
  late GoogleMapController mapController;

  final TextEditingController _locationInput = TextEditingController();

  final LatLng _center = const LatLng(45.46427, 9.18951);
  LatLng? _location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: _markers,
              onLongPress: _selectLocation,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(target: _center, zoom: 14),
              onMapCreated: _onMapCreated,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                      color: Theme.of(context).cardColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(21))),
                        child: Expanded(
                          child: TextField(
                            onSubmitted: (value) {
                              _getCoordinates(value);
                            },
                            controller: _locationInput,
                            decoration: const InputDecoration(
                              hintText: 'Search or tap and hold the map',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: _location == null
                          ? null
                          : () {
                              Navigator.pop(context, _location);
                            },
                      child: const SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.pin_drop_outlined),
                            Text("Pick location"),
                          ],
                        ),
                      )),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        _selectLocation(
            LatLng(locations.first.latitude, locations.first.longitude));
      } else {
        print("indirizzo non trovato");
      }
    } catch (e) {
      print('Errore durante il recupero delle coordinate: $e');
    }
  }

  _selectLocation(LatLng location) async {
    _location = location;
    _markers.clear();
    _markers.add(Marker(markerId: const MarkerId("0"), position: location));
    setState(() {});
    await mapController.animateCamera(CameraUpdate.newLatLng(location));
  }
}
