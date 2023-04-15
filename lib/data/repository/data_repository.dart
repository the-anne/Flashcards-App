import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/data/data_models/bug_report_comment.dart';
import 'package:flashcards_app/data/data_models/flashcard_set.dart';
import 'package:flashcards_app/data/data_models/user.dart';

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('flashcardSets');
  final CollectionReference collectionOfUsers =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference collectionOfComments =
      FirebaseFirestore.instance.collection('bugReportsFlashcardSets');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Stream<QuerySnapshot> getStreamForUser(String authorsEmail) {
    return collection
        .where("authorsEmail", isEqualTo: authorsEmail)
        .snapshots();
  }

  Stream<DocumentSnapshot> getStreamForAGivenFolder(String? folderID) {
    return collection.doc(folderID).snapshots();
  }

  Future<DocumentReference> addFlashcardSet(FlashcardSet flashcardSet) {
    return collection.add(flashcardSet.toJson());
  }

  void updateFlashcardSet(FlashcardSet flashcardSet) async {
    await collection.doc(flashcardSet.folderID).update(flashcardSet.toJson());
  }

  void deleteFlashcardSet(FlashcardSet flashcardSet) async {
    await collection.doc(flashcardSet.folderID).delete();
  }

// ============================ USERS ==================================== //
  Stream<QuerySnapshot> getStreamForUserCollection() {
    return collectionOfUsers.snapshots();
  }

  Stream<QuerySnapshot> getStreamForUserCollectionForAGivenUser(
      String usersEmail) {
    return collectionOfUsers
        .where("usersEmail", isEqualTo: usersEmail)
        .snapshots();
  }

  // Stream<DocumentSnapshot> getStreamForUserCollectionForAGivenUserForAGivenFolder(String? usersEmail, String? folderID) {
  //   return collection.where("usersEmail", isEqualTo: usersEmail)..snapshots();
  // }

  Future<DocumentReference> addUserInfo(UserInfo userInfo) {
    return collectionOfUsers.add(userInfo.toJson());
  }

  void updateUserInfo(UserInfo userInfo) async {
    await collectionOfUsers.doc(userInfo.userInfoID).update(userInfo.toJson());
  }

  void deleteUserInfo(UserInfo userInfo) async {
    await collectionOfUsers.doc(userInfo.userInfoID).delete();
  }

// ============================ COMMENTS ==================================== //

  Stream<QuerySnapshot> getStreamForCommentCollectionForAGivenFlashcard(
      String folderID, int flashcardIndex) {
    return collectionOfComments
        .doc(folderID)
        .collection(flashcardIndex.toString())
        .snapshots();
  }

  Future<DocumentReference> addBugReportComment(
      String folderID, int flashcardIndex, BugReportComment bugReportComment) {
    return collectionOfComments
        .doc(folderID)
        .collection(flashcardIndex.toString())
        .add(bugReportComment.toJson());
  }

  void updateBugReportComment(String folderID, int flashcardIndex,
      BugReportComment bugReportComment) async {
    await collectionOfComments
        .doc(folderID)
        .collection(flashcardIndex.toString())
        .doc(bugReportComment.bugReportCommentID)
        .update(bugReportComment.toJson());
  }

  void deleteBugReportComment(String folderID, int flashcardIndex,
      BugReportComment bugReportComment) async {
    await collectionOfComments
        .doc(folderID)
        .collection(flashcardIndex.toString())
        .doc(bugReportComment.bugReportCommentID)
        .delete();
  }
}
