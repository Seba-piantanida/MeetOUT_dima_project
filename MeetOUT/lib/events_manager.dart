import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

final geo = GeoFlutterFire();
final _firestore = FirebaseFirestore.instance;

Future<void> saveEvent(Map<String, dynamic> event) async {
  var groupData = await TencentImSDKPlugin.v2TIMManager
      .getGroupManager()
      .createGroup(
          groupType: "Public",
          groupName: event["name"],
          addOpt: GroupAddOptTypeEnum.V2TIM_GROUP_ADD_ANY);
  event["group-id"] = groupData.data;
  List<String> imageUrls = [];

  for (XFile image in event["images"]) {
    File file = File(image.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('images/$fileName');

    try {
      await reference.putFile(file);

      String imageUrl = await reference.getDownloadURL();

      // Add the URL to the list
      imageUrls.add(imageUrl);
      event["images"] = imageUrls;
    } catch (e) {
      //
    }
  }

  try {
    await _firestore.collection('events').add(event);
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

Future<bool> isInMyEvents(String eventId) async {
  String? myId = FirebaseAuth.instance.currentUser?.uid;

  if (myId == null) {
    throw Exception("Not logged in");
  }
  // collection "users"
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // fint user doc
  QuerySnapshot querySnapshot =
      await usersCollection.where('user-id', isEqualTo: myId).get();

  if (querySnapshot.docs.isNotEmpty) {
    List<dynamic> events = querySnapshot.docs.first.get('events') ?? [];

    return events.contains(eventId);
  } else {
    throw Exception('event not found');
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

joinEvent(String eventId, dynamic event,
    void Function(V2TimConversation)? callback) async {
  String? myId = FirebaseAuth.instance.currentUser?.uid;

  if (myId == null) {
    throw Exception("Not logged in");
  }
  // collection "users"
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // fint user doc
  QuerySnapshot querySnapshot =
      await usersCollection.where('user-id', isEqualTo: myId).get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentReference targetUserRef = querySnapshot.docs.first.reference;

    List<dynamic> events = querySnapshot.docs.first.get('events') ?? [];

    events.add(eventId);

    //update doc
    await targetUserRef.update({'events': events});
  } else {
    throw Exception('User not found');
  }

  var groupId = event?['group-id'] ?? "";
  print(groupId);
  if (groupId != "") {
    var result = await TencentImSDKPlugin.v2TIMManager
        .joinGroup(groupID: groupId, message: "");
    print(result);
    V2TimValueCallback<V2TimConversation> conv = await TencentImSDKPlugin
        .v2TIMManager.v2ConversationManager
        .getConversation(conversationID: "group_${groupId}");
    print(conv.data?.toJson());
    if (conv.data != null && callback != null) {
      callback(conv.data!);
    }
  }
}

quitEvent(String eventId, dynamic event) async {
  String? myId = FirebaseAuth.instance.currentUser?.uid;

  if (myId == null) {
    throw Exception("Not logged in");
  }

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot querySnapshot =
      await usersCollection.where('user-id', isEqualTo: myId).get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentReference targetUserRef = querySnapshot.docs.first.reference;

    List<dynamic> events = querySnapshot.docs.first.get('events') ?? [];

    events.remove(eventId);

    await targetUserRef.update({'events': events});
  } else {
    throw Exception('User not found');
  }

  var groupId = event?['group-id'] ?? "";
  print(groupId);
  if (groupId != "") {
    var result =
        await TencentImSDKPlugin.v2TIMManager.quitGroup(groupID: groupId);
    print(result.code);
  }
}
