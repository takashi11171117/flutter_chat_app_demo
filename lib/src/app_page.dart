import 'package:flutter/material.dart';
import 'tab_navigator.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return _scaffoldBody();
  }

  int _selectedIndex = 0;
  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _scaffoldBody() {
    return WillPopScope(
        onWillPop: () async {
          final keyTab = _navigatorKeys[_selectedIndex];
          if (keyTab.currentState.canPop()) {
            return !await keyTab.currentState.maybePop();
          }
          return Future.value(true);
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text('map')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text('map')
              ),
            ],
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.black,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        )
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: index != _selectedIndex,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[index],
        selectedIndex: index,
      ),
    );
  }
}

