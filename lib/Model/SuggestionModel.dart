import 'dart:convert';

SuggestionModel suggestionFromJson(String str) => SuggestionModel.fromJson(json.decode(str));

String suggestionToJson(SuggestionModel data) => json.encode(data.toJson());

class SuggestionModel {
  SuggestionModel({
    this.id,
    this.answerId,
    this.question,
    this.suggestion,
    /*this.isFavourite,
    this.isSaved,*/
  });

  String id;
  String answerId;
  String question;
  String suggestion;
  /*String isFavourite;
  String isSaved;*/

  factory SuggestionModel.fromJson(Map<String, dynamic> json) => SuggestionModel(
    id: json["id"],
    answerId: json["answer_id"],
    question: json["question"],
    suggestion: json["suggestion"],
    /*isFavourite: json["is_fav"],
    isSaved: json["is_save"]*/
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "answer_id": answerId,
    "question": question,
    "suggestion": suggestion,
    /*"is_fav": isFavourite,
    "is_save": isSaved*/

  };
}