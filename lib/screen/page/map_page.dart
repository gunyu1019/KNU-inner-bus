
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/model/route_path.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late KakaoMapController? controller;
  late RoutePath? route;

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString("assets/config/station.json")
        .then((raw) => route = RoutePath.fromJson(raw));
  }

  Widget container(Size size) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: ThemeColor.grey, blurRadius: 4, offset: Offset(0, 4)),
      ],
    ),
    height: size.height,
    width: size.width,
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    /// PC, Tablet과 Mobile Device에서 화면 구성은 상이합니다.
    final ratio = media.size.width / media.size.height;
    final mapSize =
        ratio < 1
            ? Size(media.size.width, media.size.height - 300)
            : Size(media.size.width, media.size.height);
    final overlaySize =
        ratio < 1 ? Size(media.size.width, 300) : Size(500, 300);

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
        Positioned(left: 0, right: 0, bottom: 0, child: container(overlaySize)),
      ],
    );
  }

  Future<void> onMapReady(KakaoMapController controller) async {
    this.controller = controller;

    final routeStyle = RouteStyle(
      Colors.blue,
      12,
      strokeColor: Colors.white,
      strokeWidth: 4,
    );
    routeStyle.pattern = RoutePattern(
      await KImage.fromWidget(Text("dummy"), Size(10, 10)),
      10,
    );
    controller.routeLayer.addRoute(route!.getRoute, routeStyle);
  }
}
