import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/routes/routes.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController userCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  var userName, email, password;

  signup() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //print('The password provided is too weak.');
          AwesomeDialog(
                  context: context,
                  body: Text('The password provided is too weak.'))
              .show();
        } else if (e.code == 'email-already-in-use') {
          //print('The account already exists for that email.');
          AwesomeDialog(
                  context: context,
                  body: Text('The account already exists for that email.'))
              .show();
        }
      } catch (e) {
        print(e);
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
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  /* transform: Matrix4.skewY(0.3)..rotateZ(-pi / 12.0),*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/log.png', width: 150),
                      TextFormField(
                        key: ValueKey('userName'),
                        decoration: InputDecoration(
                            hintText: 'user name',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        controller: userCont,
                        validator: (val) {
                          if (val!.isEmpty || val.length <= 2) {
                            return 'user is less than 2 char';
                          }
                        },
                        onSaved: (val) {
                          userName = val;
                        },
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        decoration: InputDecoration(
                            hintText: 'email',
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
                      TextFormField(
                        obscureText: true,
                        key: ValueKey('password'),
                        controller: passCont,
                        decoration: InputDecoration(
                            hintText: 'password',
                            
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
                          if (user != null)
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.login, (route) => false);
                        },
                        child: Text('save'),
                        color: Colors.amber,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.login);
                          },
                          child: Text(
                            'click her to log in',
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
