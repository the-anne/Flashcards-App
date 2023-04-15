import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  UserInfo({
    required this.notKnownFlashcardSets,
    required this.usersEmail,
  });

  Map<String, List<int>> notKnownFlashcardSets;
  String usersEmail;
  String? userInfoID;

  factory UserInfo.fromSnapshot(QueryDocumentSnapshot? snapshot) {
    final newUser = UserInfo.fromJson(snapshot?.data() as Map<String, dynamic>);
    newUser.userInfoID = snapshot?.reference.id;
    return newUser;
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) => _userFromJson(json);
  Map<String, dynamic> toJson() => _userToJson(this);

  @override
  String toString() => 'User <$usersEmail>';
}

UserInfo _userFromJson(Map<String, dynamic> json) {
  return UserInfo(
    usersEmail: json['usersEmail'] as String,
    notKnownFlashcardSets: _convertUserInfo(json[
        'notKnownFlashcardSets']), // map: folderID : [..array of indices of unknown flashcards..]
  );
}

Map<String, List<int>> _convertUserInfo(Map<String, dynamic> userInfoMap) {
  final flashcards = <String, List<int>>{};
  for (var entry in userInfoMap.entries) {
    flashcards[entry.key] = [];
    for (int elem in entry.value) {
      flashcards[entry.key]?.add(elem);
    }
  }
  return flashcards;
}

Map<String, dynamic> _userToJson(UserInfo instance) => <String, dynamic>{
      'usersEmail': instance.usersEmail,
      'notKnownFlashcardSets': instance.notKnownFlashcardSets
    };
