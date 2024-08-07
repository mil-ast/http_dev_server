part of 'http_server_cubit.dart';

sealed class HttpServerState {
  final bool isBuild;
  const HttpServerState(this.isBuild);

  factory HttpServerState.play() => const HttpServerInfoState(isPlay: true);
  factory HttpServerState.stop() => const HttpServerInfoState(isPlay: false);
  factory HttpServerState.message(String message) = HttpServerInformState;
  factory HttpServerState.requestHistory({required List<RequestModel> history}) = HttpServerRequestHistoryState;
  factory HttpServerState.failure(Object err) => HttpServerErrorState(err.toString());
}

class HttpServerInfoState extends HttpServerState {
  final bool isPlay;
  const HttpServerInfoState({
    required this.isPlay,
  }) : super(true);
}

class HttpServerErrorState extends HttpServerState {
  final String message;
  const HttpServerErrorState(this.message) : super(false);
}

class HttpServerInformState extends HttpServerState {
  final String message;
  const HttpServerInformState(this.message) : super(false);
}

class HttpServerRequestHistoryState extends HttpServerState {
  final List<RequestModel> history;

  const HttpServerRequestHistoryState({
    required this.history,
  }) : super(true);
}
