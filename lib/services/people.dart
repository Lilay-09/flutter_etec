import 'package:assignment/model/people_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PeopleService {
  String tbPeople = 'tbPeople';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createPeople(PeopleModel peopleModel) async {
    try {
      firestore.collection(tbPeople).add(peopleModel.toMap);
    } catch (e) {
      debugPrint('Error create people => $e');
    }
  }

  Stream<List<PeopleModel>> getPeople() {
    return firestore.collection(tbPeople).snapshots().map((event) {
      List<PeopleModel> list = [];
      for (var element in event.docs) {
        list.add(PeopleModel.fromDocumentSnapshot(element));
      }
      return list;
    });
  }

  Future<void> updatePeople(PeopleModel people) async {
    try {
      firestore.collection(tbPeople).doc(people.id).update(people.toMap);
    } catch (e) {
      debugPrint('Error update people => $e');
    }
  }

  Future<void> deletePeople(String id) async {
    try {
      firestore.collection(tbPeople).doc(id).delete();
    } catch (e) {
      debugPrint('Error delete people => $e');
    }
  }
}
