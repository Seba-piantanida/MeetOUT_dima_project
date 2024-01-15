import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final _firestore = FirebaseFirestore.instance;

void createUserDetails(String userName, String bio, XFile? profilePic) async {
  String picUrl = "";
  if (profilePic != null) {
    File file = File(profilePic.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(
        'profilePics/${FirebaseAuth.instance.currentUser?.uid}/$fileName');
    print("ciao 1");
    try {
      // Upload the file to Firebase Storage
      await reference.putFile(file);

      // Get the download URL of the uploaded file
      picUrl = await reference.getDownloadURL();

      // Add the URL to the list
    } catch (e) {
      print('Error uploading image: $e');
      // Handle the error as needed
    }
  }

  Map<String, dynamic> user = {
    'user-id': FirebaseAuth.instance.currentUser?.uid,
    'username': userName,
    'bio': bio,
    'profile-pic': picUrl,
    'my-events': [],
    'events': [],
    'contacts': []
  };

  try {
    await _firestore.collection('users').add(user);
    print('Evento salvato con successo.');
  } catch (e) {
    print('Errore durante il salvataggio dell\'evento: $e');
  }
}

Future<Map<String, dynamic>> getUserById(String? id) async {
  Map<String, dynamic> user = {};

  if (id == null) {
    return user;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('user-id', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Estrai i dati dal primo documento nella QuerySnapshot
      user = querySnapshot.docs.first.data() as Map<String, dynamic>;
      //print(user);
    }
  } catch (e) {
    print("error feching events $e");
  }

  return user;
}

Future<List<Map<String, dynamic>>> getUsersByName(String name) async {
  List<Map<String, dynamic>> results = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('username', isEqualTo: name)
        .get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      results.add(document.data() as Map<String, dynamic>);
    }
    print("sciao beloooo: $results");
  } catch (e) {
    print("error feching events $e");
  }

  return results;
}

Future<bool> isInMyContacts(String userId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot userSnapshot = await firestore
        .collection('users')
        .where(
          'username',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get();

    Map<String, dynamic>? userData =
        userSnapshot.docs[0] as Map<String, dynamic>?;
    List<dynamic> userContacts = userData?['contacts'];
    if (userContacts.contains(userId)) {
      return true;
    }
  } catch (e) {
    print("error chaching if $userId is in contact");
  }
  return false;
}

addContact(String userId) async {}

removeContact(String userId) async {}
