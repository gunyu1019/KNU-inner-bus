import 'dart:convert';
import 'package:flutter/material.dart';
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
    station.map((e) => e.route).forEach(route.addAll);
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

  /// 버스 노선의 회차별 운영시간을 불러옵니다.
  List<(String, DateTimeRange)> operatingTimes() {
    final startTime = station.first.time;
    final operatingTimes = <(String, DateTimeRange)>[];
    startTime.entries
        .map((element) {
          final start = element.value;
          final end =
              station.reversed
                  .firstWhere((e) => e.time[element.key] != null)
                  .time[element.key]!;
          return (element.key, DateTimeRange(start: start, end: end));
        })
        .forEach(operatingTimes.add);
    return operatingTimes;
  }

  /// 현재 시간 기준으로 버스의 위치를 추적합니다.
  Station? currentBusStation(DateTime time) {
    final nearestTimetable = <String?>[];
    for (final station in this.station) {
      final entries = station.time.entries.where(
        (element) => element.value.compareTo(time) > 0,
      );
      if (entries.isEmpty) {
        // 현재 시간보다 이전에 정차하는 회차는 제외합니다.
        nearestTimetable.add(null);
        continue;
      }
      // 가장 가까운 시간표를 찾습니다.
      final nearest = entries.reduce(
        (a, b) => a.value.compareTo(b.value) <= 0 ? a : b,
      );
      nearestTimetable.add(nearest.key);
    }
    for (final (index, timetable)
        in nearestTimetable.take(nearestTimetable.length - 1).indexed) {
      if (timetable != nearestTimetable.elementAt(index + 1)) {
        return station[index];
      }
    }

    final operatingTime = operatingTimes();
    if (operatingTime.first.$2.start.compareTo(time) <= 0 &&
        operatingTime.last.$2.end.compareTo(time) >= 0) {
      return station.last; // 마지막 정류장에 도달했을 때
    }
    return null; // 마지막 정류장에 도달했을 때
  }

  /// 입력된 [time]에 따라 버스의 위치를 추적합니다.
  LatLng? tracingBusPosition(DateTime time) {
    final currentStation = currentBusStation(time);
    if (currentStation == null) {
      return null; // 버스가 운행 중이 아닐 때
    }
    final nextStation =
        station.skip(station.indexOf(currentStation) + 1).firstOrNull;
    if (nextStation == null) {
      return currentStation.position; // 마지막 정류장에 도달했을 때
    }

    final index = nextStation.nearTimetable(time);
    if (index == null || currentStation.time[index.key] == null) {
      return null; // 계산 오류
    }
    final current = time.difference(currentStation.time[index.key]!);
    final duration = index.value.difference(currentStation.time[index.key]!);
    final ratio = current.inMilliseconds / duration.inMilliseconds;
    return nextStation.currentPoint(ratio.clamp(0.0, 1.0));
  }

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
