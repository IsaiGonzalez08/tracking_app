import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/models/location.dart';

class ListSaveLocationScreen extends StatefulWidget {
  const ListSaveLocationScreen({super.key});

  @override
  State<ListSaveLocationScreen> createState() => _ListSaveLocationScreenState();
}

class _ListSaveLocationScreenState extends State<ListSaveLocationScreen> {
  Future<List<Location>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? locationsString = prefs.getString('locations');

    if (locationsString != null) {
      final List<dynamic> locationsJson = jsonDecode(locationsString);
      return locationsJson.map((json) => Location.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> _clearLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('locations');
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'List Save Location',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Location>>(
            future: getSavedLocations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No locations saved yet.'));
              } else {
                final locations = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return Container(
                      width: double.infinity,
                      height: 80,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: ListTile(
                        title: Text('Location ${index + 1}'),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Latitude: ${location.latitude}, Longitude: ${location.longitude}'),
                            const Text('CP:')
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                await _clearLocations();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
