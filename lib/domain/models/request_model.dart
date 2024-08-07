import 'dart:io';

class RequestModel {
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
  final DateTime time;

  const RequestModel({
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
    required this.time,
  });

  factory RequestModel.fromRequest(HttpRequest request, String requestBody) {
    final Map<String, String> headers = {};
    request.headers.forEach(
      (name, values) {
        headers[name] = values.join('\r\n');
      },
    );
    return RequestModel(
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
      time: DateTime.now(),
    );
  }
}
