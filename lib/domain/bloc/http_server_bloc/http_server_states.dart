part of 'http_server_cubit.dart';

sealed class HttpServerState {
  final bool isBuild;
  final bool isPlay;
  final int port;

  const HttpServerState({
    required this.isBuild,
    this.isPlay = false,
    this.port = 8080,
  });

  HttpServerState play({required int port}) {
    return HttpServerInfoState(
      isBuild: true,
      isPlay: true,
      port: port,
    );
  }

  HttpServerState stop({int? port}) {
    return HttpServerInfoState(
      isBuild: true,
      isPlay: false,
      port: port ?? this.port,
    );
  }

  HttpServerRequestHistoryState showRequestsHistory({
    required List<RequestModel> history,
  }) {
    return HttpServerRequestHistoryState(
      history: history,
      port: port,
    );
  }

  HttpServerErrorState failure(Object err) {
    return HttpServerErrorState(
      err.toString(),
      isBuild: isBuild,
      isPlay: isPlay,
      port: port,
    );
  }

  factory HttpServerState.ready(int port) => HttpServerInfoState(
        isBuild: false,
        isPlay: false,
        port: port,
      );
}

class HttpServerInfoState extends HttpServerState {
  const HttpServerInfoState({
    required super.isBuild,
    required super.isPlay,
    required super.port,
  });
}

class HttpServerErrorState extends HttpServerState {
  final String message;
  const HttpServerErrorState(
    this.message, {
    required super.isBuild,
    required super.isPlay,
    required super.port,
  });
}

class HttpServerRequestHistoryState extends HttpServerState {
  final List<RequestModel> history;

  HttpServerRequestHistoryState({
    required this.history,
    required super.port,
  }) : super(isBuild: true, isPlay: true);
}

/* class HttpServerInfoState extends HttpServerState {
  final bool isPlay;
  final int port;
  const HttpServerInfoState({
    required this.isPlay,
    this.port = 8080,
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
*/