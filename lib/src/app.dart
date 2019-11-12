import 'package:flutter/material.dart';
import 'app_page.dart';
import 'screens/splash.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channel',
      routes:  <String, WidgetBuilder>{
        '/splash': (_) => Splash(),
        '/': (_) => AppPage(),
      }
    );
  }
}