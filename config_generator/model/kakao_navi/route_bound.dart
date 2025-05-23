import 'dart:convert';

class RouteBound {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  RouteBound(this.minX, this.minY, this.maxX, this.maxY);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'minX': minX,
      'minY': minY,
      'maxX': maxX,
      'maxY': maxY,
    };
  }

  factory RouteBound.fromMap(Map<String, dynamic> map) {
    return RouteBound(
      map['minX'] as double,
      map['minY'] as double,
      map['maxX'] as double,
      map['maxY'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteBound.fromJson(String source) => RouteBound.fromMap(json.decode(source) as Map<String, dynamic>);
}
