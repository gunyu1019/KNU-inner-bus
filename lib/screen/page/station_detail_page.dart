import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knu_inner_bus/constant/color.dart';
import 'package:knu_inner_bus/model/route_path.dart';
import 'package:knu_inner_bus/screen/component/station_detail_item.dart';
import 'package:knu_inner_bus/screen/component/station_pager.dart';

class StationDetailPage extends StatefulWidget {
  const StationDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  final GlobalKey<StationPagerState> detailPagerKey =
      GlobalKey<StationPagerState>();
  RoutePath? route;

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString("assets/config/station.json")
        .then(
          (rawData) => setState(() {
            route = RoutePath.fromJson(rawData);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final child =
        route == null
            ? const SizedBox.shrink()
            : StationPager(
              key: detailPagerKey,
              size: media.size,
              route: route!,
              onItemBuilder: (index, station) {
                final nextStation =
                    route!.station.elementAtOrNull(index + 1)?.name;
                final previousStation =
                    index > 0
                        ? route!.station.elementAtOrNull(index - 1)?.name
                        : null;
                return StationDetailItem(
                  station: station,
                  size: media.size,
                  nextName: nextStation,
                  previousName: previousStation,
                  onPreviousClick: () {
                    detailPagerKey.currentState?.scrollToPage(index - 1);
                  },
                  onNextClick: () {
                    detailPagerKey.currentState?.scrollToPage(index + 1);
                  },
                );
              },
            );

    return Container(color: ThemeColor.primaryBackgroundColor, child: child);
  }
}
