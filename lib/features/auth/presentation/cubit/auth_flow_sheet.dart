import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';

enum _AuthMode { login, register }

class AuthFlowSheet extends StatefulWidget {
  final bool startOnRegister;

  const AuthFlowSheet({super.key, required this.startOnRegister});

  @override
  State<AuthFlowSheet> createState() => _AuthFlowSheetState();
}

class _AuthFlowSheetState extends State<AuthFlowSheet> {
  late _AuthMode _mode;

  // login
  final _email = TextEditingController();
  final _password = TextEditingController();

  // register
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _rEmail = TextEditingController();
  final _rPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.startOnRegister ? _AuthMode.register : _AuthMode.login;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _surname.dispose();
    _rEmail.dispose();
    _rPassword.dispose();
    super.dispose();
  }

  void _submit() {
    if (_mode == _AuthMode.login) {
      context.read<AuthCubit>().signIn(_email.text.trim(), _password.text);
    } else {
      context.read<AuthCubit>().signUp(
        _rEmail.text.trim(),
        _rPassword.text,
        _name.text.trim(),
        _surname.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height * 0.85;

    return SizedBox(
      height: height,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pop(context); // ✅ TEK POP -> sheet kapanır
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: bottomInset + 16,
            ),
            child: Column(
              children: [
                // drag handle
                Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),

                Row(
                  children: [
                    Text(
                      _mode == _AuthMode.login ? 'Login' : 'Register',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: AbsorbPointer(
                    absorbing: isLoading,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_mode == _AuthMode.login) ...[
                            TextField(
                              controller: _email,
                              decoration: const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _password,
                              decoration: const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              onSubmitted: (_) => _submit(),
                            ),
                          ] else ...[
                            TextField(
                              controller: _name,
                              decoration: const InputDecoration(labelText: 'Name'),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _surname,
                              decoration: const InputDecoration(labelText: 'Surname'),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _rEmail,
                              decoration: const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _rPassword,
                              decoration: const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              onSubmitted: (_) => _submit(),
                            ),
                          ],

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              child: Text(_mode == _AuthMode.login ? 'Login' : 'Create account'),
                            ),
                          ),

                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              setState(() {
                                _mode = _mode == _AuthMode.login ? _AuthMode.register : _AuthMode.login;
                              });
                            },
                            child: Text(
                              _mode == _AuthMode.login
                                  ? 'Create an account'
                                  : 'I already have an account',
                            ),
                          ),

                          if (state is AuthError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          if (isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}