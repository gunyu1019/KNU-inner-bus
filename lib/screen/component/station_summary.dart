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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(children: [titleText(), directionText()]),
    );
  }
}
