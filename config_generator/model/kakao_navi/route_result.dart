// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'route.dart';

class RouteResult {
  final String transId;
  final List<Route> routes;

  RouteResult(this.transId, this.routes);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'trans_id': transId,
      'routes': routes.map((x) => x.toMap()).toList(),
    };
  }

  factory RouteResult.fromMap(Map<String, dynamic> map) {
    return RouteResult(
      map['trans_id'] as String,
      List<Route>.from((map['routes'] as List<dynamic>).map<Route>((x) => Route.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteResult.fromJson(String source) => RouteResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
