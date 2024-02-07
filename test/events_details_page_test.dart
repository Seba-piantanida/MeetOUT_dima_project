import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/events_details_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('events details page ...', (tester) async {
    var event = {
      'id': '13',
      'name': 'eventName',
      'description': 'test description',
      'icon': 'assets/events_icons/tropical-drink_1f379.png',
      'all-day': false,
      'date-time': Timestamp(10000, 10000),
      'images': [],
      'location': {'lat': 45.48008292982935, 'lng': 9.173457585275173},
      'owner': "asdfghjk"
    };
    Firebase.initializeApp();
    await tester.pumpWidget(MaterialApp(
      home: EventDetailsPage(event),
    ));
    // TODO: Implement test
  });
}
