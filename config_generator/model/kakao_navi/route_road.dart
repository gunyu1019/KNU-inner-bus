import 'dart:convert';

import '../generator_latlng.dart';

class RouteRoad {
  final String name;
  final int distance;
  final int duration;
  final double trafficSpeed;
  final int trafficState;
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
      'traffic_speed': trafficSpeed,
      'traffic_state': trafficState,
      'vertexes': vertexes,
    };
  }

  factory RouteRoad.fromMap(Map<String, dynamic> map) {
    return RouteRoad(
      map['name'] as String,
      map['distance'] as int,
      map['duration'] as int,
      map['traffic_speed'] as double,
      map['traffic_state'] as int,
      List<double>.from(map['vertexes'] as List<dynamic>),
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
