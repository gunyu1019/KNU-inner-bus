import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/model/route_path.dart';
import 'package:knu_inner_bus/screen/component/station_summary_item.dart';
import 'package:knu_inner_bus/screen/component/station_detail_item.dart';
import 'package:knu_inner_bus/screen/component/station_pager.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late KakaoMapController? controller;
  RoutePath? route;

  final GlobalKey<StationPagerState> summaryPagerKey =
      GlobalKey<StationPagerState>();

  Offset _dragStartOffset = Offset.zero;
  String _currentStationName = "";
  late Poi _busPoi;
  Timer? _updateTimer;

  @override
  void dispose() {
    super.dispose();
    _updateTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    /// PC, Tablet과 Mobile Device에서 화면 구성은 상이합니다.
    final ratio = media.size.width / media.size.height;
    final isMobile = ratio < 1.0;
    final mapSize =
        isMobile
            ? Size(media.size.width, media.size.height - 300)
            : Size(media.size.width - 500, media.size.height);
    final overlaySize =
        isMobile ? Size(media.size.width, 300) : Size(500, media.size.height);
    final overlayPositioned =
        isMobile
            ? (Widget child) =>
                Positioned(left: 0, right: 0, bottom: 0, child: child)
            : (Widget child) => Positioned(right: 0, top: 0, child: child);

    late Widget containerChild;
    if (route == null) {
      containerChild = const SizedBox.shrink();
    } else {
      containerChild = StationPager(
        key: summaryPagerKey,
        size: overlaySize,
        route: route!,
        onItemBuilder: (index, station) {
          final nextStation = route!.station.elementAtOrNull(index + 1)?.name;
          final previousStation =
              index > 0 ? route!.station.elementAtOrNull(index - 1)?.name : null;
          if (isMobile) {
            return StationSummaryItem(
              station: station,
              nextStation: nextStation,
              currentStation: _currentStationName,
              onDirectionTap: summaryPagerKey.currentState?.directionTap,
            );
          }
          return StationDetailItem(
            station: station,
            size: overlaySize,
            simple: false,
            nextName: nextStation,
            previousName: previousStation,
            currentStation: _currentStationName,
            onPreviousClick: () {
              summaryPagerKey.currentState?.scrollToPage(index - 1);
            },
            onNextClick: () {
              summaryPagerKey.currentState?.scrollToPage(index + 1);
            },
          );
        },
        onVerticalDragStart: (details) {
          _dragStartOffset = details.localPosition;
        },
        onVerticalDragEnd: (details) {
          final relativeOffset = (_dragStartOffset - details.localPosition);
          if (relativeOffset.dx.abs() > relativeOffset.dy.abs()) {
            // 수직으로 드래그가 이루어진 경우 무시합니다.
            return;
          }

          if (relativeOffset.dy > 100) {
            context.push("/detail");
            return;
          }
        }
      );
    }

    final containerShadow = [
      BoxShadow(color: ThemeColor.grey, blurRadius: 4, offset: Offset(0, 4)),
    ];
    final containerDecoration = BoxDecoration(
      color: Colors.white,
      boxShadow: containerShadow,
    );

    final container = Container(
      decoration: containerDecoration,
      height: overlaySize.height,
      width: overlaySize.width,
      child: containerChild,
    );

    final option = KakaoMapOption(
      position: LatLng(37.868471010792305, 127.74478109028253),
    );
    return Stack(
      children: [
        SizedBox(
          height: mapSize.height,
          width: mapSize.width,
          child: KakaoMap(option: option, onMapReady: onMapReady),
        ),
        overlayPositioned(container),
      ],
    );
  }

  Future<void> onMapReady(KakaoMapController controller) async {
    this.controller = controller;

    final rawData = await rootBundle.loadString("assets/config/station.json");
    setState(() {
      this.route = RoutePath.fromJson(rawData);
    });
    if (this.route == null) return;
    final route = this.route!;

    final routeColor = Color.from(alpha: 1.0, red: 0, green: .78, blue: .31);

    // 선형에 맞게 경로를 생성합니다.
    final routeStyle = RouteStyle(
      routeColor,
      12,
      strokeColor: Colors.white,
      strokeWidth: 4,
    );
    final patternSize = Size(30.0, 30.0);
    final patternIcon = await KImage.fromWidget(
      FaIcon(FontAwesomeIcons.caretUp, color: Colors.white),
      patternSize,
    );
    routeStyle.pattern = RoutePattern(patternIcon, 10);
    await controller.routeLayer.addRoute(route.getRoute, routeStyle);

    // 교내 버스 정류장 아이콘을 추가합니다.
    final icon = await rootBundle.load("assets/image/station.png");
    final poiStyle1 = PoiStyle(
      icon: KImage.fromData(icon.buffer.asUint8List(), 22, 22),
      anchor: KPoint(.5, .5),
    );
    final poiStyle2 = PoiStyle(
      icon: KImage.fromData(icon.buffer.asUint8List(), 22, 22),
      anchor: KPoint(.5, .5),
    )..addStyle(zoomLevel: 14, icon: null);
    for (final station in route.station.indexed) {
      await controller.labelLayer.addPoi(
        station.$2.position,
        style: station.$2.direction ? poiStyle1 : poiStyle2,
        onClick: () {
          summaryPagerKey.currentState?.scrollToPage(station.$1);
        },
      );
    }

    final now = DateTime.now();

    _currentStationName = route.currentBusStation(now)?.name ?? "확인 불가";
    final busPoiStyle = PoiStyle(
      icon: KImage.fromAsset("assets/image/bus.png", 30, 36),
      anchor: KPoint(.5, .5),
    );
    final busPosition = route.tracingBusPosition(now);
    if (busPosition != null) {
      _busPoi = await controller.labelLayer.addPoi(
        busPosition,
        style: busPoiStyle,
      );
    }

    _updateTimer = Timer.periodic(const Duration(seconds: 30), updateBusLocation);

    /* await controller.moveCamera(CameraUpdate.fitMapPoints([
      LatLng(37.87369656276904, 127.74234032102943),
      LatLng(37.86069708242608, 127.74420063715208),
    ], padding: 10)); */
  }

  void updateBusLocation(Timer timer) {
    final now = DateTime.now();
    final busPosition = route?.tracingBusPosition(now);
    if (busPosition != null) {
      _busPoi.move(busPosition);
    }
    setState(() {
      _currentStationName =
          route?.currentBusStation(now)?.name ?? "확인 불가";
    });
  }
}
