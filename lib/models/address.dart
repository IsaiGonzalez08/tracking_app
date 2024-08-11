class Address {
  final String postalCode;

  Address({required this.postalCode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      postalCode: json['address']['postalCode'] ?? '',
    );
  }
}
