import 'package:dio/dio.dart';

/// Для демонстрації використовуйте вигадані навчальні облікові дані.
class AuthApi {
  AuthApi({Dio? client})
    : _client =
          client ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
            ),
          );
  final Dio _client;

  static String? validateEndpoint(String? value) {
    final uri = Uri.tryParse((value ?? '').trim());
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.userInfo.isNotEmpty ||
        uri.port != 443 ||
        !RegExp(
          r'^[a-z0-9][a-z0-9-]*\.requestcatcher\.com$',
        ).hasMatch(uri.host)) {
      return 'Введіть https://ваш-піддомен.requestcatcher.com';
    }
    if (uri.hasQuery ||
        uri.hasFragment ||
        (uri.path.isNotEmpty && uri.path != '/')) {
      return 'Введіть адресу піддомену без шляху та параметрів';
    }
    return null;
  }

  Future<int> send(
    String endpoint,
    String action,
    Map<String, String> fields,
  ) async {
    final error = validateEndpoint(endpoint);
    if (error != null) throw ArgumentError(error);
    if (!['login', 'signup', 'reset'].contains(action)) {
      throw ArgumentError('Невідома дія');
    }
    final base = Uri.parse(endpoint.trim());
    final url = base.replace(path: '/$action').toString();
    final response = await _client.post<Object?>(
      url,
      data: fields,
      options: Options(contentType: Headers.jsonContentType),
    );
    return response.statusCode ?? 0;
  }

  void close() => _client.close(force: true);
}
