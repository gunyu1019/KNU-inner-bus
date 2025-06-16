import 'package:flutter/material.dart';
import 'package:knu_inner_bus/constant/text_style.dart';
import 'package:knu_inner_bus/model/bus_state.dart';
import 'package:knu_inner_bus/model/station.dart';
import 'package:knu_inner_bus/screen/component/bus_info.dart';

class StationSummary extends StatelessWidget {
  const StationSummary({
    super.key,
    required this.station,
    this.nextStation,
    this.onDirectionTap,
  });

  final Station station;
  final String? nextStation;

  final void Function()? onDirectionTap;

  Widget titleText() => Text(station.name, style: KakaoMapTextStyle.title);

  Widget directionText() => GestureDetector(
    onTap: onDirectionTap,
    child: Text(
      nextStation == null ? "종점" : "$nextStation 방향",
      style: KakaoMapTextStyle.direction,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final title = Padding(
      padding: EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2.0,
        children: [titleText(), directionText()],
      ),
    );
    final now = DateTime.now();
    final currentInfo = station.nearTimetable(now);
    final children = <Widget>[title];

    if (currentInfo == null ||
        now.isBefore(DateTime(now.year, now.month, now.day, 5))) {
      // 운행이 종료된 경우 (출발 전 배차는 05:00 이후로 간주함.)
      station.time.entries
          .skip(station.time.length - 2)
          .map(
            (timetable) => BusInfo(
              busState: BusState.previous,
              dateTime: timetable.value,
              index: int.parse(timetable.key),
            ),
          )
          .forEach(children.add);
      children.add(
        BusInfo(index: -1, dateTime: now, busState: BusState.closed),
      );
    } else if (currentInfo.key == station.time.keys.first) {
      // 첫 차
    } else {
      // 그 외의 경우의 수
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.0,
        children: children,
      ),
    );
  }
}
