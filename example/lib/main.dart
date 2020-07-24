import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AmapCore.init('f6422eadda731fb0d9ffb3260a5cf899');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location _location;
  String _fenceStatus;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: DecoratedColumn(
          padding: EdgeInsets.symmetric(horizontal: kSpaceLarge),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('获取单次定位'),
              onPressed: () async {
                if (await requestPermission()) {
                  final location = await AmapLocation.instance.fetchLocation();
                  setState(() => _location = location);
                }
              },
            ),
            RaisedButton(
              child: Text('获取连续定位'),
              onPressed: () async {
                if (await requestPermission()) {
                  await for (final location
                      in AmapLocation.instance.listenLocation()) {
                    setState(() => _location = location);
                  }
                }
              },
            ),
            RaisedButton(
              child: Text('停止定位'),
              onPressed: () async {
                if (await requestPermission()) {
                  await AmapLocation.instance.stopLocation();
                  setState(() => _location = null);
                }
              },
            ),
            RaisedButton(
              child: Text('添加原型围栏'),
              onPressed: () async {
                if (await requestPermission()) {
                  AmapLocation.instance
                      .addCircleGeoFence(
                    center: LatLng(29, 119),
                    radius: 1000,
                    customId: 'testid',
                  )
                      .listen((event) {
                    setState(() {
                      _fenceStatus =
                          '状态: ${event.status}, 围栏id: ${event.fenceId}, 自定义id: ${event.customId}';
                    });
                  });
                }
              },
            ),
            RaisedButton(
              child: Text('添加poi围栏'),
              onPressed: () async {
                if (await requestPermission()) {
                  AmapLocation.instance
                      .addPoiGeoFence(
                    keyword: '肯德基',
                    customId: 'testid',
                    city: '兰溪',
                    aroundRadius: 10000,
                  )
                      .listen((event) {
                    setState(() {
                      _fenceStatus =
                          '状态: ${event.status}, 围栏id: ${event.fenceId}, 自定义id: ${event.customId}';
                    });
                  });
                }
              },
            ),
            if (_location != null)
              Center(
                child: Text(
                  _location.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_fenceStatus != null)
              Center(
                child: Text(
                  _fenceStatus.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    AmapLocation.instance.dispose();
    super.dispose();
  }
}

Future<bool> requestPermission() async {
  final permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);

  if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
    return true;
  } else {
    toast('需要定位权限!');
    return false;
  }
}
