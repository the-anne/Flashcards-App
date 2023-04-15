import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flutter/material.dart';

class FlashcardSetFormSubmittedPage extends StatelessWidget {
  const FlashcardSetFormSubmittedPage({
    Key? key,
    required this.state,
    required this.flashcardSetName,
  }) : super(key: key);

  final SignedInState state;
  final String flashcardSetName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Flashcards App'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check,
              color: Colors.indigo,
              size: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "You have successfully created the flashcard set '$flashcardSetName' !",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
