import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../helper/google_map_helper.dart';
import '../components/custom_window_widget.dart';

class HogeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Hoge(),
    );
  }
}

class Hoge extends StatefulWidget {
  Hoge({Key key}) : super(key: key);

  @override
  _HogeState createState() => _HogeState();
}

// class _HogeState extends State<Hoge> {
//   GoogleMapController mapController;

//   final LatLng _center = const LatLng(45.521563, -122.677433);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Maps Sample App'),
//           backgroundColor: Colors.green[700],
//         ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 11.0,
//           ),
//         ),
//       ),
//     );
//   }
// }

class _HogeState extends State<Hoge> {
  GoogleMapController _controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  List<_MarkerInfo> _markerInfoList = [];

  CarouselSlider _carouselSlider;

  LocationData _currentLocation;
  Location _locationService = Location();

  bool _isTappingMarker = false;

  StreamSubscription _mapIdleSubscription;
  InfoWidgetRoute _infoWidgetRoute;

  @override
  void initState() {
    super.initState();
    _location();
    _locationService.onLocationChanged().listen((LocationData result) async {
      setState(() {
        // print("onLocationChanged ${result.latitude} ${result.longitude}");
      });
    });
    _setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    _carouselSlider = CarouselSlider(
      items: _carouselItems(),
      scrollDirection: Axis.horizontal,
      enlargeCenterPage: true,
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      height: 120.0,
      onPageChanged: (index) {
        print("index $index");
        if (_markerInfoList.isNotEmpty && !_isTappingMarker) {
          final point = _markerInfoList.elementAt(index);
          _showInfoWindow(point);
        }
      },
    );
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.red,
                  child: _mapWidget(),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    height: 60,
                                    color: Colors.transparent,
                                    child: ButtonTheme(
                                      minWidth: 40,
                                      height: 40,
                                      child: RaisedButton(
                                        child: Text(
                                          '!',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        color: Colors.deepPurple,
                                        shape: CircleBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_markerInfoList.isNotEmpty) {
                                            setState(() {
                                              _markerClear();
                                            });
                                          } else {
                                            setState(() {
                                              _setMarkers();
                                            });
                                          }
                                        },
                                      ),
                                    ))),
                            Container(
                              height: 140,
                              color: Colors.black.withOpacity(0.3),
                              child: _carouselSlider.items.isNotEmpty
                                  ? _carouselSlider
                                  : null,
                            ),
                          ],
                        ))),
              ],
            )));
  }

  /// カルーセルのアイテム達
  List<Widget> _carouselItems() {
    return _markerInfoList.map((item) {
      return Builder(
        builder: (BuildContext context) {
          return Card(
              margin: EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      child: Image.asset(
                        item.imageName,
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          bottomLeft: Radius.circular(4.0)),
                    ),
                    Expanded(
                        child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(item.title),
                      ),
                    )),
                  ],
                ),
              ));
        },
      );
    }).toList();
  }

  Future _location() async {
    LocationData myLocation;
    try {
      myLocation = await _locationService.getLocation();
      // print("myLocation ${myLocation.latitude} ${myLocation.longitude}");
    } catch (e) {
      if (e.code == 'PERMISSION_DENITED')
        print('Permission denited');
      else if (e.code == 'PERMISSION_DENITED_NEVER_ASK')
        print(
            'Permission denited - please ask the user to enable it from the app settings');
      myLocation = null;
    }
    setState(() {
      _currentLocation = myLocation;
    });
  }

  Widget _mapWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation != null
              ? LatLng(_currentLocation.latitude, _currentLocation.longitude)
              : LatLng(34.702485, 135.495951),
          zoom: 14.0,
        ),
//        circles: Set<Circle>()
//          ..add(Circle(
//            circleId: CircleId('hi2'),
//            center: LatLng(47.6, 8.8796),
//            radius: 50,
//            strokeWidth: 10,
//            strokeColor: Colors.black,
//          )),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        markers: Set<Marker>.of(_markers.values),
        onCameraMoveStarted: () {
          // print("CameraPositionMove Start");
        },
        onCameraMove: (CameraPosition position) async {
          _mapIdleSubscription?.cancel();
          _mapIdleSubscription = Future.delayed(Duration(milliseconds: 300))
              .asStream()
              .listen((_) {
            if (_infoWidgetRoute != null) {
              Navigator.of(context, rootNavigator: true)
                  .push(_infoWidgetRoute)
                  .then(
                (newValue) {
                  _infoWidgetRoute = null;
                },
              );
            }
          });
          final region = await _controller.getVisibleRegion();
          print(
              "CameraPositionMoving position: ${position.target}, ${position.zoom}");
          print(
              "CameraPositionMoving region: ${region.northeast}, ${region.southwest}");
        },
        onCameraIdle: () {
          print("CameraPositionMove End");
          if (_isTappingMarker) {
            _isTappingMarker = false;
          }
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
//      _controller.complete(controller);
      _controller = controller;
    });
  }

  _onTap(_MarkerInfo point) async {
    print('onTap ${point.title}');
    _isTappingMarker = true;

    ///　カルーセル表示
    _carouselSlider.animateToPage(point.index,
        duration: Duration(milliseconds: 300), curve: Curves.linear);

    /// MarkerWindow表示
    await _showInfoWindow(point);
  }

  Future _showInfoWindow(_MarkerInfo point) async {
    final RenderBox renderBox = context.findRenderObject();
    Rect _itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    _infoWidgetRoute = InfoWidgetRoute(
      child: Stack(
        children: <Widget>[
          Container(
              child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              point.imageName,
              fit: BoxFit.fill,
              width: 150,
              height: 100,
            ),
          )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 30,
                  width: 150,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      point.title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ))),
        ],
      ),
      buildContext: context,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      mapsWidgetSize: _itemRect,
    );

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            point.location.latitude,
            point.location.longitude,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  /// マーカーセット
  void _setMarkerInfoList() {
    _markerInfoList = [
      _MarkerInfo(
        index: 0,
        markerId: MarkerId('0'),
        title: 'AAA',
        imageName: 'assets/abundance.jpg',
        location: LatLng(34.701895, 135.497085),
      ),
      _MarkerInfo(
        index: 1,
        markerId: MarkerId('1'),
        title: 'BBB',
        imageName: 'assets/bicycle.jpg',
        location: LatLng(34.704400, 135.500518),
      ),
      _MarkerInfo(
        index: 2,
        markerId: MarkerId('2'),
        title: 'CCC',
        imageName: 'assets/buildings.jpg',
        location: LatLng(34.704436, 135.495583),
      ),
      _MarkerInfo(
        index: 3,
        markerId: MarkerId('3'),
        title: 'DDD',
        imageName: 'assets/coffee.jpg',
        location: LatLng(34.709168, 135.486271),
      ),
      _MarkerInfo(
        index: 4,
        markerId: MarkerId('4'),
        title: 'EEE',
        imageName: 'assets/woman.jpg',
        location: LatLng(34.700030, 135.485927),
      ),
    ];
  }

  void _setMarkers() async {
    _setMarkerInfoList();
    final icon =
        await GoogleMapHelper.getBitmapFromAsset(100, 'assets/marker.png');
    setState(() {
      _markerInfoList.forEach((item) {
        _markers[item.markerId] = Marker(
            markerId: item.markerId,
            position: item.location,
            icon: icon,
//          infoWindow: InfoWindow(title: item.title, snippet: 'title'),
            onTap: () => _onTap(item));
      });
    });
  }

  void _markerClear() {
    _markerInfoList.clear();
    _markers.clear();
  }
}

class _MarkerInfo {
  final int index;
  final MarkerId markerId;
  final String title;
  final String imageName;
  final LatLng location;
  _MarkerInfo(
      {this.index, this.markerId, this.title, this.imageName, this.location});
}
