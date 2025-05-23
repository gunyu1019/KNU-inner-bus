import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'model/generator_latlng.dart';
import 'model/generator_output.dart';
import 'model/generator_station.dart';
import 'model/kakao_navi/route_result.dart';

Future<void> main() async {
  final apiKey = "";
  final inputAssetPath = "input/";
  final outputAssetPath = "output/";

  log("Loading Assets", level: 800);
  final rawStation = await File("$inputAssetPath/station.json").readAsString();
  final rawTimetable =
      await File("$inputAssetPath/timetable.csv").readAsString();
  final rawWaypoint =
      await File("$inputAssetPath/waypoint.json").readAsString();

  log("Parsing Model from raw data.", level: 800);
  final stations = List.from(
    (json.decode(rawStation) as List<dynamic>),
  ).map((e) => e as Map<String, dynamic>).map(GeneratorStation.fromMap);
  final timetable =
      rawTimetable
          .split("\n")
          .sublist(1) // 첫 번째 행은 무시합니다.
          .map(
            (e) =>
                e.split(",").sublist(1).map((element) {
                  // 첫 번째 열은 무시합니다.
                  final timeElement =
                      element.split(":").map(int.parse).toList();
                  return timeElement[0] * 60 + timeElement[1];
                }).toList(),
          )
          .toList();
  final waypoint = Map<String, dynamic>.from(json.decode(rawWaypoint)).map(
    (k, v) => MapEntry(
      k,
      List.from(v)
          .map((e) => Map<String, dynamic>.from(e))
          .map(GeneratorLatLng.fromMap)
          .toList(),
    ),
  );

  final result = <GeneratorOutput>[];
  for (final (index, station) in stations.indexed) {
    final elementTimetable = timetable
        .map((e) => e[index])
        .toList()
        .asMap()
        .map((k1, k2) => MapEntry(k1.toString(), k2));

    final route = <GeneratorLatLng>[];
    if (index > 0) {
      final prevStation = stations.elementAt(index - 1);
      final queries = <String, dynamic>{
        "origin":
            "${prevStation.position.longitude},${prevStation.position.latitude}",
        "destination":
            "${station.position.longitude},${station.position.latitude}",
        "waypoints":
            (waypoint.containsKey(index.toString())
                ? waypoint[index.toString()]
                    ?.map(
                      (position) =>
                          "${position.longitude},${position.latitude}",
                    )
                    .join("%7C")
                : ""),
        "priority": "RECOMMEND",
        "roadevent": "2",
        "alternatives": "false",
        "road_details": "true",
        "car_type": "3",
        "car_fuel": "GASOLINE",
        "car_hipass": "false",
        "summary": "false",
      };
      final url = Uri.https(
        "apis-navi.kakaomobility.com",
        "/v1/directions",
        queries,
      );
      final response = await http.get(
        url,
        headers: {
          "Authorization": "KakaoAK $apiKey",
          "Content-Type": "application/json",
        },
      );
      
      if (response.statusCode == 200) {
        final routeResult = RouteResult.fromJson(response.body);
        for (var section in routeResult.routes[0].sections) {
          section.roads!.map((e) => e.vertexesToLatLng()).forEach(route.addAll);
        }
      }
    }
    route.add(station.position);

    final resultElement = GeneratorOutput(
      station.id,
      station.name,
      station.position,
      station.direction,
      route,
      elementTimetable,
    );
    result.add(resultElement);
  }

  final rawResult = result.map((e) => e.toMap()).toList();
  await File(
    "$outputAssetPath/station.json",
  ).writeAsString(json.encode(rawResult));
}
