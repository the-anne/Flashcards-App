import 'package:cloud_firestore/cloud_firestore.dart';

class BugReportComment {
  String? bugReportCommentID;
  String commentText;
  String authorsEmail;
  Timestamp dateOfSubmission;
  // String flashcardSetID;
  // String flashcardIndexInSet;

  BugReportComment({
    this.bugReportCommentID,
    required this.commentText,
    required this.authorsEmail,
    required this.dateOfSubmission,
  });

  factory BugReportComment.fromSnapshot(QueryDocumentSnapshot? snapshot) {
    final newBugComment =
        BugReportComment.fromJson(snapshot?.data() as Map<String, dynamic>);
    newBugComment.bugReportCommentID = snapshot?.reference.id;
    return newBugComment;
  }

  factory BugReportComment.fromJson(Map<String, dynamic> json) =>
      _bugReportCommentFromJson(json);

  Map<String, dynamic> toJson() => _bugReportCommentToJson(this);

  @override
  String toString() => 'BugReportComment<$commentText>';
}

BugReportComment _bugReportCommentFromJson(Map<String, dynamic> json) {
  return BugReportComment(
    commentText: json['commentText'] as String,
    authorsEmail: json['authorsEmail'] as String,
    dateOfSubmission: json['dateOfSubmission'] as Timestamp,
  );
}

Map<String, dynamic> _bugReportCommentToJson(BugReportComment instance) =>
    <String, dynamic>{
      'commentText': instance.commentText,
      'authorsEmail': instance.authorsEmail,
      'dateOfSubmission': instance.dateOfSubmission,
    };
