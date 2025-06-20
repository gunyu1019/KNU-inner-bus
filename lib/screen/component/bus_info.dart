import 'package:flutter/material.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/constant/text_style.dart';
import 'package:knu_inner_bus/model/bus_state.dart';

/// 버스 시간표를 구현하는 위젯입니다.
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

  /// 버스의 운행 회차를 의미합니다.
  final int index;

  /// 버스의 출발ㆍ도착 시간 입니다.
  final DateTime dateTime;

  /// 설명글(Descriotion)을 제외할 지 여부입니다.
  /// 
  /// 설명글은 현재 시간과 비교하여 남은 시간을 표시하며, [StationSummary]에서 사용됩니다.
  /// 예시: "5분 후 도착 예정 중앙도서관"
  final bool simple;

  /// 마지막 회차인지 여부입니다.
  final bool isLast;

  /// 버스의 현재 상태입니다.
  /// - [BusState.closed]: 운행 종료
  /// - [BusState.current]: 이번 배차에 도착할 버스
  /// - [BusState.previous]: 이미 지나간 회차
  /// - [BusState.next]: 다음 배차에 도착할 버스
  final BusState busState;

  /// 설명글의 포맷입니다.
  /// 기본값은 '{MM}분 후 도착 예정 {CURRENT_STATION}' 입니다.
  final String descriptionFomrat;

  /// 현재 버스가 위치한 정류장 이름입니다.
  final String? currentStation;

  /// 위젯을 구성요소 중 하나입니다.
  /// [BusState.closed], [BusState.current] 에서 사용됩니다.
  /// [color] 매개변수로 테두리의 색상을 지정할 수 있습니다.
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

  /// 위젯을 구성요소 중 하나입니다.
  /// [BusState.previous], [BusState.next] 에서 사용됩니다.
  /// [color] 매개변수로 원형의 색상을 지정할 수 있습니다.
  Widget smallRing(Color color) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    child: const SizedBox.shrink(),
  );

  /// 현재 버스의 상태에 따라 원형을 불러옵니다.
  Widget hightlightRing() => switch (busState) {
    BusState.closed => bigRing(ThemeColor.closedTextColor),
    BusState.current => bigRing(ThemeColor.hightlightTextColor),
    BusState.previous => smallRing(ThemeColor.secondaryTextColor),
    BusState.next => smallRing(ThemeColor.black),
  };

  /// 버스 상태에 따른 위젯의 패딩을 반환합니다.
  EdgeInsets get padding => switch (busState) {
    BusState.closed => EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    BusState.current => EdgeInsets.all(18),
    BusState.previous => EdgeInsets.fromLTRB(20, 8, 16, 8),
    BusState.next => EdgeInsets.fromLTRB(20, 8, 16, 8),
  };

  /// 버스의 회차를 표시하는 텍스트 위젯입니다.
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

  /// 현재 버스의 상태에 따라 강조 표시 여부를 반환합니다.
  /// [BusState.closed] 또는 [BusState.current] 상태일 때 강조 표시됩니다.
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
