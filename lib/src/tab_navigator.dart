import 'package:flutter/material.dart';
import 'screens/channel_list_screen.dart';
import 'screens/hoge_screen.dart';

List<Widget> _widgetList = [
  HogeScreen(),
  ChannelList(),
];

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.selectedIndex});
  final GlobalKey<NavigatorState> navigatorKey;
  final int selectedIndex;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.root: (context) => _widgetList[selectedIndex],
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        print(routeSettings.name);
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}