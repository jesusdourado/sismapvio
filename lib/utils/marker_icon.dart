import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIcon {
  MarkerIcon({
    required this.path,
    required this.width,
  });

  final String path;
  final int width;

  Future<BitmapDescriptor> getBitmapDescriptor() async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();

    final icon = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(icon);
  }
}
