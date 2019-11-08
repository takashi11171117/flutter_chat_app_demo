import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    getUser(context);
    return Scaffold(
      body: Center(
        child: const Text("Splash"),
      ),
    );
  }
}

FirebaseUser firebaseUser;
final FirebaseAuth _auth = FirebaseAuth.instance;

void getUser(BuildContext context) async {
  try {
    firebaseUser = await _auth.currentUser();
    print('uuuuu');
    if (firebaseUser == null) {
      await _auth.signInAnonymously();
    }
    Navigator.pushReplacementNamed(context, "/list");
  } catch (e) {
    print(e);
    Fluttertoast.showToast(msg: "Connecting of firebase is failed.");
  }
}