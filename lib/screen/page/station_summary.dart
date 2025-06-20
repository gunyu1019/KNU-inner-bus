import 'package:flutter/material.dart';
import 'package:knu_inner_bus/model/route_path.dart';
import 'package:knu_inner_bus/screen/component/station_summary_item.dart';

class StationSummary extends StatefulWidget {
  const StationSummary({super.key, required this.size, required this.route});

  final Size size;
  final RoutePath route;

  @override
  State<StationSummary> createState() => StationSummaryPager();
}

class StationSummaryPager extends State<StationSummary> {
  late final ScrollController _scrollController;
  late final double pageSize;
  late int _currentPage;
  late double _currentOffset;

  int get currentPage => _currentPage;
  double get currentOffset => _currentOffset;

  Future<void> scrollToPage(int page) async {
    if (page < 0 || page >= widget.route.station.length) {
      return;
    }
    _currentPage = page + 1;
    _currentOffset = (page + 1) * pageSize;
    await _scrollController.animateTo(
      _currentOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void jumpToPage(int page) {
    if (page < 0 || page >= widget.route.station.length) {
      return;
    }
    _currentPage = page + 1;
    _currentOffset = (page + 1) * pageSize;
    _scrollController.jumpTo(_currentOffset);
  }

  @override
  void initState() {
    super.initState();
    pageSize = widget.size.width;
    _scrollController = ScrollController(initialScrollOffset: pageSize);
    _currentPage = 1;
    _currentOffset = pageSize;
  }

  void _directionTap() {
    final currentStation = widget.route.station[currentPage - 1];

    if (currentPage >= widget.route.station.length) {
      scrollToPage(1);
      return;
    }
    final otherStationIndex =
        widget.route.station.indexed
            .skip(currentPage)
            .where((e) => e.$2.id == currentStation.id)
            .firstOrNull
            ?.$1;
    if (otherStationIndex != null) {
      scrollToPage(otherStationIndex);
    } else {
      final anotherStationIndex =
          widget.route.station.indexed
              .where((e) => e.$2.id == currentStation.id)
              .first
              .$1;
      scrollToPage(anotherStationIndex);
    }
  }

  Widget buildItem(BuildContext context, int index) {
    final int realIndex =
        index == 0
            ? widget.route.station.length - 1
            : index == widget.route.station.length + 1
            ? 0
            : index - 1;

    final station = widget.route.station[realIndex];
    final nextStation = widget.route.station.elementAtOrNull(realIndex + 1)?.name;
    return SizedBox(
      width: pageSize,
      height: widget.size.height,
      child: StationSummaryItem(
        station: station,
        nextStation: nextStation,
        onDirectionTap: _directionTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (detail) {
        _currentOffset = _scrollController.offset - detail.delta.dx;
        if (_currentOffset < 0 ||
            _currentOffset > _scrollController.position.maxScrollExtent) {
          return;
        }
        _scrollController.jumpTo(_currentOffset);
      },
      onHorizontalDragEnd: (detail) {
        _currentPage = (_scrollController.offset / pageSize).round();
        if (_currentPage < 0 ||
            _currentPage >= widget.route.station.length + 2) {
          return;
        }

        _scrollController
            .animateTo(
              _currentPage * pageSize,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
            .then((_) {
              if (_currentPage == 0) {
                _scrollController.jumpTo(
                  pageSize * widget.route.station.length,
                );
              } else if (_currentPage == widget.route.station.length + 1) {
                _scrollController.jumpTo(pageSize);
              }
            });
      },
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: widget.route.station.length + 2,
        itemBuilder: buildItem,
      ),
    );
  }
}
