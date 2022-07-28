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
    var userdata = FirebaseFirestore.instance.collection('users');
    var snapShot = await userdata
        .orderBy('age', descending: false)
        .endBefore([20])
        .get()
        .then((value) => value.docs.forEach((element) {
              print(element.data()['userName']);
              print(element.data()['age']);
              print('=================');
            }));
    //هنا هاحضر document
    // var userData = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc('6hkFRiWO420SekWJ6tlq');
    // await userData.get().then((value) {
    //   print(value.id);
    //   print('=================');
    // });
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

  getDataFilt() async {
    var users = FirebaseFirestore.instance.collection('users');

    await users
        .limit(1)
        .orderBy("userName", descending: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data()['userName']);
        print(element.data()['age']);
      });
    });
  }

//سحب البيانات مباشر
  getDataByRealTimeSnapShot() async {
    var users = FirebaseFirestore.instance.collection('users');
    await users.snapshots().listen((event) {
      event.docs.forEach((element) {
        print('userName:${element.data()['userName']}');
        print('age:${element.data()['age']}');
        print('email:${element.data()['email']}');
        print('===========================');
      });
    });
  }

  addData() async {
    var data = FirebaseFirestore.instance.collection('users');
    // await data.add({
    //   'userName': 'ali',
    //   'age': '60',
    //   'address': 'zannia'
    // }); //اضافة بيانات لكن الفايربيس هو اللى بيكريت ال id

//اضافة مستخدم او دوكيمنت ب اى  دى ثابت وممكن تختار اى دى موجود بالفعل وتعمله سيت لكن لو فى حقول موجوده هيبدلها بالجديد
    // await data.doc('6hkFRiWO420SekWJ6tlq').set(
    //     {'userName': 'tarek rabia', 'age': '37',
    //     'email': 'tarek@gmail.com'});
    //هنا هيعدل فقط الحقول المذكورة وهيسيب الباقى زى ماهو
    // await data.doc('fDksiSXRyQErMxtZHIHt').set(
    //     {'userName': 'tarek rabia', 'age': '37', 'email': 'tarek@gmail.com'},
    //     SetOptions(merge: true));

    // await data.doc('fDksiSXRyQErMxtZHIHt').set(
    //     {'userName': 'tarek rabia', 'age': '37', 'email': 'tarek@gmail.com'},
    //     SetOptions(mergeFields: ['userName','age3']));

    // await data.doc('150120140').update({'userName': 'zezo'}).then((value) {
    //   print('update succ');
    // }).catchError((e) {
    //   print(e);
    // });

    await data.doc('1501201400').delete().then((value) {
      print('data deleted');
    }).catchError((e) {
      print(e);
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
              addData();
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
