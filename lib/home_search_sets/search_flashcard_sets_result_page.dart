import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/data/data_models/flashcard_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../flashcard_set_details/flashcard_set_details.dart';

// ignore: must_be_immutable
class SearchFlashcardSetsResultPage extends StatefulWidget {
  SearchFlashcardSetsResultPage(
      {super.key,
      required this.query,
      required this.flashcardSets,
      required this.state}) {
    // var res = DataRepository().getStream();
    // List<FlashcardSet> helperList = [];
    // res.forEach(
    //   (element) {
    //     for (var document in element.docs) {
    //       var fset = FlashcardSet.fromSnapshot(document);
    //       helperList.add(fset);
    //     }
    //   },
    // );
    // flashcardSets = helperList.where((element) {
    //   return folderIDs.contains(element.folderID);
    // }).toList();
  }

  final dynamic query;
  List<FlashcardSet> flashcardSets = [];
  List<String> folderIDs = [];
  SignedInState state;

  @override
  State<SearchFlashcardSetsResultPage> createState() =>
      _SearchFlashcardSetsResultPageState();
}

class _SearchFlashcardSetsResultPageState
    extends State<SearchFlashcardSetsResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context, int index) {
            var folder = widget.flashcardSets[index];
            return Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(4),
                leading: const Icon(Icons.folder),
                title: Text(
                  folder.foldersName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '\n${folder.flashcards.length} flashcards\n\nAuthor: ${folder.authorsEmail}'),
                textColor: Colors.black,
                iconColor: Colors.indigo,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => FlashcardSetsDetailsPage(
                            state: widget.state,
                            flashcardSet: folder,
                          ))));
                },
                trailing: folder.isPrivate
                    ? const Icon(Icons.lock, color: Colors.grey)
                    : const Icon(
                        CupertinoIcons.globe,
                        color: Colors.grey,
                      ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
          itemCount: widget.flashcardSets.length,
        ),
      ),
    );
  }
}
