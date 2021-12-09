import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:s_p/utils/marker_icon.dart';

class CrimeReport {
  CrimeReport({
     this.victimName = '',
     this.victimCPF = '',
     this.victimSex = '',
     this.victimBirth = '',
     this.crime = '',
    this.highLevelLocation = '',
     this.crimeTime = '',
     this.crimeLat = 0.0,
     this.crimeLng = 0.0,
     this.suspectsDescription = '',
  });

   String victimName;
   String victimCPF;
   String victimSex;
   String victimBirth;
   String crime;
   String highLevelLocation;
   String crimeTime;
   double crimeLat;
   double crimeLng;
   String suspectsDescription;

  Future<Marker> toMarker({required int markerId, required Function() onTap}) async {
    return Marker(
      markerId: MarkerId(markerId.toString()),
      onTap: onTap,
      icon: await MarkerIcon(path: 'assets/weapon.png', width: 150).getBitmapDescriptor(),
      position: LatLng(crimeLat, crimeLng),
    );
  }
}
