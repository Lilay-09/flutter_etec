import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleModel {
  String? id;
  String? name;
  String? gender;
  String? email;
  String? address;

  PeopleModel({
    this.id,
    this.name,
    this.gender,
    this.email,
    this.address,
  });

  PeopleModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'];
    gender = doc['gender'];
    email = doc['email'];
    address = doc['address'];
  }
  Map<String, dynamic> get toMap => {
        'name': name,
        'gender': gender,
        'email': email,
        'address': address,
      };
}
