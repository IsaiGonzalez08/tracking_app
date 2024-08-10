import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_app/providers/location_provider.dart';
import 'package:tracking_app/widgets/location_alert.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Future<void> _showAlertPermissionsLocation() async {
    LocationProvider waitProvider = LocationProvider(Permission.location);
    bool isLocationPermissionGranted = await waitProvider.checkPermission();
    if (!isLocationPermissionGranted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const LocationAlert();
        },
      );
    }
  }

  @override
  void initState() {
    _showAlertPermissionsLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text(
          'Tracking app',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: InkWell(
          child: Container(
            width: 150,
            height: 45,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: const Center(
              child: Text(
                'LOCATION NOW',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
