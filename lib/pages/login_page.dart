import 'package:assignment/pages/home_page.dart';
import 'package:assignment/pages/phone_num.dart';
import 'package:assignment/pages/sign_up.dart';
import 'package:assignment/services/fb_log_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../services/google_login.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    email.addListener(onListen);
    password.addListener(onListen);
  }

  @override
  void dispose() {
    super.dispose();
    email.removeListener(onListen);
    password.removeListener(onListen);
  }

  void onListen() => setState(() {});
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 190, 212),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://ik.imagekit.io/biosashbusiness/images/login-image.jpg',
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          suffixIcon: email.text.isEmpty
                              ? const SizedBox(
                                  width: 0.0,
                                )
                              : IconButton(
                                  onPressed: () {
                                    email.clear();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? 'Please enter email'
                              : null;
                        },
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        obscureText: isPassword,
                        controller: password,
                        style: const TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: password.text.isEmpty
                              ? const SizedBox(width: 0.0)
                              : IconButton(
                                  onPressed: () {
                                    if (isPassword) {
                                      setState(() => isPassword = false);
                                    } else {
                                      setState(() => isPassword = true);
                                    }
                                  },
                                  icon: Icon(isPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                        ),
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Password is Empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: Container(
                          width: 400,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            elevation: 1,
                            icon: SizedBox(
                              height: 40.0,
                              width: 50.0,
                              child: Image.asset('image/google.jfif'),
                            ),
                            onPressed: () {
                              GoogleSigninService().siginWithGoogle();
                              setState(() {});
                            },
                            label: Text(
                              'Signin with Google',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 400,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            elevation: 1,
                            icon: Container(
                              height: 40.0,
                              width: 50.0,
                              child: Image.asset('image/face.jpg'),
                            ),
                            onPressed: () {
                              FacebookLog().signInWithFacebook();
                            },
                            label: Text(
                              'SignIn with Facebook',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: Container(
                          width: 400,
                          child: FloatingActionButton.extended(
                              backgroundColor: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              elevation: 1,
                              icon: const SizedBox(
                                height: 40.0,
                                width: 50.0,
                                child: Icon(Icons.phone),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => LoginWithPhone()));
                              },
                              label: const Text('Phone number')),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          final form = formKey.currentState;
                          if (form!.validate()) {
                            signin();
                          }
                        },
                        child: const Text('LOGIN'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUp(),
                                ),
                              );
                            },
                            child: const Text('Create'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('No user found for that email.')),
          );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(' Wrong password provided for that user.'),
            ),
          );
      }
    }
  }

  Future<void> showLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
  }
}
