// api_config.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';

const String baseUrl = "vslaapi.coopbankoromiasc.com:9000";
HttpClient createHttpClient() {
  final HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return httpClient;
}

IOClient createIOClient() {
  return IOClient(createHttpClient());
}
