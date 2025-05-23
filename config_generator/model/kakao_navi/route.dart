import 'dart:convert';

import 'route_section.dart';
import 'route_summary.dart';

class Route {
  final int resultCode;
  final String resultMessage;
  final RouteSummary summary;
  final List<RouteSection> sections;

  Route(this.resultCode, this.resultMessage, this.summary, this.sections);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result_code': resultCode,
      'result_msg': resultMessage,
      'summary': summary.toMap(),
      'sections': sections.map((x) => x.toMap()).toList(),
    };
  }

  factory Route.fromMap(Map<String, dynamic> map) {
    return Route(
      map['result_code'] as int,
      map['result_msg'] as String,
      RouteSummary.fromMap(map['summary'] as Map<String,dynamic>),
      List<RouteSection>.from((map['sections'] as List<dynamic>).map<RouteSection>((x) => RouteSection.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Route.fromJson(String source) => Route.fromMap(json.decode(source) as Map<String, dynamic>);
}
