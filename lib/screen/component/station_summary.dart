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
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 1.0,
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
      children.add(
        BusInfo(
          busState: BusState.current,
          dateTime: currentInfo.value,
          index: int.parse(currentInfo.key),
          currentStation: station.name,
        ),
      );
      station.time.entries
          .skip(1)
          .take(2)
          .map(
            (timetable) => BusInfo(
              busState: BusState.next,
              dateTime: timetable.value,
              index: int.parse(timetable.key),
            ),
          )
          .forEach(children.add);
    } else {
      final previousInfo =
          station.time.entries
              .takeWhile((timetable) => timetable.key != currentInfo.key)
              .last;
      final nextInfo =
          station.time.entries
              .skipWhile((timetable) => timetable.key != currentInfo.key)
              .skip(1)
              .first;

      children.addAll([
        BusInfo(
          busState: BusState.previous,
          dateTime: previousInfo.value,
          index: int.parse(previousInfo.key),
        ),
        BusInfo(
          busState: BusState.current,
          dateTime: currentInfo.value,
          index: int.parse(currentInfo.key),
          currentStation: station.name,
        ),
        BusInfo(
          busState: BusState.next,
          dateTime: nextInfo.value,
          index: int.parse(nextInfo.key),
        ),
      ]);
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
