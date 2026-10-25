import 'package:flutter/material.dart';

import 'ui.dart';
import 'auth_api.dart';

enum AuthMode { login, signup, reset }

const useValidation = true;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.mode = AuthMode.login});
  final AuthMode mode;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  bool _busy = false;
  String? _message;
  bool _failed = false;
  final _endpoint = TextEditingController(
    text: const String.fromEnvironment('REQUEST_CATCHER_URL'),
  );
  final _api = AuthApi();

  bool get _signup => widget.mode == AuthMode.signup;
  bool get _reset => widget.mode == AuthMode.reset;
  String get _title => _signup
      ? 'Sign up'
      : _reset
      ? 'Reset password'
      : 'Login';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _endpoint.dispose();
    _api.close();
    super.dispose();
  }

  String? _required(String? value) =>
      (value ?? '').trim().isEmpty ? 'Обов’язкове поле' : null;
  String? _validateEmail(String? value) {
    final empty = _required(value);
    if (empty != null) return empty;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())
        ? null
        : 'Введіть коректний email';
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Обов’язкове поле';
    return value!.length >= 7 ? null : 'Пароль має містити не менше 7 символів';
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (useValidation && !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _message = null;
      _failed = false;
    });
    try {
      final action = _signup
          ? 'signup'
          : _reset
          ? 'reset'
          : 'login';
      final status = await _api.send(_endpoint.text, action, {
        'email': _email.text.trim(),
        if (_signup) 'name': _name.text.trim(),
        if (!_reset) 'password': _password.text,
      });
      if (mounted) {
        setState(
          () => _message =
              'Запит /$action надіслано. HTTP $status. Відкрийте свій RequestCatcher.',
        );
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _failed = true;
          _message =
              'Не вдалося виконати запит. Перевірте адресу та інтернет. $error';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _open(AuthMode mode) => Navigator.of(
    context,
  ).push<void>(MaterialPageRoute(builder: (_) => AuthScreen(mode: mode)));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_title)),
    body: PageBody(
      width: 440,
      children: [
        const SizedBox(height: 24),
        const FlutterLogo(size: 64),
        const SizedBox(height: 8),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_signup) ...[
                TextFormField(
                  key: const Key('name'),
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  validator: useValidation ? _required : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                key: const Key('email'),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: _reset
                    ? TextInputAction.done
                    : TextInputAction.next,
                autocorrect: false,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: useValidation ? _validateEmail : null,
              ),
              if (!_reset) ...[
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('password'),
                  controller: _password,
                  obscureText: _hidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      tooltip: _hidden ? 'Показати пароль' : 'Приховати пароль',
                      onPressed: () => setState(() => _hidden = !_hidden),
                      icon: Icon(
                        _hidden
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: useValidation ? _validatePassword : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('endpoint'),
                controller: _endpoint,
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'RequestCatcher URL',
                  hintText: 'https://your-name.requestcatcher.com',
                ),
                validator: AuthApi.validateEndpoint,
              ),
              const SizedBox(height: 24),
              if (widget.mode == AuthMode.login) ...[
                OutlinedButton(
                  onPressed: _busy ? null : () => _open(AuthMode.signup),
                  child: const Text('Sign up'),
                ),
                const SizedBox(height: 12),
              ],
              ElevatedButton(
                key: const Key('submit'),
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_reset ? 'Reset' : _title),
              ),
              if (widget.mode == AuthMode.login)
                TextButton(
                  onPressed: _busy ? null : () => _open(AuthMode.reset),
                  child: const Text('Reset password'),
                )
              else
                TextButton(
                  onPressed: _busy ? null : () => Navigator.pop(context),
                  child: const Text('Back to login'),
                ),
            ],
          ),
        ),
        if (_message != null)
          Semantics(
            liveRegion: true,
            child: Text(
              _message!,
              style: TextStyle(
                color: _failed ? Theme.of(context).colorScheme.error : null,
              ),
            ),
          ),
        const Text(
          'Використовуйте лише навчальні дані. Запит надсилається на введену вами адресу.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
