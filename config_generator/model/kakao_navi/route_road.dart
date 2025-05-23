import 'dart:convert';

import '../generator_latlng.dart';

class RouteRoad {
  final String name;
  final int distance;
  final int duration;
  final double trafficSpeed;
  final double trafficState;
  final List<double> vertexes;

  RouteRoad(
    this.name,
    this.distance,
    this.duration,
    this.trafficSpeed,
    this.trafficState,
    this.vertexes,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'distance': distance,
      'duration': duration,
      'trafficSpeed': trafficSpeed,
      'trafficState': trafficState,
      'vertexes': vertexes,
    };
  }

  factory RouteRoad.fromMap(Map<String, dynamic> map) {
    return RouteRoad(
      map['name'] as String,
      map['distance'] as int,
      map['duration'] as int,
      map['trafficSpeed'] as double,
      map['trafficState'] as double,
      List<double>.from(map['vertexes'] as List<double>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteRoad.fromJson(String source) =>
      RouteRoad.fromMap(json.decode(source) as Map<String, dynamic>);

  List<GeneratorLatLng> vertexesToLatLng() => List.generate(
    (vertexes.length / 2).toInt(),
    (index) => GeneratorLatLng(vertexes[index * 2 + 1], vertexes[index * 2]),
  );
}
