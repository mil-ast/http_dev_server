import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/data/models/group_apis_model.dart';
import 'package:http_dev_server/data/models/item_api_model.dart';
import 'package:http_dev_server/domain/models/request_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'http_server_states.dart';

class HttpServerCubit extends Cubit<HttpServerState> {
  static const spKeyPort = 'server_port';
  static const defaultPort = 8080;

  HttpServerCubit() : super(HttpServerState.ready(defaultPort)) {
    _initialize();
  }

  final List<RequestModel> _requestHistory = [];
  HttpServer? _server;

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    emit(state.failure(error));
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPort = prefs.getInt(spKeyPort);
    if (savedPort != null) {
      emit(state.stop(port: savedPort));
    }

    final Directory appDocumentsDir = await getApplicationSupportDirectory();
    print(appDocumentsDir);
  }

  void start(List<GroupApisModel> apis, int? port) async {
    try {
      if (port == null) {
        throw Exception('Неверный порт');
      }
      if (port < 1 || port > 0xFFFF) {
        throw Exception('Диапазон порта от 1 до ${0xffff}');
      }

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(spKeyPort, port).ignore();

      _server?.close();

      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);

      emit(state.play(port: port));

      await _server!.forEach((HttpRequest request) async {
        final body = await utf8.decodeStream(request);
        final apiKey = '${request.method}${request.requestedUri.path}';

        ItemApiModel? api;
        outerLoop:
        for (final g in apis) {
          for (final a in g.rows) {
            if (a.key == apiKey) {
              api = a;
              break outerLoop;
            }
          }
        }

        if (api != null) {
          final newRequest = RequestModel.fromRequest(request, body);
          _requestHistory.insert(0, newRequest);
          emit(state.showRequestsHistory(history: _requestHistory));

          request.response.statusCode = api.responseStatusCode;

          api.headers?.keys.forEach(
            (key) {
              request.response.headers.add(key, api!.headers?[key] ?? '');
            },
          );

          request.response.write(api.body);
          request.response.close();
          return;
        }

        request.response.statusCode = 404;
        request.response.write('Not found');
        request.response.close();

        final newRequest = RequestModel.fromRequest(request, body);
        _requestHistory.insert(0, newRequest);
        emit(state.showRequestsHistory(history: _requestHistory));
      });
    } catch (e, st) {
      onError(e, st);
      stop();
    }
  }

  void stop() async {
    emit(state.stop());
    _server?.close();
  }
}
