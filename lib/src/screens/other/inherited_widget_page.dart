import 'package:flutter/material.dart';

class InheritedWidgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Inherited Widget")),
        body: ConfigWidget(
            config: 'Hello!',
            child: Center(
              child: ConfigUserWidget(),
            )));
  }
}

class ConfigUserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Data is ${ConfigWidget.of(context)}');
  }
}

class ConfigWidget extends InheritedWidget {
  final config;

  ConfigWidget({
    Key key,
    @required this.config,
    @required Widget child,
  })  : assert(config != null),
        assert(child != null),
        super(key: key, child: child);

  static String of(BuildContext context) {
    final ConfigWidget configWidget =
        context.inheritFromWidgetOfExactType(ConfigWidget);
    return configWidget?.config ?? '';
  }

  @override
  bool updateShouldNotify(ConfigWidget oldWidget) {
    return config != oldWidget.config;
  }
}
