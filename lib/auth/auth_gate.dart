import 'package:flashcards_app/home_page_controller.dart';
import 'package:flashcards_app/sign_in_unauthorized_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return state is SignedInState
            ? HomeController(state: state)
            : const SignInUnauthorizedPage();
      },
    );
  }
}
