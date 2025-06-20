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
    this.descriptionFomrat = '{MM}분 후 도착 예정 {CURRENT_STATION}',
  });

  final int index;
  final DateTime dateTime;
  final bool simple;
  final bool isLast;
  final BusState busState;
  final String descriptionFomrat;

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
    child: const SizedBox.shrink(),
  );

  Widget smallRing(Color color) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    child: const SizedBox.shrink(),
  );

  Widget hightlightRing() => switch (busState) {
    BusState.closed => bigRing(ThemeColor.closedTextColor),
    BusState.current => bigRing(ThemeColor.hightlightTextColor),
    BusState.previous => smallRing(ThemeColor.secondaryTextColor),
    BusState.next => smallRing(ThemeColor.black),
  };

  EdgeInsets get padding => switch (busState) {
    BusState.closed => EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    BusState.current => EdgeInsets.all(18),
    BusState.previous => EdgeInsets.fromLTRB(20, 8, 16, 8),
    BusState.next => EdgeInsets.fromLTRB(20, 8, 16, 8),
  };

  Text countText() =>
      isLast
          ? Text('마지막 회차', style: KakaoMapTextStyle.finalCount)
          : Text(
            '${index + 1} 회차',
            style: switch (busState) {
              BusState.closed => null,
              BusState.current => KakaoMapTextStyle.nextCount,
              BusState.previous => KakaoMapTextStyle.nextCount,
              BusState.next => KakaoMapTextStyle.currentDescription,
            },
          );

  bool get isHightlight =>
      [BusState.closed, BusState.current].contains(busState);

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
          BusState.previous => KakaoMapTextStyle.previous,
          BusState.next => KakaoMapTextStyle.next,
        },
        textAlign: TextAlign.center,
      ),
      Expanded(child: const SizedBox.shrink()),
    ];

    if (busState != BusState.closed) {
      titleChild.add(countText());
    }
    final columnChild = <Widget>[
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: titleChild),
    ];

    if (isHightlight && !simple) {
      final timedelta = dateTime.difference(DateTime.now());
      final descriptionText = descriptionFomrat
          .replaceAll("{MM}", timedelta.inMinutes.toString())
          .replaceAll("{CURRENT_STATION}", currentStation ?? "알 수 없음")
          .replaceAll("{INDEX}", (index + 1).toString());
      columnChild.add(
        Padding(
          padding: const EdgeInsets.only(left: 34, top: 3),
          child: Text(
            descriptionText,
            style: KakaoMapTextStyle.currentDescription,
          ),
        ),
      );
    }

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChild,
    );
    final clip = isHightlight ? Clip.antiAlias : Clip.none;
    final decoration =
        isHightlight
            ? ShapeDecoration(
              color: Colors.white.withValues(alpha: 50),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            )
            : null;
    return Container(
      padding: padding,
      clipBehavior: clip,
      decoration: decoration,
      child: column,
    );
  }
}
