import 'package:flutter/material.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/constant/text_style.dart';
import 'package:knu_inner_bus/model/bus_state.dart';

class BusInfo extends StatelessWidget {
  const BusInfo({
    super.key,
    required this.index,
    required this.dateTime,
    required this.busState,
    this.simple = false,
    this.isLast = false,
    this.currentStation,
  });

  final int index;
  final DateTime dateTime;
  final bool simple;
  final bool isLast;
  final BusState busState;

  final String? currentStation;

  Widget bigRing(Color color) => Container(
    width: 24,
    height: 24,
    decoration: ShapeDecoration(
      color: Colors.black.withAlpha(0),
      shape: OvalBorder(
        side: BorderSide(
          width: 4,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: color,
        ),
      ),
    ),
  );

  Widget smallRing(Color color) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      shape: BoxShape.circle,
      color: color,
    ),
  );

  Widget hightlightRing() => switch (busState) {
    BusState.closed => bigRing(ThemeColor.closedTextColor),
    BusState.current => bigRing(ThemeColor.hightlightTextColor),
    BusState.previous => smallRing(ThemeColor.secondaryTextColor),
    BusState.next => smallRing(ThemeColor.black),
  };

  EdgeInsets get padding => switch (busState) {
    BusState.closed => EdgeInsets.all(18),
    BusState.current => EdgeInsets.all(18),
    BusState.previous => EdgeInsets.fromLTRB(20, 8, 16, 8),
    BusState.next => EdgeInsets.fromLTRB(20, 8, 16, 8),
  };

  Text countText() =>
      isLast
          ? Text('마지막 회차', style: KakaoMapTextStyle.finalCount)
          : Text(
            '$index 회차',
            style: switch (busState) {
              BusState.closed => null,
              BusState.current => KakaoMapTextStyle.nextCount,
              BusState.previous => KakaoMapTextStyle.nextCount,
              BusState.next => KakaoMapTextStyle.currentDescription,
            },
          );

  @override
  Widget build(BuildContext context) {
    final titleText =
        busState == BusState.closed
            ? '운행종료'
            : '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    final titleChild = <Widget>[
      hightlightRing(),
      const SizedBox(width: 8),
      Text(
        titleText,
        style: switch (busState) {
          BusState.closed => KakaoMapTextStyle.closedTitle,
          BusState.current => KakaoMapTextStyle.currentTitle,
          BusState.previous => KakaoMapTextStyle.previousTitle,
          BusState.next => KakaoMapTextStyle.next,
        },
      ),
    ];

    if (busState != BusState.closed) {
      titleChild.add(const SizedBox(width: double.infinity));
      titleChild.add(countText());
    }
    final columnChild = <Widget>[Row(children: titleChild)];

    if ([BusState.closed, BusState.current].contains(busState) && !simple) {
      final timedelta = DateTime.now().difference(dateTime);
      final descriptionText =
          busState == BusState.closed
              ? '운행 종료'
              : timedelta.inMinutes < 1
              ? '곧 도착 ($currentStation)'
              : '${timedelta.inMinutes}분 후 도착 예정 ($currentStation)';
      columnChild.add(
        Padding(
          padding: const EdgeInsets.only(left: 52, top: 10, bottom: 16),
          child: Text(
            descriptionText,
            style: KakaoMapTextStyle.currentDescription,
          ),
        ),
      );
    }

    final column = Column(children: columnChild);
    return Container(padding: padding, child: column);
  }
}
