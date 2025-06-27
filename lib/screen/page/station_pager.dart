import 'package:flutter/material.dart';
import 'package:knu_inner_bus/model/route_path.dart';
import 'package:knu_inner_bus/model/station.dart';
import 'package:knu_inner_bus/screen/component/station_summary_item.dart';

/// 정류장 요약 정보를 표시하는 페이지입니다.
/// [StationSummaryItem] 또는 [StationDetailItem]을 종합하여 노선에 있는 정류장 정보를 나타냅니다.
/// 이 페이지는 모바일을 위해 구성되었으며, 태블릿, PC 등의 환경에서 사용하지 않습니다.
class StationPager extends StatefulWidget {
  const StationPager({
    super.key,
    required this.size,
    required this.route,
    required this.onItemBuilder,
  });

  /// 하나의 페이지를 구성하는 크기입니다.
  /// 가로 길이는 디바이스 너비를 기준으로 하며,
  /// 세로 길이는 300px로 고정하는 것을 권장합니다.
  final Size size;

  /// 노선에 있는 정류장 정보를 담고 있는 객체입니다.
  final RoutePath route;

  @override
  State<StationPager> createState() => StationPagerState();

  final Widget Function(int, Station) onItemBuilder;
}

class StationPagerState extends State<StationPager> {
  late final ScrollController _scrollController;

  /// 페이지 크기입니다.
  late final double pageSize;
  late int _currentPage;
  late double _currentOffset;

  /// 현재 페이지를 나타내는 변수입니다.
  int get currentPage => _currentPage;

  /// 현재 페이지의 오프셋을 나타내는 변수입니다.
  double get currentOffset => _currentOffset;

  /// [page] 매개변수에 따라 애니메이션을 적용한 상태로 스크롤합니다.
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

  /// [page] 매개변수에 따라 애니메이션 없이 이동합니다.
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

  /// 방향을 눌렀을 때 호출되는 함수입니다.
  /// 현재 페이지의 정류장 정보를 기준으로 다른 방향에 있는 정류장으로 이동합니다.
  void directionTap() {
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

  /// ListView의 아이템을 생성하는 함수입니다.
  /// [StationPager]에 구성된 ListView는 무한히 스크롤 할 수 있도록 구성합니다.
  /// 따라서 첫 번째 아이템은 마지막 정류장 정보를, 마지막 아이템은 첫 번째 정류장 정보를 표시합니다.
  Widget buildItem(BuildContext context, int index) {
    final int realIndex =
        index == 0
            ? widget.route.station.length - 1
            : index == widget.route.station.length + 1
            ? 0
            : index - 1;

    final station = widget.route.station[realIndex];
    return SizedBox(
      width: pageSize,
      height: widget.size.height,
      child: widget.onItemBuilder(realIndex, station),
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
