import 'dart:convert';

import 'route_bound.dart';
import 'route_position.dart';

class RouteSummary {
  final RoutePosition origin;
  final RoutePosition destination;
  final List<RoutePosition> waypoints;
  final String priority;
  final RouteBound bound;
  // final Object fare
  final int distance;
  final int duration;

  RouteSummary(
    this.origin,
    this.destination,
    this.waypoints,
    this.priority,
    this.bound,
    this.distance,
    this.duration,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'origin': origin.toMap(),
      'destination': destination.toMap(),
      'waypoints': waypoints.map((x) => x.toMap()).toList(),
      'priority': priority,
      'bound': bound.toMap(),
      'distance': distance,
      'duration': duration,
    };
  }

  factory RouteSummary.fromMap(Map<String, dynamic> map) {
    return RouteSummary(
      RoutePosition.fromMap(map['origin'] as Map<String, dynamic>),
      RoutePosition.fromMap(map['destination'] as Map<String, dynamic>),
      List<RoutePosition>.from(
        (map['waypoints'] as List<int>).map<RoutePosition>(
          (x) => RoutePosition.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['priority'] as String,
      RouteBound.fromMap(map['bound'] as Map<String, dynamic>),
      map['distance'] as int,
      map['duration'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteSummary.fromJson(String source) =>
      RouteSummary.fromMap(json.decode(source) as Map<String, dynamic>);
}
