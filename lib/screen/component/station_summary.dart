import 'package:flutter/material.dart';
import 'package:knu_inner_bus/constant/text_style.dart';
import 'package:knu_inner_bus/model/station.dart';

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

  Widget titleText() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(station.name, style: KakaoMapTextStyle.title),
  );

  Widget directionText() => Padding(
    padding: const EdgeInsets.all(4),
    child: GestureDetector(
      onTap: onDirectionTap,
      child: Text(
        nextStation == null ? "종점" : "$nextStation 방향",
        style: KakaoMapTextStyle.title,
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        titleText(),
        directionText()
      ],
    );
    final now = DateTime.now();
    final currentInfo = station.nearTimetable(now);
    final children = <Widget>[title];

    if (currentInfo != null || now.isBefore(DateTime(now.year, now.month, now.day, 5))) {
      // 운행이 종료된 경우 (출발 전 배차는 05:00 이후로 간주함.)
    } else if (currentInfo?.key == station.time.keys.first) {
      // 첫 차
    } else {
      // 그 외의 경우의 수
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 10,
        children: children
      )
    );
  }
}
