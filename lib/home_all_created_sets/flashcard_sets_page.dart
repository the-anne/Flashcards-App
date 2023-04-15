import 'package:flashcards_app/auth/auth_cubit.dart' show SignedInState;
import 'package:flashcards_app/data/data_models/flashcard_set.dart';
import 'package:flashcards_app/flashcard_set_details/flashcard_set_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlashcardSetsPage extends StatefulWidget {
  const FlashcardSetsPage(
      {Key? key,
      required this.state,
      required this.context,
      required this.snapshot})
      : super(key: key);

  final SignedInState state;
  final dynamic snapshot;
  final BuildContext context;

  @override
  State<FlashcardSetsPage> createState() => _FlashcardSetsPageState();
}

class _FlashcardSetsPageState extends State<FlashcardSetsPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic>? flashcardSets = widget.snapshot?.map((data) {
      return FlashcardSet.fromSnapshot(data);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context, int index) {
            var folder = flashcardSets?[index];
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
                  '${folder?.foldersName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '\n${folder?.flashcards.length} flashcards\n\nAuthor: ${widget.state.email == folder?.authorsEmail ? 'You' : folder?.authorsEmail}'),
                textColor: Colors.black,
                iconColor: Colors.indigo,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) {
                        return FlashcardSetsDetailsPage(
                          state: widget.state,
                          flashcardSet: folder,
                        );
                      }),
                    ),
                  );
                },
                trailing: folder?.isPrivate
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
          itemCount: flashcardSets?.length ?? 0,
        ),
      ),
    );
  }
}
