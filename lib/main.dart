import 'package:flashcards_app/app.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const app = MyFlashcardsApp();
  // db = FirebaseFirestore.instance;
  runApp(const MyApp(app: app));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.app}) : super(key: key);

  final Widget app;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return MaterialApp(home: widget.app);
          default:
            return const ColoredBox(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
        }
      },
    );
  }
}
