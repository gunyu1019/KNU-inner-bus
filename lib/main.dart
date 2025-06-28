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

AnimatedWidget _slideTransition(_, animation, __, child) => SlideTransition(
  position: animation.drive(
    Tween<Offset>(
      begin: Offset(0.0, 1.25),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut)),
  ),
  child: child,
);

final route = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, widget) => Scaffold(body: widget),
      routes: [
        GoRoute(path: "/", builder: (_, _) => MapPage()),
        GoRoute(
          path: "/detail",
          pageBuilder:
              (_, _) => CustomTransitionPage(
                child: StationDetailPage(),
                transitionsBuilder: _slideTransition,
              ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: route);
  }
}
