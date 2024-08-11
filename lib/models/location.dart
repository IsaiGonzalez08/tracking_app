class Location {
  final double latitude;
  final double longitude;
  final String? postalCode;

  Location({required this.latitude, required this.longitude, this.postalCode});

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        if (postalCode != null) 'postalCode': postalCode,
      };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
      postalCode: json['postalCode'],
    );
  }
}
