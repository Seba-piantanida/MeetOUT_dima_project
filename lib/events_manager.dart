import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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

Future<Map<String, dynamic>> getEventById(String id) async {
  Map<String, dynamic> result = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot =
      await firestore.collection('events').where('id', isEqualTo: id).get();
  result = querySnapshot.docs[0].data() as Map<String, dynamic>;

  return result;
}

addEvents(String eventId) async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    // Esegui una query per trovare il documento utente con 'user-id' uguale a userId
    QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
        .instance
        .collection('users')
        .where('user-id', isEqualTo: userId)
        .get();

    if (userQuery.docs.isNotEmpty) {
      // Se trovato, aggiungi l'evento all'array 'my-events'
      DocumentReference<Map<String, dynamic>> userReference =
          userQuery.docs[0].reference;
      await userReference.update({
        'events': FieldValue.arrayUnion([eventId]),
      });
      print("evento salvato nei miei eventi");
    } else {
      print('Documento utente non trovato.');
      // Gestire il caso in cui il documento utente non è stato trovato
    }
  } else {
    print('Utente non autenticato.');
    // Gestire il caso in cui l'utente non è autenticato
  }
}

Future<void> addToMyEvents(String eventId) async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    // Esegui una query per trovare il documento utente con 'user-id' uguale a userId
    QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
        .instance
        .collection('users')
        .where('user-id', isEqualTo: userId)
        .get();

    if (userQuery.docs.isNotEmpty) {
      // Se trovato, aggiungi l'evento all'array 'my-events'
      DocumentReference<Map<String, dynamic>> userReference =
          userQuery.docs[0].reference;
      await userReference.update({
        'my-events': FieldValue.arrayUnion([eventId]),
      });
      print("evento salvato nei miei eventi");
    } else {
      print('Documento utente non trovato.');
      // Gestire il caso in cui il documento utente non è stato trovato
    }
  } else {
    print('Utente non autenticato.');
    // Gestire il caso in cui l'utente non è autenticato
  }
}

joinEvent(String eventId) async {}
