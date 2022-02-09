import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoResim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ButonEkrani(),
    );
  }
}

class ButonEkrani extends StatefulWidget {
  @override
  _ButonEkraniState createState() => _ButonEkraniState();
}

class _ButonEkraniState extends State<ButonEkrani> {
  late File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String indirmeBaglantisi;

  kameradadanVideoYukle() async {
    var alinanDosya = await ImagePicker().getVideo(source: ImageSource.camera);
    setState(() {
      yuklenecekDosya = File(alinanDosya!.path);
    });

    Reference referansYol =
        FirebaseStorage.instance.ref().child("videolar").child("videom.mp4");

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    String url = await (await yuklemeGorevi.onComplete).ref.getDownloadURL();
    setState(() {
      indirmeBaglantisi = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RaisedButton(
              child: Text("Video Yükle"), onPressed: kameradadanVideoYukle),
        ],
      ),
    );
  }
}
