import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

final geo = GeoFlutterFire();
final _firestore = FirebaseFirestore.instance;

final List eventFormat = [
  {
    "id": "1",
    "name": "Dog walking",
    "description": "A walk with our furry friends :)",
    "location": {"lat": 45.46427, "lng": 9.20},
    "date-time": DateTime(2023, 12, 7, 15, 30),
    "icon": "assets/events_icons/dog-face_1f436.png",
  },
  {
    "id": "2",
    "name": "Bowling night",
    "description": "Let's score some strike tonight",
    "location": {"lat": 45.46427, "lng": 9.2036},
    "date-time": DateTime(2023, 12, 7, 15, 30),
    "icon": "assets/events_icons/bowling_1f3b3.png",
  },
];

Future<void> saveEvent(Map<String, dynamic> event) async {
  List<String> imageUrls = [];

  for (XFile image in event["images"]) {
    File file = File(image.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('images/$fileName');
    print("ciao 1");
    try {
      // Upload the file to Firebase Storage
      await reference.putFile(file);
      print("ciao 2");
      // Get the download URL of the uploaded file
      String imageUrl = await reference.getDownloadURL();

      // Add the URL to the list
      imageUrls.add(imageUrl);
      event["images"] = imageUrls;
    } catch (e) {
      print('Error uploading image: $e');
      // Handle the error as needed
    }
  }

  try {
    await _firestore.collection('events').add(event);
    print('Evento salvato con successo.');
  } catch (e) {
    print('Errore durante il salvataggio dell\'evento: $e');
  }
}

Future<List<Map<String, dynamic>>> getEventsNearby(
    LatLngBounds bounds, double radius) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot =
        await firestore.collection('events').where('location', isGreaterThan: {
      'lat': bounds.southwest.latitude,
      'lng': bounds.northeast.longitude,
    }).where('location', isLessThan: {
      'lat': bounds.northeast.latitude,
      'lng': bounds.southwest.longitude,
    }).get();
    List<Map<String, dynamic>> results = [];
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      results.add(document.data() as Map<String, dynamic>);
    }

    return results;
  } catch (e) {
    print("error feching events $e");
    return [];
  }
}
