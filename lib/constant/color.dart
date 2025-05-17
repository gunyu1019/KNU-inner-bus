import 'dart:ui';

import 'package:knu_inner_bus/constant/text_style.dart';

/* Kakao Map Page */
class KakaoMapTextStyle {
  static final title = TextStyle(
    color: ThemeColor.primaryTextColor,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );
  static final previousTitle = TextStyle(
    color: ThemeColor.secondaryTextColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  static final currentTitle = TextStyle(
    color: ThemeColor.hightlightTextColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );
  static final currentDescription = TextStyle(
    color: ThemeColor.primaryTextColor,
    fontSize: 14,
    decoration: TextDecoration.none,
  );

  static final previous = TextStyle(
    color: ThemeColor.secondaryTextColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );
  static final previousCount = TextStyle(
    color: ThemeColor.secondaryTextColor,
    fontSize: 14,
    decoration: TextDecoration.none,
  );
  static final next = TextStyle(
    color: ThemeColor.primaryTextColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );
  static final nextCount = TextStyle(
    color: ThemeColor.primaryTextColor,
    fontSize: 14,
    decoration: TextDecoration.none,
  );
  static final finalCount = TextStyle(
    color: ThemeColor.finalTextColor,
    fontSize: 14,
    decoration: TextDecoration.none,
  );
}