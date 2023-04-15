import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/auth_cubit.dart';

class SignInUnauthorizedPage extends StatefulWidget {
  const SignInUnauthorizedPage({Key? key}) : super(key: key);

  @override
  State<SignInUnauthorizedPage> createState() => _SignInUnauthorizedPageState();
}

class _SignInUnauthorizedPageState extends State<SignInUnauthorizedPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flashcards App'),
            backgroundColor: Colors.indigo,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email address',
                  ),
                  controller: email,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  controller: password,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (state is SignedOutState && state.error != null) ...[
                  Text(state.error!),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 32),
                _SignInButton(
                  email: email,
                  password: password,
                ),
                //const SizedBox(height: 24),
                //const SignInGoSignUpButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  final TextEditingController email;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is SignedOutState
              ? () => context.read<AuthCubit>().signInWithEmail(
                    email.text,
                    password.text,
                  )
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigo),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: state is SignedOutState
              ? const Text('Sign in')
              : const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}
