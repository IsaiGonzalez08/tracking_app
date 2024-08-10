import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  final Permission _locationPermission;

  LocationProvider(this._locationPermission);

  Future<bool> checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    return isGranted;
  }
}