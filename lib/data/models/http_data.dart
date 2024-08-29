import 'package:flutter/material.dart';

enum MethodType {
  get('GET', Colors.green),
  post('POST', Colors.orange),
  put('PUT', Colors.indigo),
  delete('DELETE', Colors.pink);

  final String value;
  final Color color;

  const MethodType(this.value, this.color);

  factory MethodType.fromString(String value) {
    final upperValue = value.toUpperCase();
    return MethodType.values.firstWhere((el) => el.value == upperValue, orElse: () => MethodType.get);
  }
}
