import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

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
        primarySwatch: Colors.blue,
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
    super.initState();
  }

  Future<void> mapIsInitialized() async {
    await controller.addMarker(
      GeoPoint(latitude: 47.442475, longitude: 8.4680389),
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.sanitizer,
          color: Colors.red,
          size: 72,
        ),
      ),
    );
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
          Container(
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
            ),
          ),
          Container(
            height: 200,
            width: 60,
            child: Column(
              children: [
                CircleAvatar(
                  child: IconButton(
                    icon: const Icon(
                      Icons.zoom_in_outlined,
                      size: 38,
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  child: IconButton(
                    icon: const Icon(
                      Icons.zoom_out_outlined,
                      size: 38,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
