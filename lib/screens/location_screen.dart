import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/models/address.dart';
import 'package:tracking_app/models/location.dart';
import 'package:tracking_app/providers/location_provider.dart';
import 'package:tracking_app/screens/list_save_location.dart';
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
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return const LocationAlert();
        },
      );
    }
  }

  Future<Location> getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return Location(
          latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      throw ('El error es $e');
    }
  }

  Future<void> saveLocation(
      double latitude, double longitude, String postalCode) async {
    final prefs = await SharedPreferences.getInstance();

    final String? locationsString = prefs.getString('locations');
    List<Location> locations = [];

    if (locationsString != null) {
      final List<dynamic> locationsJson = jsonDecode(locationsString);
      locations = locationsJson.map((json) => Location.fromJson(json)).toList();
    }

    locations.add(Location(
        latitude: latitude, longitude: longitude, postalCode: postalCode));

    final String updatedLocationsString =
        jsonEncode(locations.map((loc) => loc.toJson()).toList());
    await prefs.setString('locations', updatedLocationsString);
  }

  Future<void> _handleLocationNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Obteniendo ubicación...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      Location location = await getUserLocation();
      print('Ubicación: ${location.latitude} ${location.longitude}');
      final address = await getAddress(
          location.latitude.toString(), location.longitude.toString());
      print('El codigo postal de ubicación es: ${address.postalCode}');
      await saveLocation(
          location.latitude, location.longitude, address.postalCode);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching location: $e');
    } finally {
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => const ListSaveLocationScreen()));
    }
  }

  Future<Address> getAddress(String latitude, String longitude) async {
    final dio = Dio();
    final String token = dotenv.env['HERE_MAPS_API_TOKEN'] ?? '';
    try {
      final response = await dio.get(
        'https://browse.search.hereapi.com/v1/browse',
        queryParameters: {"apiKey": token, "at": "$latitude,$longitude"},
      );
      if (response.data['items'] != null && response.data['items'].isNotEmpty) {
        final firstItem = response.data['items'][0];
        final address = Address.fromJson(firstItem);
        return address;
      } else {
        throw ('No se encontraron direcciones para la ubicación proporcionada');
      }
    } catch (e) {
      throw ('el error es $e');
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListSaveLocationScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.list),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _handleLocationNow,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
