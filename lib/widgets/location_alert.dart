import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_app/controller/request_permission.dart';

class LocationAlert extends StatefulWidget {
  const LocationAlert({super.key});

  @override
  State<LocationAlert> createState() => _LocationAlertState();
}

class _LocationAlertState extends State<LocationAlert> {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _controller.onStatusChanged.listen((status) {
      if (status == PermissionStatus.granted) {
        return;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Activa tú ubicación',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Da los permisos necesarios para que la\naplicación funcione de la manera mas optima.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF3B3B3B),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: 200,
            height: 45,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () {
                _controller.request();
                Navigator.pop(context);
              },
              child: const Center(
                child: Text(
                  'Dar acceso',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
            height: 45,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Center(
                child: Text(
                  'Denegar acceso',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
