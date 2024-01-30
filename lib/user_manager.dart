import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final _firestore = FirebaseFirestore.instance;

Map<String, dynamic> _myUser = {};

List<dynamic> _myContacts = [];

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
    _myUser = user;
    print('user added');
  } catch (e) {
    print('Error adding user $e');
  }
}

Future<Map<String, dynamic>> getMyUser() async {
  if (_myUser.isEmpty) {
    await fetchMyUser();
  }
  return _myUser;
}

Future<Map<String, dynamic>> fetchMyUser() async {
  String? id = FirebaseAuth.instance.currentUser?.uid;
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

  if (user.isNotEmpty) {
    _myContacts = user['contacts'];
  }

  return user;
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
  } catch (e) {
    print("error feching user get userbyname $e");
  }

  return results;
}

bool isInMyContacts(String userId) {
  if (_myContacts.contains(userId)) {
    return true;
  } else {
    return false;
  }
}

addContact(String userId) async {
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

    List<dynamic> contacts = querySnapshot.docs.first.get('contacts') ?? [];

    contacts.add(userId);

    //update doc
    await targetUserRef.update({'contacts': contacts});
    _myContacts = contacts;
  } else {
    throw Exception('User not found');
  }
}

removeContact(String userId) async {
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

    List<dynamic> contacts = querySnapshot.docs.first.get('contacts') ?? [];

    contacts.remove(userId);

    await targetUserRef.update({'contacts': contacts});
    _myContacts = contacts;
  } else {
    throw Exception('User not found');
  }
}

List<dynamic> getMycontacts() {
  return _myContacts;
}
