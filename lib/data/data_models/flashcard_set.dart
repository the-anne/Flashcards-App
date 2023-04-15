import 'package:cloud_firestore/cloud_firestore.dart';

import 'flashcard.dart';

class FlashcardSet {
  FlashcardSet(
      {required this.flashcards,
      required this.authorsEmail,
      // required this.authorsID,
      required this.foldersName,
      this.isPrivate = true});

  String? folderID;
  String foldersName;
  // String foldersDescription;
  List<Flashcard> flashcards;
  String authorsEmail;
  // String authorsID;
  bool isPrivate;

  factory FlashcardSet.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final newFlashcardSet =
        FlashcardSet.fromJson(snapshot.data() as Map<String, dynamic>);
    newFlashcardSet.folderID = snapshot.reference.id;
    return newFlashcardSet;
  }

  factory FlashcardSet.fromJson(Map<String, dynamic> json) =>
      _flashcardSetFromJson(json);
  // 7
  Map<String, dynamic> toJson() => _flashcardSetToJson(this);

  @override
  String toString() => 'Flashcard Set <$foldersName>';
}

FlashcardSet _flashcardSetFromJson(Map<String, dynamic> json) {
  return FlashcardSet(
    isPrivate: json['isPrivate'] as bool,
    authorsEmail: json['authorsEmail'] as String,
    foldersName: json['foldersName'] as String,
    flashcards: _convertFlashcards(json['flashcards'] as List<dynamic>),
  );
}

List<Flashcard> _convertFlashcards(List<dynamic> flashcardsMap) {
  final flashcards = <Flashcard>[];
  for (final flashcard in flashcardsMap) {
    flashcards.add(Flashcard.fromJson(flashcard as Map<String, dynamic>));
  }
  return flashcards;
}

// 3
Map<String, dynamic> _flashcardSetToJson(FlashcardSet instance) =>
    <String, dynamic>{
      'foldersName': instance.foldersName,
      'authorsEmail': instance.authorsEmail,
      'isPrivate': instance.isPrivate,
      // 'authorsID': instance.authorsID,
      'flashcards': _flashcardsList(instance.flashcards),
    };
// 4
List<Map<String, dynamic>>? _flashcardsList(List<Flashcard>? flashcards) {
  if (flashcards == null) {
    return null;
  }
  final flashcardsMap = <Map<String, dynamic>>[];
  for (var flashcard in flashcards) {
    flashcardsMap.add(flashcard.toJson());
  }
  return flashcardsMap;
}
