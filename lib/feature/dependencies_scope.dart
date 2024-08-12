import 'package:flutter/material.dart';
import 'package:http_dev_server/data/repository/apis_repository.dart';
import 'package:http_dev_server/database/database.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Dependencies {
  final Database db;
  final SharedPreferences sp;
  final IApisRepository apisRepository;
  final String workDir;
  final Logger logger;

  const Dependencies({
    required this.db,
    required this.sp,
    required this.apisRepository,
    required this.workDir,
    required this.logger,
  });
}

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final Dependencies dependencies;

  static Dependencies? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DependenciesScope>()?.dependencies;
  }

  static Dependencies of(BuildContext context) {
    final Dependencies? result = maybeOf(context);
    assert(result != null, 'No DependenciesScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant DependenciesScope oldWidget) => dependencies != oldWidget.dependencies;
}
