import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener, ReadContext;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utils/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            autocorrect: false,
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            enableSuggestions: false,
            obscureText: true,
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthException ||
                    state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(context, 'Wrong credentials');
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogIn(email, password));
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register here!'))
        ],
      ),
    );
  }
}
