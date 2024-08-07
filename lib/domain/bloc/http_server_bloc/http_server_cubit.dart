import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/data/models/group_apis_model.dart';
import 'package:http_dev_server/data/models/item_api_model.dart';

part 'http_server_states.dart';

class HttpServerCubit extends Cubit<HttpServerState> {
  HttpServerCubit() : super(HttpServerState.stop());

  HttpServer? _server;

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    emit(HttpServerState.failure(error));
  }

  void start(List<GroupApisModel> apis, int? port) async {
    try {
      if (port == null) {
        throw Exception('Неверный порт');
      }
      if (port < 1 || port > 0xFFFF) {
        throw Exception('Диапазон порта от 1 до ${0xffff}');
      }
      _server?.close();

      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);

      emit(HttpServerState.play());

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
          emit(HttpServerRequestState.fromRequest(request, body));

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
        emit(HttpServerRequestState.fromRequest(request, body));
      });

      emit(HttpServerState.message('Сервер остановлен'));
    } catch (e, st) {
      onError(e, st);
    }
  }

  void stop() async {
    emit(HttpServerState.stop());
    _server?.close();
  }
}
