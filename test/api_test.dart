import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical_12/auth_api.dart';

class RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  int status = 200;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString('ok', status);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'Login/signup/reset надсилаються POST JSON на власний піддомен',
    () async {
      final adapter = RecordingAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      final api = AuthApi(client: dio);
      for (final action in ['login', 'signup', 'reset']) {
        final data = {
          'email': 'test@example.com',
          if (action != 'reset') 'password': 'example7',
          if (action == 'signup') 'name': 'Student',
        };
        expect(
          await api.send('https://student25.requestcatcher.com/', action, data),
          200,
        );
        expect(adapter.request!.method, 'POST');
        expect(
          adapter.request!.uri.toString(),
          'https://student25.requestcatcher.com/$action',
        );
        expect(adapter.request!.data, data);
        expect(adapter.request!.contentType, Headers.jsonContentType);
      }
      adapter.status = 500;
      await expectLater(
        api.send('https://student25.requestcatcher.com', 'login', {}),
        throwsA(isA<DioException>()),
      );
      api.close();
    },
  );
  test('Невірні адреси відхиляються до запиту', () {
    for (final value in [
      '',
      'http://a.requestcatcher.com',
      'https://example.com',
      'https://a.requestcatcher.com.evil.test',
      'https://a.requestcatcher.com/path',
    ]) {
      expect(AuthApi.validateEndpoint(value), isNotNull);
    }
    expect(
      AuthApi.validateEndpoint('https://student25.requestcatcher.com'),
      isNull,
    );
  });
}
