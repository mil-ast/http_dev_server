import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_dev_server/core/theme/theme.dart';
import 'package:http_dev_server/data/providers/apis_data_provider.dart';
import 'package:http_dev_server/data/repository/apis_repository.dart';
import 'package:http_dev_server/database/database.dart';
import 'package:http_dev_server/domain/bloc/apis_bloc/apis_cubit.dart';
import 'package:http_dev_server/feature/dependencies_scope.dart';
import 'package:http_dev_server/feature/home/home_screen.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  var logger = Logger();

  runZonedGuarded(
    () async {
      final prefs = await SharedPreferences.getInstance();

      String? workDir = prefs.getString(ApisCubit.spKeyWorkDir);
      if (workDir == null) {
        final Directory appSupportDir = await getApplicationSupportDirectory();
        workDir = appSupportDir.path;
      }

      final db = Database('$workDir/http_dev_server.json');
      final dataProvider = ApisDataProvider(db: db);
      final apisRepository = ApisRepository(dataProvider: dataProvider);

      runApp(DependenciesScope(
        dependencies: Dependencies(
          db: db,
          sp: prefs,
          apisRepository: apisRepository,
          workDir: workDir,
          logger: logger,
        ),
        child: const App(),
      ));
    },
    (error, stack) {
      logger.e(error, stackTrace: stack);
      // TODO запись в файл
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
