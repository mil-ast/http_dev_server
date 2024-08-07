part of 'http_server_cubit.dart';

sealed class HttpServerState {
  final bool isBuild;
  const HttpServerState(this.isBuild);

  factory HttpServerState.play() => const HttpServerInfoState(isPlay: true);
  factory HttpServerState.stop() => const HttpServerInfoState(isPlay: false);
  factory HttpServerState.message(String mesage) = HttpServerInformState;
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

class HttpServerRequestState extends HttpServerState {
  final int statusCode;
  final String method;
  final String protocolVersion;
  final bool persistentConnection;
  final int contentLength;
  final String content;
  final Map<String, String> headers;
  final Uri requestedUri;
  final InternetAddress? remoteAddress;
  final int? remotePort;

  const HttpServerRequestState({
    required this.statusCode,
    required this.method,
    required this.protocolVersion,
    required this.persistentConnection,
    required this.contentLength,
    required this.content,
    required this.headers,
    required this.requestedUri,
    this.remoteAddress,
    this.remotePort,
  }) : super(true);

  factory HttpServerRequestState.fromRequest(HttpRequest request, String requestBody) {
    final Map<String, String> headers = {};
    request.headers.forEach(
      (name, values) {
        headers[name] = values.join('\r\n');
      },
    );
    return HttpServerRequestState(
      statusCode: request.response.statusCode,
      method: request.method,
      protocolVersion: request.protocolVersion,
      persistentConnection: request.persistentConnection,
      contentLength: request.contentLength,
      content: requestBody,
      headers: headers,
      requestedUri: request.requestedUri,
      remoteAddress: request.connectionInfo?.remoteAddress,
      remotePort: request.connectionInfo?.remotePort,
    );
  }
}
