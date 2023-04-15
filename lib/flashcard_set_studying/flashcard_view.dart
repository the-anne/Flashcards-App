import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/data/repository/data_repository.dart';
import 'package:flashcards_app/flashcard_set_studying/bug_reports_chat_page.dart';
import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String text;
  final String folderID;
  final int flashcardID;
  final SignedInState state;
  final DataRepository repository = DataRepository();

  FlashcardView(
      {Key? key,
      required this.text,
      required this.flashcardID,
      required this.folderID,
      required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getStreamForCommentCollectionForAGivenFlashcard(
            folderID, flashcardID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          }
          Icon icon = const Icon(
            Icons.report_outlined,
            color: Colors.grey,
          );
          if (snapshot.data?.docs.isNotEmpty ?? false) {
            icon = const Icon(
              Icons.report_outlined,
              color: Colors.red,
            );
          }
          return Card(
            elevation: 6,
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BugReportsChat(
                                      state: state,
                                      flashcardSetID: folderID,
                                      flashcardIndex: flashcardID,
                                    )),
                          );
                        },
                        icon: icon,
                        alignment: Alignment.topRight,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer()
              ],
            ),
          );
        });
  }
}
