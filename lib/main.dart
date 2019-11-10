import 'package:flutter/material.dart';
import 'package:flamingo/flamingo.dart';
import 'src/app.dart';

void main() {
  Flamingo.configure(rootName: 'version', version: 1);
  runApp(App());
}