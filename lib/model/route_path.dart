import 'dart:convert';

import 'package:kakao_map_sdk/kakao_map_sdk.dart';

import 'package:knu_inner_bus/model/station.dart';

/// [Station] 객체를 나열한 선형을 나타내는 용도의 모델입니다.
class RoutePath {
  /// 정류장 정보를 담고 있습니다.
  final List<Station> station;

  RoutePath(this.station);

  /// 모든 경로를 불러옵니다.
  /// 기점부터 종점, 종점에서 기점까지 모든 경로를 불러옵니다.
  List<LatLng> get getRoute {
    final route = <LatLng>[];
    station
        .map((e) => e.route)
        .forEach(route.addAll);
    return route;
  }

  /// 단일 경로를 불러옵니다.
  /// 기점에서 종점까지 경로를 불러옵니다.
  List<LatLng> get getSingleRoute {
    final route = <LatLng>[];
    station.where((e) => e.direction).map((e) => e.route).forEach(route.addAll);
    return route;
  }

  /// 정류장 고유 ID로 정류장을 불러옵니다.
  List<Station> whereId(int id) => station.where((e) => e.id == id).toList();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'station': station.map((x) => x.toMap()).toList()};
  }

  factory RoutePath.fromMap(List<dynamic> payload) => RoutePath(
    List.from(payload)
        .map((e) => Map<String, dynamic>.from(e))
        .map<Station>(Station.fromMap)
        .toList(),
  );

  String toJson() => json.encode(toMap());

  factory RoutePath.fromJson(String source) =>
      RoutePath.fromMap(json.decode(source));
}
