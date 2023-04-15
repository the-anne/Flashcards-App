import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/data/data_models/bug_report_comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/repository/data_repository.dart';

class BugReportsChat extends StatefulWidget {
  BugReportsChat(
      {super.key,
      required this.flashcardSetID,
      required this.flashcardIndex,
      required this.state});

  final String flashcardSetID;
  final int flashcardIndex;
  final SignedInState state;
  final DataRepository repository = DataRepository();

  @override
  State<BugReportsChat> createState() => _BugReportsChatState();
}

class _BugReportsChatState extends State<BugReportsChat> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.repository
              .getStreamForCommentCollectionForAGivenFlashcard(
                  widget.flashcardSetID, widget.flashcardIndex),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LinearProgressIndicator();
            }
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.indigo,
                  title: const Text('Bug reports chat'),
                ),
                body: Container(
                  color: Colors.grey.shade300,
                  child: Column(children: [
                    Expanded(
                      child: buildComments(snapshot.data?.docs),
                    ),
                    ColoredBox(
                      color: Colors.white,
                      child: ListTile(
                          tileColor: Colors.indigo,
                          title: TextFormField(
                            controller: commentController,
                            decoration: const InputDecoration(
                                hintText: "Write what the issue is..."),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.indigo,
                            ),
                            onPressed: () {
                              BugReportComment bugReportComment =
                                  BugReportComment(
                                      commentText: commentController.text,
                                      authorsEmail: widget.state.email,
                                      dateOfSubmission: Timestamp.now());
                              widget.repository.addBugReportComment(
                                  widget.flashcardSetID,
                                  widget.flashcardIndex,
                                  bugReportComment);
                              commentController.clear();
                            },
                          )),
                    )
                  ]),
                ),
              ),
            );
          }),
    );
  }
}

buildComments(List<QueryDocumentSnapshot<Object?>>? docs) {
  List<BugReportComment>? comments = docs?.map((data) {
    return BugReportComment.fromSnapshot(data);
  }).toList();
  comments?.sort((a, b) {
    return a.dateOfSubmission.compareTo(b.dateOfSubmission);
  });

  return ListView.builder(
    itemBuilder: ((context, index) {
      var dt = DateTime.fromMillisecondsSinceEpoch(
          comments.elementAt(index).dateOfSubmission.millisecondsSinceEpoch);
      var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text(
              comments.elementAt(index).commentText,
            ),
            subtitle: Text(
                '\n$d12\nAuthor: ${comments.elementAt(index).authorsEmail}'),
          ),
        ),
      );
    }),
    itemCount: comments!.length,
  );
}
