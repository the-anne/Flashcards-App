import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'auth/auth_cubit.dart';
import 'auth/auth_gate.dart';
import 'auth/auth_service.dart';

class MyFlashcardsApp extends StatelessWidget {
  const MyFlashcardsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AuthService(
        firebaseAuth: FirebaseAuth.instance,
      ),
      child: BlocProvider(
        create: (ctx) => AuthCubit(
          authService: ctx.read(),
        ),
        child: MaterialApp(
          title: 'Flashcards App',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: const Scaffold(
            body: AuthGate(),
          ),
        ),
      ),
    );
  }
}
