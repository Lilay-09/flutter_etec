import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final email = TextEditingController();
  final password = TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();
  final formKey = GlobalKey<FormState>();

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
      backgroundColor: const Color.fromARGB(255, 224, 178, 224),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     'Register',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 480,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage('image/2.jpg')),
              ),
            ),
            const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          suffixIcon: email.text.isEmpty
                              ? const SizedBox(width: 0.0)
                              : IconButton(
                                  onPressed: () => email.clear(),
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                        autofillHints: const [AutofillHints.email],
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? 'Please enter a valid email'
                              : null;
                        },
                      ),
                      const SizedBox(height: 26.0),
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
                      const SizedBox(height: 26.0),
                      ElevatedButton(
                        onPressed: () {
                          final form = formKey.currentState!;
                          if (form.validate()) {
                            signup();
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signup() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) async {
        showDialog(
          context: context,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context); //not working
        Navigator.pop(context); //not working
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Weak password')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email.'),
            ),
          );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
