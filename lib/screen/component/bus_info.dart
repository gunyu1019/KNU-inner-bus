import 'package:flutter/material.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/model/bus_state.dart';

class BusInfo extends StatelessWidget {
  const BusInfo({
    super.key,
    required this.index,
    required this.dateTime,
    required this.busState,
    this.isLast = false,
  });

  final int index;
  final DateTime dateTime;
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

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
