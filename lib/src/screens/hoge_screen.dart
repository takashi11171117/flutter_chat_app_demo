import 'package:flutter/material.dart';

class HogeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Hoge(),
    );
  }
}

class Hoge extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hoge"),
      ),
      body: Center(
        child: const Text("Hoge"),
      ),
    );
  }
}