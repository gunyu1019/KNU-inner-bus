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
  });

  final int index;
  final DateTime dateTime;
  final bool simple;
  final bool isLast;
  final BusState busState;

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

  double get paddingSize => switch(busState) {
    BusState.closed => 18,
    BusState.current => 18,
    BusState.previous => 8,
    BusState.next => 8,
  };

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(paddingSize);

    final columnChild = <Widget>[];

    if ([BusState.closed, BusState.current].contains(busState) && !simple) {
      columnChild.add(
        Text(
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
          style: KakaoMapTextStyle.currentDescription,
        ),
      );
    }

    final column = Column(children: columnChild);
    return Container(
      padding: padding,
      child: column
    );
  }
}
