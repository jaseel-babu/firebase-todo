import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todowithfirebase/model/todomodel.dart';

class Controller extends GetxController {
  List<Todomodel> todo = [];
  Todomodel todomodel = Todomodel();
  CollectionReference notesCollection =
      FirebaseFirestore.instance.collection("notes");

  storedatabase(String title, String notes) async {
    todomodel.title = title;
    todomodel.notes = notes;
    update(["refresh"]);
    return await notesCollection.add(todomodel.toMap());
  }

  List<Todomodel> todoFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Todomodel(
        title: (e.data() as dynamic)["title"],
        notes: (e.data() as dynamic)["notes"],
        uid: e.id,
      );
    }).toList();
  }

  read() {
    return notesCollection.snapshots().map(todoFromFirestore);
  }

  delete(String uid) async {
    await notesCollection.doc(uid).delete();
  }
}
