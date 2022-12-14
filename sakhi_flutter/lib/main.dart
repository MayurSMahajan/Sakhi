import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:sakhi_flutter/services.dart';

import 'LatLang.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakhi App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Find Sanitary Stores'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with OSMMixinObserver {
  late MapController controller;
  bool showMap = true;

  List<LatLong> shops = [];
  List<LatLong> toilets = [];

  @override
  void initState() {
    controller = MapController(
      initMapWithUserPosition: true,
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );
    controller.addObserver(this);
    ShopServices.getShops().then((value) {
      setState(() {
        shops = value;
      });
    });
    ShopServices.getToilets().then((toil) {
      setState(() {
        toilets = toil;
      });
    });
    super.initState();
  }

  Future<void> mapIsInitialized() async {
    print("Inside Map is initialized");

    for (var i = 0; i < shops.length; i++) {
      await controller.addMarker(
        GeoPoint(
            latitude: double.parse(shops[i].lat),
            longitude: double.parse(shops[i].long)),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.store,
            color: Colors.teal,
            size: 100,
          ),
        ),
      );
    }

    for (var i = 0; i < toilets.length; i++) {
      await controller.addMarker(
        GeoPoint(
            latitude: double.parse(toilets[i].lat),
            longitude: double.parse(toilets[i].long)),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.woman,
            color: Colors.purple,
            size: 100,
          ),
        ),
      );
    }
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await mapIsInitialized();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(children: [
          showMap
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: OSMFlutter(
                    controller: controller,
                    trackMyPosition: true,
                    initZoom: 14,
                    minZoomLevel: 8,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_history_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      directionArrowMarker: MarkerIcon(
                        icon: Icon(
                          Icons.circle,
                          color: Colors.pink.shade500,
                          size: 72,
                        ),
                      ),
                    ),
                    roadConfiguration: RoadConfiguration(
                      startIcon: const MarkerIcon(
                        icon: Icon(
                          Icons.person,
                          size: 64,
                          color: Colors.brown,
                        ),
                      ),
                      roadColor: Colors.yellowAccent,
                    ),
                    markerOption: MarkerOption(
                        defaultMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 56,
                      ),
                    )),
                  ))
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(image: AssetImage("map.png"))),
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              height: 200,
              width: 60,
              child: Column(
                children: [
                  CircleAvatar(
                    minRadius: 38,
                    child: IconButton(
                      icon: const Icon(
                        Icons.zoom_in_outlined,
                        size: 32,
                      ),
                      onPressed: () async {
                        await controller.setZoom(stepZoom: 2);
                      },
                    ),
                  ),
                  CircleAvatar(
                    minRadius: 38,
                    child: IconButton(
                      icon: const Icon(
                        Icons.zoom_out_outlined,
                        size: 32,
                      ),
                      onPressed: () async {
                        await controller.setZoom(stepZoom: -2);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: SizedBox(
              height: 170,
              width: 60,
              child: Column(
                children: [
                  CircleAvatar(
                    minRadius: 38,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_location,
                        size: 32,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  CircleAvatar(
                    minRadius: 38,
                    child: IconButton(
                      icon: const Icon(
                        Icons.circle_outlined,
                        size: 32,
                      ),
                      onPressed: () async {
                        await controller.currentLocation();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}
