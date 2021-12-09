import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConverter {
  static const double radiusEarth = 6371.0;

  static double degreeToKm(LatLng loc1, LatLng loc2) {
    double km;

    loc1 = LatLng(loc1.latitude * pi / 180, loc1.longitude * pi / 180);
    loc2 = LatLng(loc2.latitude * pi / 180, loc2.longitude * pi / 180);

    km = acos(sin(loc1.latitude) * sin(loc2.latitude) +
            cos(loc1.latitude) *
                cos(loc2.latitude) *
                cos(loc1.longitude - loc2.longitude)) *
        radiusEarth;

    return km;
  }
}
