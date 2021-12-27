import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data/map_style.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen(this.center);

  final center;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  late String? where = 'Selecione um local.';

  Future<LatLng> _getLocationByAddress(String address) async {
    final locations = await locationFromAddress(address);

    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(jsonEncode(mapStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            trafficEnabled: false,
            buildingsEnabled: false,
            onTap: (ai) async {
              mapController.animateCamera(
                CameraUpdate.newLatLng(ai),
              );

              final address = await placemarkFromCoordinates(ai.latitude, ai.longitude);


              setState(() {
                where = '${address.first.street}, ${address.first.name}, ${address.first.administrativeArea}, ${address.first.country}';
                print(where);
              });
            },
            onMapCreated: _onMapCreated,
            onCameraMove: (position) {},
            initialCameraPosition: CameraPosition(
              target: widget.center,
              zoom: 19.0,
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
                color: Colors.deepPurpleAccent,
              ),
              child: const Text(
                'Marque no mapa a localização correta.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomPaint(painter: _MarkerPainter()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(
                  context,
                  where,
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 40.0,
                margin: const EdgeInsets.only(
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.blueAccent,
                ),
                child: Text(
                  where!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      10,
      Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      5,
      Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.fill
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
