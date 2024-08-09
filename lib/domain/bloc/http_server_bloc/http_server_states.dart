part of 'http_server_cubit.dart';

sealed class HttpServerState {
  final bool isBuild;
  final int? port;
  const HttpServerState(this.isBuild, {this.port});

  factory HttpServerState.play({int? port}) => HttpServerInfoState(isPlay: true, port: port);
  factory HttpServerState.stop({int? port}) => HttpServerInfoState(isPlay: false, port: port);
  factory HttpServerState.message(String message, {int? port}) = HttpServerInformState;
  factory HttpServerState.requestHistory({
    required List<RequestModel> history,
    int? port,
  }) = HttpServerRequestHistoryState;
  factory HttpServerState.failure(
    Object err, {
    int? port,
  }) =>
      HttpServerErrorState(err.toString(), port: port);

  HttpServerState play({int? port}) => HttpServerState.play(port: port);

  HttpServerState stop() => HttpServerState.stop(port: port);

  HttpServerState setMessage(String message) => HttpServerState.message(message, port: port);

  HttpServerState requestHistory(List<RequestModel> history) => HttpServerState.requestHistory(
        history: history,
        port: port,
      );

  HttpServerState failure(Object err) => HttpServerState.failure(err, port: port);
}

class HttpServerInfoState extends HttpServerState {
  final bool isPlay;
  const HttpServerInfoState({required this.isPlay, super.port}) : super(true);
}

class HttpServerErrorState extends HttpServerState {
  final String message;
  const HttpServerErrorState(this.message, {super.port}) : super(false);
}

class HttpServerInformState extends HttpServerState {
  final String message;
  const HttpServerInformState(this.message, {super.port}) : super(false);
}

class HttpServerRequestHistoryState extends HttpServerState {
  final List<RequestModel> history;

  const HttpServerRequestHistoryState({required this.history, super.port}) : super(true);
}
