import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getData() async {
    //هنا احضرت كوليكشن كامل
    var userdata = FirebaseFirestore.instance.collection('notes');
    var snapShot =
        await userdata.get().then((value) => value.docs.forEach((element) {
              // print(element.data());
              // print('=================');
            }));
    //هنا هاحضر document
    var userData = FirebaseFirestore.instance
        .collection('users')
        .doc('6hkFRiWO420SekWJ6tlq');
    await userData.get().then((value) {
      print(value.id);
      print('=================');
    });
    // var docs = snapShot.docs;
    // docs.forEach((element) {
    //   print(element.data());
    //   print('=================');
    // });
  }

  getDataByFilter() async {
    var userData = FirebaseFirestore.instance.collection('users');

    await userData
        .where("lang", arrayContains: "ar")
        .where('age', isEqualTo: 40)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
        print('===========================================');
        AwesomeDialog(
                context: context,
                body: Text(element.data().values.toString()),
                width: 500)
            .show();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              getDataByFilter();
            },
            child: Text('get'),
          )
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
