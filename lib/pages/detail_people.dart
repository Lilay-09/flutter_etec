import 'package:assignment/services/people.dart';
import 'package:flutter/material.dart';

import '../model/people_model.dart';

class DetailPeoplePage extends StatelessWidget {
  const DetailPeoplePage({
    Key? key,
    required this.people,
  }) : super(key: key);

  final PeopleModel people;

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController(text: people.name);
    final gender = TextEditingController(text: people.gender);
    final email = TextEditingController(text: people.email);
    final address = TextEditingController(text: people.address);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create People'),
        actions: [
          IconButton(
            onPressed: () {
              var peopleModel = PeopleModel(
                id: people.id,
                name: name.text,
                gender: gender.text,
                address: email.text,
              );
              PeopleService().updatePeople(peopleModel);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.done),
          ),
          const SizedBox(width: 15.0),
        ],
      ),
      body: Padding(
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
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 26.0),
            TextField(
              controller: address,
              decoration: const InputDecoration(
                hintText: 'address',
              ),
            ),
            const SizedBox(height: 26.0),
            ElevatedButton.icon(
              onPressed: () {
                PeopleService().deletePeople(people.id!);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
