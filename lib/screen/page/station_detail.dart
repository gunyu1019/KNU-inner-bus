import 'package:flutter/material.dart';
import 'package:knu_inner_bus/model/station.dart';
import 'package:knu_inner_bus/screen/component/station_detail_title.dart';

class StationDetail extends StatelessWidget {
  const StationDetail({
    super.key,
    required this.size,
    required this.station,
    this.previousName,
    this.nextName,
  });

  /// 하나의 페이지를 구성하는 크기입니다.
  final Size size;

  final Station station;

  final String? previousName;
  final String? nextName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StationDetailTitle(
            station: station,
            previousName: previousName,
            nextName: nextName,
            size: size,
          ),
        ],
      ),
    );
  }
}
