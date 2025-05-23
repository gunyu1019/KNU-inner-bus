import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'model/generator_latlng.dart';
import 'model/generator_output.dart';
import 'model/generator_station.dart';

Future<void> main() async {
  final inputAssetPath = "input/";
  final outputAssetPath = "output/";

  log("Loading Assets...");
  final rawStation = await File("$inputAssetPath/station.json").readAsString();
  final rawTimetable = await File("$inputAssetPath/timetable.csv").readAsString();

  final stations = List.from(
    (json.decode(rawStation) as List<dynamic>),
  ).map((e) => e as Map<String, dynamic>).map(GeneratorStation.fromMap);
  final timetable =
      rawTimetable
          .split("\n")
          .sublist(1)  // 첫 번째 행은 무시합니다.
          .map((e) => e.split(",").sublist(1).map((element) {  // 첫 번째 열은 무시합니다.
            final timeElement = element.split(":").map(int.parse).toList();
            return timeElement[0] * 60 + timeElement[1];
          }).toList())
          .toList();
  
  final result = <GeneratorOutput>[];
  for (final (index, station) in stations.indexed) {
    final elementTimetable = timetable.map((e) => e[index]).toList().asMap().map((k1, k2) => MapEntry(k1.toString(), k2));
    final route = <GeneratorLatLng>[station.position];
    final resultElement = GeneratorOutput(station.id, station.name, station.position, station.direction, route, elementTimetable);
    result.add(resultElement);
  }
  
  final rawResult = result.map((e) => e.toMap()).toList();
  await File("$outputAssetPath/station.json").writeAsString(
    json.encode(rawResult)
  );
}
