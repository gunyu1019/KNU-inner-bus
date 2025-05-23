import 'dart:convert';

class RouteBound {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  RouteBound(this.minX, this.minY, this.maxX, this.maxY);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'min_x': minX,
      'min_y': minY,
      'max_x': maxX,
      'max_y': maxY,
    };
  }

  factory RouteBound.fromMap(Map<String, dynamic> map) {
    return RouteBound(
      map['min_x'] as double,
      map['min_y'] as double,
      map['max_x'] as double,
      map['max_y'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteBound.fromJson(String source) => RouteBound.fromMap(json.decode(source) as Map<String, dynamic>);
}
