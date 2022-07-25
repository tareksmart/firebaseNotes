import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/routes/routes.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController userCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  var userName, email, password, user;

  signup() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          AwesomeDialog(
                  context: context, body: Text('No user found for that email'))
              .show();
        } else if (e.code == 'wrong-password') {
          //print('Wrong password provided for that user.');
          AwesomeDialog(
                  context: context,
                  body: Text('Wrong password provided for that user.'))
              .show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
              key: formKey,
              child: Container(
                /*transform: Matrix4.skewY(0.4)..rotateZ(-pi / 10.0),*/
                margin: EdgeInsets.all(4),
                child: Column(
                  children: [
                    Image.asset(
                      'images/log.png',
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                          hintText: 'email',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      controller: emailCont,
                      validator: (val) {
                        if (val!.isEmpty ||
                            val.length <= 2 ||
                            !val.contains('@')) {
                          return 'please insert email correctly';
                        }
                      },
                      onSaved: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      controller: passCont,
                      decoration: InputDecoration(
                          hintText: 'password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      validator: (val) {
                        if (val!.isEmpty || val.length <= 2) {
                          return 'password is less than 2 char';
                        }
                      },
                      onSaved: (val) {
                        password = val;
                      },
                    ),
                    MaterialButton(
                      onPressed: () async {
                        var user = await signup();
                        // print(user + ' ' + ' login response');
                        if (user != null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.home, (route) => false);
                        }
                      },
                      child: Text('logIn'),
                      color: Colors.amber,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.signup);
                        },
                        child: Text('click her to sign up'))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
