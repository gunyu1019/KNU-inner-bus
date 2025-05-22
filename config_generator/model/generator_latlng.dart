import 'dart:convert';

class GeneratorLatLng {
  final double latitude;
  final double longitude;

  GeneratorLatLng(this.latitude, this.longitude);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GeneratorLatLng.fromMap(Map<String, dynamic> map) {
    return GeneratorLatLng(
      map['latitude'] as double,
      map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneratorLatLng.fromJson(String source) => GeneratorLatLng.fromMap(json.decode(source) as Map<String, dynamic>);
}
