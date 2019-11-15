import 'package:flutter/material.dart';

class CustomSingleChildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: Text("CustomSingleChildLayout Widget")),
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            color: Colors.red,
            child: CustomSingleChildLayout(
                delegate: _MySingleChildLayoutDelegate(
                  widgetSize: size,
                ),
                child: Text('aaaaaa')),
          ),
        ));
  }
}

class _MySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  _MySingleChildLayoutDelegate({@required this.widgetSize});

  final Size widgetSize;

  @override
  Size getSize(BoxConstraints constraits) {
    return constraits.constrain(Size(60, 60));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    //we place the widget at the cnter, by dividing the width and height by 2 to get the center
    print(widgetSize.width);
    print(widgetSize.height);
    print(childSize.width);
    print(childSize.height);
    return Offset(
      widgetSize.width / 2 - childSize.width / 2,
      widgetSize.height / 2 - childSize.height / 2,
    );
  }

  @override
  bool shouldRelayout(_MySingleChildLayoutDelegate oldDelegate) {
    return widgetSize != oldDelegate.widgetSize;
  }
}
