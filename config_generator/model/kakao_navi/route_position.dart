import 'dart:convert';

class RoutePosition {
  final String name;
  final double x;
  final double y;

  RoutePosition(this.name, this.x, this.y);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'x': x,
      'y': y,
    };
  }

  factory RoutePosition.fromMap(Map<String, dynamic> map) {
    return RoutePosition(
      map['name'] as String,
      map['x'] as double,
      map['y'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoutePosition.fromJson(String source) => RoutePosition.fromMap(json.decode(source) as Map<String, dynamic>);
}
