import 'package:flutter/material.dart';
import 'custom_single_child_page.dart';
import 'inherited_widget_page.dart';

class OtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        home: Other(),
      ),
    );
  }
}

class Other extends StatefulWidget {
  Other({Key key}) : super(key: key);

  @override
  _OtherState createState() => _OtherState();
}

class _OtherState extends State<Other> {
  List<_DataSource> _dataSource = [];

  @override
  initState() {
    print('OtherPage initState');
    _dataSource = [
      _DataSource('CustomSingleChild', CustomSingleChildPage(),
          _ColorSet(0xFFD32F2F, 0xFFFFCDD2)),
      _DataSource('InheritedWidget', InheritedWidgetPage(),
          _ColorSet(0xFFD32F3A, 0xFFFFCD4F)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other'),
      ),
      body: _gradationListBody(),
    );
  }

  /// グラデーション & ripple effect
  Widget _gradationListBody() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final borderRadius = BorderRadius.circular(10.0);
          final data = _dataSource[index];
          return Card(
            margin: EdgeInsets.all(12.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            child: Container(
              height: 100.0,
              child: Material(
                type: MaterialType.transparency,
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: borderRadius,
                  child: Center(
                    child: Text(
                      data.title,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  onTap: () {
                    bool rootNavigator = false;
                    Navigator.of(context, rootNavigator: rootNavigator)
                        .push(MaterialPageRoute(
                      builder: (BuildContext context) => data.widget,
                    ));
                  },
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    colors: [
                      Color(data.colorSet.startValue),
                      Color(data.colorSet.endValue)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
            ),
          );
        },
        itemCount: _dataSource.length,
      ),
    );
  }
}

class _DataSource {
  final String title;
  final Widget widget;
  final _ColorSet colorSet;
  _DataSource(this.title, this.widget, this.colorSet);
}

class _ColorSet {
  final int startValue;
  final int endValue;
  _ColorSet(this.startValue, this.endValue);
}
