import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo/providers/auth.dart';
import 'package:flutter_demo/types/firestore_user.dart';
import 'package:provider/provider.dart';

class Firestore {
  // NOTE: as explained in index.ts, these 2 functions wouldn't be necessary in a released app
  Future<bool> checkNewUser(String id) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    return !documentSnapshot.exists;
  }

  Future<void> updateUser(FirestoreUser user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    }).then((value) {
      print("Document added successfully");
    }).catchError((error) {
      print("Failed to add document: $error");
    });
  }
}
