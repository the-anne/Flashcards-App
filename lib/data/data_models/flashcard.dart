enum FlashcardStatus { cardNotSeen, cardCorrect, cardFailed }

class Flashcard {
  int flashcardID;
  String native;
  String foreign;
  bool isMarkedAsWrong;
  FlashcardStatus statusOfTheCard = FlashcardStatus.cardNotSeen; // local

  Flashcard(
      {required this.native,
      required this.foreign,
      required this.flashcardID,
      this.isMarkedAsWrong = false});

  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _flashcardFromJson(json);

  Map<String, dynamic> toJson() => _flashcardToJson(this);

  @override
  String toString() => 'Flashcard<$native>';
}

Flashcard _flashcardFromJson(Map<String, dynamic> json) {
  return Flashcard(
    native: json['native'] as String,
    foreign: json['foreign'] as String,
    isMarkedAsWrong: json.containsKey('isMarkedAsNotKnown')
        ? json['isMarkedAsNotKnown']
        : false,
    flashcardID: json['flashcardID'] as int,
  );
}

Map<String, dynamic> _flashcardToJson(Flashcard instance) => <String, dynamic>{
      'native': instance.native,
      'foreign': instance.foreign,
      'isMarkedAsNotKnown': instance.isMarkedAsWrong,
      'flashcardID': instance.flashcardID,
    };
