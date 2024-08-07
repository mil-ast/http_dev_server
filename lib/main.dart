import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http_dev_server/core/theme/theme.dart';
import 'package:http_dev_server/feature/home/home_screen.dart';
import 'package:logger/web.dart';

void main() async {
  var logger = Logger();

  runZonedGuarded(
    () {
      runApp(const App());
    },
    (error, stack) {
      logger.e(error, stackTrace: stack);
    },
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Dev Server',
      debugShowCheckedModeBanner: false,
      theme: wbTheme,
      home: const HomeScreen(),
    );
  }
}
