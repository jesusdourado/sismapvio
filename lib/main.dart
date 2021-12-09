import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:s_p/report_screen.dart';
import 'package:s_p/utils/converter.dart';

import 'data/crime_report.dart';
import 'data/map_style.dart';

void main() => runApp(MaterialApp(
      home: const MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  LatLng _center = const LatLng(-3.0136698, -59.9507752);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(jsonEncode(mapStyle));
  }

  void _setCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        18.0,
      ),
    );
  }

  List<Marker> markers = [];

  final data = [
    LatLng(-3.014149, -59.949421),
    LatLng(-3.013186, -59.950963),
    LatLng(-3.014394, -59.950561),
    LatLng(-3.014232, -59.947883),
    LatLng(-3.009854, -59.952077),
    LatLng(-3.011678, -59.946876),
    LatLng(-3.014270, -59.954184),
  ];

  Future<void> _fillMarkers() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    for (int i = 0; i < data.length; i++) {
      markers.add(
        await CrimeReport(
                crimeLat: data[i].latitude, crimeLng: data[i].longitude)
            .toMarker(
          markerId: i + 1,
          onTap: () {},
        ),
      );
    }

    markers.add(
      Marker(
        markerId: MarkerId('0'),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
      ),
    );

    setState(() {

    });
  }

  @override
  void initState() {
    _determinePosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapToolbarEnabled: true,
              zoomControlsEnabled: false,
              trafficEnabled: false,
              buildingsEnabled: false,
              onTap: (ai) {
              },
              onMapCreated: _onMapCreated,
              onCameraMove: (position) {},
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 19.0,
              ),
              markers: Set<Marker>.of(markers),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {

                        markers = [];

                        await _fillMarkers();

                        LatLng greater = _center;
                        double dist = 100;

                        data.forEach((d){
                          final temp = MapConverter.degreeToKm(_center, d);
                          if(temp <  dist) {
                            dist = temp;
                            greater = d;
                          }
                        });

                        await mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            greater,
                            18.0,
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: const Icon(
                          Icons.search_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _setCurrentLocation();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                        child: const Icon(
                          Icons.adjust,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                alignment: Alignment.center,
                width: 400.0,
                height: 60,
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.redAccent,
                ),
                child: const Text(
                  'Não recomendado transitar na rua!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportCrimeScreen(),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  height: 40.0,
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.deepOrangeAccent,
                  ),
                  child: const Text(
                    'Reportar um delito',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
