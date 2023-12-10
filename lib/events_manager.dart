import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final List events = [
  {
    "id": "1",
    "name": "Dog walking",
    "description": "A walk with our furry friends :)",
    "location": const LatLng(45.46427, 9.18951),
    "date-time": DateTime(2023, 12, 7, 15, 30),
    "icon": "assets/events_icons/dog-face_1f436.png",
  },
  {
    "id": "2",
    "name": "Bowling night",
    "description": "Let's score some strike tonight",
    "location": const LatLng(45.46427, 9.20),
    "date-time": DateTime(2023, 12, 7, 15, 30),
    "icon": "assets/events_icons/bowling_1f3b3.png",
  },
];

List<dynamic> getEvents() {
  return events;
}

void addEvent(Map<String, dynamic> event) {
  events.add(event);
  print(events);
}
