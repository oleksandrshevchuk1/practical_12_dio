import 'dart:convert';
import 'package:practical_12/auth_api.dart';

/// Повторне надсилання даних форм тим самим сервісом, який викликає AuthScreen.
/// Усі адреси та пароль демонстраційні; передавання погоджено користувачем.
Future<void> main() async {
  const endpoint = 'https://mobile25-demo-9c3a0c9f10.requestcatcher.com';
  final api = AuthApi();
  try {
    final examples = <String, Map<String, String>>{
      'login': {'email': 'student25@example.com', 'password': 'DemoPass25'},
      'signup': {
        'email': 'new25@example.com',
        'name': 'Oleksandr',
        'password': 'DemoPass25',
      },
      'reset': {'email': 'student25@example.com'},
    };
    for (final example in examples.entries) {
      final status = await api.send(endpoint, example.key, example.value);
      print(jsonEncode({'action': example.key, 'status': status}));
    }
  } finally {
    api.close();
  }
}
