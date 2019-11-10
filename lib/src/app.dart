import 'package:flutter/material.dart';
import 'screens/channel_list_screen.dart';
import 'screens/splash.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channel',
      routes:  <String, WidgetBuilder>{
        '/': (_) => Splash(),
        '/list': (_) => ChannelListScreenStateful(),
      }
    );
  }
}