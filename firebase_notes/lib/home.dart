import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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

  getDataByFilter(BuildContext ctx) async {
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
                context: ctx,
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

  updateDataByTrans() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc('6hkFRiWO420SekWJ6tlq');

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docSnap = await transaction.get(docRef);
      if (docSnap.exists) {
        transaction.update(docRef, {"email": "40"});
      }
    });
  }

  batch() async {
    DocumentReference doc1 = FirebaseFirestore.instance
        .collection('users')
        .doc('6hkFRiWO420SekWJ6tlq');

    DocumentReference doc2 = FirebaseFirestore.instance
        .collection('users')
        .doc('fDksiSXRyQErMxtZHIHt');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.delete(doc1);
    batch.update(doc2, {"address": "luxor"});
    batch.commit();
  }

  List users = [];
  getUsers() async {
    var usersCol = FirebaseFirestore.instance.collection('users');

    await usersCol.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          users.add(element.data());
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getDfilesAndDir();
    //getUsers();
    super.initState();
  }

  var imagePic = ImagePicker();
  pickImage() async {
    File file;
    var imagePi = await imagePic.getImage(source: ImageSource.camera);
    if (imagePi != null) {
      file = File(imagePi.path);
      //رقم عشوائى واضافته الى اسم الصورة لعدم تكراره
      var random=Random().nextInt(1000);
      var imageName = '$random'+basename(file.path);
      // var refStorage = FirebaseStorage.instance.ref(
      //     'images/$imageName'); //عملنا فولدر اسمه images جواه الصورة اللى هتترفع
      //طريقة تانية لخلق مسارات
      var refStorage = FirebaseStorage.instance.ref(
          'images').child('part').child('$imageName');
      
      await refStorage.putFile(file);
      var url = await refStorage.getDownloadURL();

      print(url);
    }
  }

  getDfilesAndDir()async{
    var ref=await FirebaseStorage.instance.ref().list();//ref فقط يعمل وصول للجذر
    ref.items.forEach((element) {
      print('===================');
      print(element.name);
    });
  }
  getDirectory()async{//للحصول على اسماء الفولدرات
    var ref=await FirebaseStorage.instance.ref().list();

    ref.prefixes.forEach((element) {print(element.name);
    });
  }

  CollectionReference docRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              getUsers();
              setState(() {});
            },
            child: Text('get'),
          )
        ],
        title: Text('home'),
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
            future: docRef.get(),
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Text('no data');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title:
                            Text("${snapshot.data?.docs[index]['userName']}"),
                        subtitle:
                            Text("${snapshot.data?.docs[index]['address']}"),
                      );
                    }));
              }
              return Text('loading');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await pickImage();
          await getDirectory();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
