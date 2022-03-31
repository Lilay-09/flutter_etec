import 'package:assignment/model/people_model.dart';
import 'package:assignment/pages/create_contact.dart';
import 'package:assignment/pages/detail_people.dart';
import 'package:assignment/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/people.dart';

class ShowPeople extends StatelessWidget {
  ShowPeople({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People List'),
        centerTitle: false,
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // GoogleSigninService().logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LogIn()),
                  (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: StreamBuilder<List<PeopleModel>>(
        stream: PeopleService().getPeople(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              var data = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPeoplePage(people: data),
                    ),
                  );
                },
                title: Text(data.name!),
                subtitle: Text(data.address!),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
          );
        },
      ),
      // ignore: deprecated_member_use
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 100, bottom: 50),
        // ignore: deprecated_member_use
        child: RaisedButton(
          elevation: 0,
          color: Colors.amber,
          child: const Text('People Register'),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatePeoplePage()));
          },
        ),
      ),
    );
  }
}
