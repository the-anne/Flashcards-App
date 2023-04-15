import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/data/data_models/flashcard.dart';
import 'package:flashcards_app/data/data_models/flashcard_set.dart';
import 'package:flashcards_app/flashcard_set_studying/flashcards_page.dart';
import 'package:flutter/material.dart';

import '../data/data_models/user.dart';
import '../data/repository/data_repository.dart';

// ignore: must_be_immutable
class FlashcardSetsDetailsPage extends StatelessWidget {
  FlashcardSetsDetailsPage({
    super.key,
    required this.state,
    required this.flashcardSet,
    this.userInfo,
  });

  final SignedInState state;
  final FlashcardSet flashcardSet;
  UserInfo? userInfo;

  @override
  Widget build(BuildContext context) {
    var userInfoStream =
        DataRepository().getStreamForUserCollectionForAGivenUser(state.email);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: userInfoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LinearProgressIndicator();
            } else {
              userInfo = UserInfo.fromSnapshot(snapshot.data?.docs.first);

              return Scaffold(
                backgroundColor: Colors.grey.shade300,
                appBar: AppBar(
                  title: const Text('Flashcards App'),
                  backgroundColor: Colors.indigo,
                ),
                body: ListView.builder(
                  itemCount: flashcardSet.flashcards.length + 2,
                  itemBuilder: ((context, index) {
                    if (index == 0) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 16, right: 16),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.indigo),
                            elevation: const MaterialStatePropertyAll(5),
                            minimumSize:
                                const MaterialStatePropertyAll(Size(0, 60)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FlashcardsPage(
                                        state: state,
                                        flashcards: flashcardSet.flashcards,
                                        folderID: flashcardSet.folderID,
                                      )),
                            );
                          },
                          child: const Text(
                            'Study all flashcards',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 16, right: 16, bottom: 40),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.indigo),
                            elevation: const MaterialStatePropertyAll(5),
                            minimumSize:
                                const MaterialStatePropertyAll(Size(0, 60)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            List<Flashcard> notKnownFlashcards = [];
                            for (var item in flashcardSet.flashcards) {
                              if (userInfo?.notKnownFlashcardSets[
                                          flashcardSet.folderID]
                                      ?.contains(item.flashcardID) ??
                                  false) {
                                notKnownFlashcards.add(item);
                              }
                            }
                            if (notKnownFlashcards.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FlashcardsPage(
                                          state: state,
                                          flashcards: notKnownFlashcards,
                                          folderID: flashcardSet.folderID,
                                        )),
                              );
                            }
                          },
                          child: const Text('Study only marked flashcards',
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    } else {
                      Color color = Colors.white;
                      if (userInfo?.notKnownFlashcardSets[flashcardSet.folderID]
                              ?.contains(index - 2) ??
                          false) {
                        color = Colors.indigo.shade200;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 12.0),
                        child: ListTile(
                          tileColor: color,
                          title:
                              Text(flashcardSet.flashcards[index - 2].foreign),
                          subtitle:
                              Text(flashcardSet.flashcards[index - 2].native),
                          onLongPress: () {},
                        ),
                      );
                    }
                  }),
                ),
              );
            }
          }),
    );
  }
}
