// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'generator_latlng.dart';

class GeneratorStation {
  final int id;
  final String name;
  final GeneratorLatLng position; 
  final bool direction;

  GeneratorStation(this.id, this.name, this.position, this.direction);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'position': position.toMap(),
      'direction': direction,
    };
  }

  factory GeneratorStation.fromMap(Map<String, dynamic> map) {
    return GeneratorStation(
      map['id'] as int,
      map['name'] as String,
      GeneratorLatLng.fromMap(map['position'] as Map<String,dynamic>),
      map['direction'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneratorStation.fromJson(String source) => GeneratorStation.fromMap(json.decode(source) as Map<String, dynamic>);
}
