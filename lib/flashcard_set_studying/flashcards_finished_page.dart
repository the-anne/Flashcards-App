import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flutter/material.dart';

import '../data/data_models/flashcard.dart';
import '../data/data_models/user.dart';
import '../data/repository/data_repository.dart';

class FlashcardsFinishedSessionPage extends StatefulWidget {
  const FlashcardsFinishedSessionPage(
      {super.key,
      required this.sessionResult,
      required this.state,
      required this.folderID});

  final List<Flashcard> sessionResult;
  final SignedInState state;
  final String? folderID;

  @override
  State<FlashcardsFinishedSessionPage> createState() =>
      _FlashcardsFinishedSessionPageState();
}

class _FlashcardsFinishedSessionPageState
    extends State<FlashcardsFinishedSessionPage> {
  @override
  Widget build(BuildContext context) {
    var userInfoStream = DataRepository()
        .getStreamForUserCollectionForAGivenUser(widget.state.email);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: userInfoStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          } else {
            UserInfo userInfo =
                UserInfo.fromSnapshot(snapshot.data?.docs.first);
            userInfo.notKnownFlashcardSets[widget.folderID ?? ''] = [];

            for (var elem in widget.sessionResult) {
              if (elem.statusOfTheCard == FlashcardStatus.cardFailed) {
                userInfo.notKnownFlashcardSets[widget.folderID]
                    ?.add(elem.flashcardID);
              }
            }

            DataRepository().updateUserInfo(userInfo);

            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Study session completed!',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      child: const Text(
                        'Exit',
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
