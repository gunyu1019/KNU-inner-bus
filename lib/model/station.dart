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

  /// 前정류장부터 現정류장의 직선 거리입니다.
  late final double distance;

  /// 前정류장부터 現정류장의 실제 거리입니다.
  late final double actualDistance;

  /// 前정류장부터 現정류장까지 실제 거리를 배열에 담습니다.
  /// 한 노드를 이동하는 데, 소요되는 거리를 담는 비공개 필드입니다.
  late final List<double> _actualRouteDistance;

  Station(this.name, this.position, this.route, this.time) {
    // 반드시 경로의 마지막은 現정류장의 좌표를 나타내고 있어야 합니다.
    assert(position == route.last);

    distance = route.first.distance(position);
    _actualRouteDistance =
        route
            .sublist(1)
            .asMap()
            .entries
            .map((element) => element.value.distance(route[element.key - 1]))
            .toList();
    actualDistance = _actualRouteDistance.reduce(
      (element1, element2) => element1 + element2,
    );
  }
}
