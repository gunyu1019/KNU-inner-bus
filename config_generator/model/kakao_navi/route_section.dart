import 'dart:convert';

import 'route_bound.dart';
import 'route_road.dart';

class RouteSection {
  final int distance;
  final int duration;
  final RouteBound? bound;
  final List<RouteRoad>? roads;
  // final Object? guides

  RouteSection(this.distance, this.duration, this.bound, this.roads);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'distance': distance,
      'duration': duration,
      'bound': bound?.toMap(),
      'roads': roads?.map((x) => x.toMap()).toList(),
    };
  }

  factory RouteSection.fromMap(Map<String, dynamic> map) {
    return RouteSection(
      map['distance'] as int,
      map['duration'] as int,
      map['bound'] != null
          ? RouteBound.fromMap(map['bound'] as Map<String, dynamic>)
          : null,
      map['roads'] != null
          ? List<RouteRoad>.from(
            (map['roads'] as List<int>).map<RouteRoad?>(
              (x) => RouteRoad.fromMap(x as Map<String, dynamic>),
            ),
          )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteSection.fromJson(String source) =>
      RouteSection.fromMap(json.decode(source) as Map<String, dynamic>);
}
