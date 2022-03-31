import 'package:assignment/model/people_model.dart';
import 'package:assignment/services/people.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CreatePeoplePage extends StatefulWidget {
  const CreatePeoplePage({Key? key}) : super(key: key);

  @override
  State<CreatePeoplePage> createState() => _CreatePeoplePageState();
}

class _CreatePeoplePageState extends State<CreatePeoplePage> {
  final name = TextEditingController();
  final gender = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('tbPeople');

  Future<void> addContact() {
    return users.add({
      'name': name.text,
      'gender': gender.text,
      'email': email.text,
      'Address': address.text
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('People added')),
      );
    }).catchError((error) {
      debugPrint("Failed to add people: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create People'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              const SizedBox(height: 26.0),
              TextField(
                controller: gender,
                decoration: const InputDecoration(
                  hintText: 'Gender',
                ),
              ),
              const SizedBox(height: 26.0),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: 'email',
                ),
              ),
              const SizedBox(height: 26.0),
              TextField(
                controller: address,
                decoration: const InputDecoration(
                  hintText: 'Address',
                ),
              ),
              const SizedBox(height: 26.0),
              // ignore: deprecated_member_use
              FloatingActionButton(
                onPressed: () {
                  var people = PeopleModel(
                    name: name.text,
                    gender: gender.text,
                    email: email.text,
                    address: address.text,
                  );
                  PeopleService().createPeople(people);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
