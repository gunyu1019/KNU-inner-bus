import 'dart:convert';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

/// 정차하는 정류장의 정보를 담고 있는 개체입니다.
class Station {
  /// 정류장 이름입니다.
  final String name;

  /// 정류장의 좌표입니다.
  final LatLng position;

  /// 前정류장부터 現정류장까지의 경로를 WGS84로 나타냅니다.
  final List<LatLng> route;

  /// 정류장의 시간표입니다.
  /// 키: 정류장에 정차하는 회차 (ex. 9회차에 정차하지 않으면 작성하지 않습니다.)
  /// 값: 정류장에 정차하는 시간
  final Map<int, DateTime> time;

  /// 상행, 하행을 구분합니다.
  final bool direction;

  /// 前정류장부터 現정류장의 직선 거리입니다.
  late final double distance;

  /// 前정류장부터 現정류장의 실제 거리입니다.
  late final double actualDistance;

  /// 前정류장부터 現정류장까지 실제 거리를 배열에 담습니다.
  /// 한 노드를 이동하는 데, 소요되는 거리를 담는 비공개 필드입니다.
  late final List<double> _actualRouteDistance;

  Station(this.name, this.position, this.direction, this.route, this.time) {
    // 반드시 경로의 마지막은 現정류장의 좌표를 나타내고 있어야 합니다.
    assert(position == route.last);

    distance = route.first.distance(position);
    _actualRouteDistance =
        route
            .sublist(0, route.length - 1)
            .asMap()
            .entries
            .map((element) => element.value.distance(route[element.key + 1]))
            .toList();
    actualDistance = _actualRouteDistance.reduce(
      (element1, element2) => element1 + element2,
    );
  }

  @override
  String toString() {
    return 'Station(name: $name, position: $position, direction: $direction, actualDistance: $actualDistance, distance: $distance)';
  }

  @override
  bool operator ==(covariant Station other) {
    if (identical(this, other)) return true;

    return other.name == name && other.position == position && other.direction == direction;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        position.hashCode ^
        direction.hashCode ^
        distance.hashCode ^
        actualDistance.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'position': position.toMessageable(),
      'direction': direction,
      'route': route.map((x) => x.toMessageable()).toList(),
      'time': time.map((k, v) => MapEntry(k, v.hour * 60 + v.minute)),
    };
  }

  factory Station.fromMap(Map<String, dynamic> payload) => Station(
    payload['name'] as String,
    LatLng.fromMessageable(payload['position']),
    payload['direction'],
    payload['route'].map<LatLng>((x) => LatLng.fromMessageable(x)),
    (payload['time'] as Map<int, dynamic>).map(
      (key, value) => MapEntry(
        key,
        DateTime.now().copyWith(
          hour: value / 60,
          minute: value % 60,
          second: 0,
          microsecond: 0,
          millisecond: 0,
        ),
      ),
    ),
  );

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) =>
      Station.fromMap(json.decode(source) as Map<String, dynamic>);
}
