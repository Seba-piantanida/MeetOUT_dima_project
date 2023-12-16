import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final LatLng center;

  const MapView({this.center = const LatLng(45.46427, 9.18951), super.key});

  @override
  State<MapView> createState() => _FindPageState();
}

class _FindPageState extends State<MapView> {
  late GoogleMapController mapController;

  final Set<Marker> markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    markers.clear;

    markers.add(Marker(markerId: const MarkerId("0"), position: widget.center));

    return GoogleMap(
        key: UniqueKey(),
        markers: markers,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: widget.center, zoom: 15));
  }
}
