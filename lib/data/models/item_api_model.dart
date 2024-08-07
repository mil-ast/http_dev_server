import 'dart:convert';
import 'dart:io';

import 'package:http_dev_server/data/models/http_data.dart';

class ItemApiModel {
  MethodType method;
  String path;
  Map<String, String>? headers;
  int responseStatusCode;
  String? body;

  ItemApiModel({
    this.method = MethodType.get,
    required this.path,
    this.headers,
    this.responseStatusCode = 200,
    this.body,
  });

  factory ItemApiModel.fromJson(Map<String, Object?> json) {
    final api = json['api'] as String;
    final splitApi = api.split(' ');

    String path;
    MethodType method;

    if (splitApi.length != 2) {
      method = MethodType.get;
      path = '/';
    } else {
      method = MethodType.fromString(splitApi.first);
      path = splitApi.last;
    }

    return ItemApiModel(
        method: method,
        path: path,
        headers: (json['headers'] as Map<String, dynamic>?)?.cast<String, String>(),
        responseStatusCode: (json['statusCode'] as int?) ?? HttpStatus.ok,
        body: json['body'] as String?);
  }

  factory ItemApiModel.withDefaultValues() => ItemApiModel(
        path: '/api/test',
        method: MethodType.get,
        responseStatusCode: 200,
        body: '{"status": "ok"}',
        headers: {
          'Content-Type': 'application/json',
          'Server': 'HttpDevServer',
        },
      );

  Map<String, Object?> toJson() {
    return {
      'api': '${method.value} $path',
      'headers': headers,
      'statusCode': responseStatusCode,
      'body': body,
    };
  }

  String get key => '${method.name.toUpperCase()}$path';
}
