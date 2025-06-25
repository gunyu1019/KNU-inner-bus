import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/constant/text_style.dart';
import 'package:knu_inner_bus/model/station.dart';

class StationDetailTitle extends StatelessWidget {
  const StationDetailTitle({
    super.key,
    required this.station,
    required this.previousName,
    required this.nextName,
    this.onPreviousClick,
    this.onCurrentClick,
    this.onNextClick,
  });

  final Station station;
  final String previousName;
  final String nextName;

  final void Function()? onPreviousClick;
  final void Function()? onCurrentClick;
  final void Function()? onNextClick;

  Widget currentPoint(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * currentWidthRatio;
    final padding = EdgeInsets.symmetric(vertical: 16);

    Widget child = Text(station.name, style: KakaoMapTextStyle.currentTitle);
    if (onCurrentClick != null) {
      child = InkWell(onTap: onCurrentClick, child: child);
    }

    return Container(
      width: width,
      padding: padding,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: [
          BoxShadow(
            color: ThemeColor.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget otherPoint(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * (1 - currentWidthRatio) / 2;
    return Text("123");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      ],
    );
  }

  static const double currentWidthRatio = .45;
}
