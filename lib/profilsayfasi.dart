import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseblog1/anasayfa.dart';
import 'package:firebaseblog1/main.dart';
import 'package:firebaseblog1/yazisayfasi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//test 2
class ProfilEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Sayfası"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => AnaSayfa()),
                  (Route<dynamic> route) => true);
            },
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => Iskele()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => YaziEkrani()),
                (Route<dynamic> route) => true);
          }),
      body: profitasarimi(),
    );
  }
}

@override
Widget build(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;

  Query blogYazilari = FirebaseFirestore.instance
      .collection('Yazilar')
      .where("kullaniciEmail", isEqualTo: auth.currentUser!.email);

  return StreamBuilder<QuerySnapshot>(
    stream: blogYazilari.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Text(data['baslik']),
            subtitle: Text(data['icerik']),
          );
        }).toList(),
      );
    },
  );
}

class profitasarimi extends StatefulWidget {
  const profitasarimi({Key? key}) : super(key: key);

  @override
  _profitasarimiState createState() => _profitasarimiState();
}

class _profitasarimiState extends State<profitasarimi> {
  late File
      yuklenecekDosya; // Kameradan aldığımız dosyayı tutacak kalıcı değişken.
  FirebaseAuth auth = FirebaseAuth.instance; // Kullanıcı id'sini almak için.
  late String
      indirmeBaglantisi; // Storage'daki resmin url bağlantısını tutacak.

  kameradanYukle() async {
    var alinanDosya = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      yuklenecekDosya = File(alinanDosya!.path);
    });
    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilResmi.png");

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    String url = await (await yuklemeGorevi.onComplete).ref.getDownloadURL();

    setState(() {
      indirmeBaglantisi = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
