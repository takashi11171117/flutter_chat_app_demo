import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseUser firebaseUser;
final FirebaseAuth _auth = FirebaseAuth.instance;

void loginDialog(BuildContext context) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email, password;
  firebaseUser = await _auth.currentUser();

  if (firebaseUser.isAnonymous) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Login"),
        content: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.mail),
                  labelText: 'Email',
                ),
                onSaved: (String value) {
                  email = value;
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.vpn_key),
                  labelText: 'Password',
                ),
                onSaved: (String value) {
                  password = value;
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Password is required.';
                  }
                  if (value.length < 6) {
                    return 'Password is over 6 charas';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        // ボタンの配置
        actions: <Widget>[
          cancelButton(context),
          submitButton(context, formKey, email, password),
          loginButton(context, formKey, email, password),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Confirm"),
        content: Text('Logined by ' + firebaseUser.email),
        actions: <Widget>[
          cancelButton(context),
          logoutButton(context),
        ],
      ),
    );
  }
}

Widget cancelButton(BuildContext context) {
  return FlatButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      });
}

Widget submitButton(BuildContext context, GlobalKey<FormState> formKey,
    String email, String password) {
  return FlatButton(
      child: const Text('Submit'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          createUser(context, email, password);
        }
      });
}

Widget loginButton(BuildContext context, GlobalKey<FormState> formKey,
    String email, String password) {
  return FlatButton(
      child: const Text('Login'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          signIn(context, email, password);
        }
      });
}

Widget logoutButton(BuildContext context) {
  return FlatButton(
      child: const Text('Logout'),
      onPressed: () {
        _auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
      });
}

void signIn(BuildContext context, String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  } catch (e) {
    Fluttertoast.showToast(msg: "Signin of Firebase is faileds.");
  }
}

void createUser(BuildContext context, String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  } catch (e) {
    Fluttertoast.showToast(msg: "Registering of firebase is failed.");
  }
}
