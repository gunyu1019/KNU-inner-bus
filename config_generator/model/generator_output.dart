// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'generator_latlng.dart';
import 'generator_station.dart';

class GeneratorOutput extends GeneratorStation {
  final List<GeneratorLatLng> route;
  final Map<String, int> time;

  GeneratorOutput(super.id, super.name, super.position, super.direction, this.route, this.time);

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{
      'route': route.map((x) => x.toMap()).toList(),
      'time': time,
    };
    result.addAll(super.toMap());
    return result;
  }

  factory GeneratorOutput.fromMap(Map<String, dynamic> map) {
    final origin = GeneratorStation.fromMap(map);
    return GeneratorOutput(
      origin.id, origin.name, origin.position, origin.direction,
      List<GeneratorLatLng>.from((map['route'] as List<int>).map<GeneratorLatLng>((x) => GeneratorLatLng.fromMap(x as Map<String,dynamic>),),),
      Map<String, int>.from(map['time'] as Map<String, int>),
    );
  }

  factory GeneratorOutput.fromJson(String source) => GeneratorOutput.fromMap(json.decode(source) as Map<String, dynamic>);
}
