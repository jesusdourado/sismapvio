import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:s_p/report_screen.dart';
import 'package:s_p/utils/converter.dart';
import 'package:s_p/utils/http_class.dart';
import 'data/crime_report.dart';
import 'data/map_style.dart';
import 'package:dio/dio.dart' as dio;

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
  List<Marker> markers = [];
  late PausableTimer timer;

  List<LatLng> data = [
    LatLng(-3.014149, -59.949421),
    LatLng(-3.013186, -59.950963),
    LatLng(-3.014394, -59.950561),
    LatLng(-3.014232, -59.947883),
    LatLng(-3.009854, -59.952077),
    LatLng(-3.011678, -59.946876),
    LatLng(-3.014270, -59.954184),
  ];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(jsonEncode(mapStyle));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _setCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _center = LatLng(
      position.latitude,
      position.longitude,
    );

    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_center, 19.0),
    );
  }

  Future<void> _sendOcorrencia(Map ocorrencia) async {
    // -> Ocorrencia
    // name: String
    // rg: String
    // sexo: String
    // data: String
    // descricao:  String
    // quando: String
    // onde: String
    // delito: int

    final response = await dio.Dio().post(
      WebRoutes.registerOcorrencia,
      data: ocorrencia,
    );
  }

  Future<Response> _getOcorrencias() async {
    final response = await dio.Dio().get(WebRoutes.listOcorrencias);
    print(response);

    return response;
  }

  Future<void> _fillMarkers() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    Response result = await _getOcorrencias();
    var mapped = result.data['data'].values;

    List mapped2 = [];

    mapped.forEach((m){
      mapped2.add(m);
    });

    List coords = [];
    markers = [];
    data = [];

    for(int i = 0; i < mapped2.length; i ++) {
      var loc = await _getLocationByAddress(mapped2[i].toString());
      coords.add(loc);
      data.add(loc);
    }

    print(data);
    print(coords);

    for (int i = 0; i < coords.length; i++) {
      markers.add(
        await CrimeReport(
          crimeLat: coords[i].latitude,
          crimeLng: coords[i].longitude,
        ).toMarker(
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

    setState(() {});
  }

  Future<LatLng> _getLocationByAddress(String address) async {
    final locations = await locationFromAddress(address);

    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  @override
  void initState() {
    _determinePosition();

    timer = PausableTimer(Duration(milliseconds: 4000), () async {
      print('começou');
      await _fillMarkers();
    });

    timer.start();

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
                print(ai);
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

                        data.forEach((d) {
                          final temp = MapConverter.degreeToKm(_center, d);
                          if (temp < dist) {
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
                onTap: () async {
                  print('get ocorrencias');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportCrimeScreen(_center),
                    ),
                  ).then((value) async => await _fillMarkers());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  height: 40.0,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
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
