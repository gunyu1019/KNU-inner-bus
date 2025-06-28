import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:knu_inner_bus/screen/page/map_page.dart';
import 'package:knu_inner_bus/screen/page/station_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KakaoMapSdk.instance.initialize("");
  runApp(const MyApp());
}

final route = GoRouter(routes: [
  ShellRoute(
    builder: (context, state, widget) => Scaffold(body: widget),
    routes: [
      GoRoute(path: "/", builder: (_, _) => MapPage()),
      GoRoute(path: "/detail", builder: (_, _) => StationDetailPage()),
    ]
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: route
    );
  }
}
