import 'dart:convert';

AnswerModel answerFromJson(String str) => AnswerModel.fromJson(json.decode(str));

String answerToJson(AnswerModel data) => json.encode(data.toJson());

class AnswerModel {
  AnswerModel({
    this.id,
    this.questionId,
    this.isSuggestion,
    this.answer,
    /*this.isFavourite,
    this.isSaved,*/
  });

  String id;
  String questionId;
  String isSuggestion;
  String answer;
  /*String isFavourite;
  String isSaved;*/

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    id: json["id"],
    questionId: json["question_id"],
    isSuggestion: json["is_suggestion"],
    answer: json["answer"],
    /*isFavourite: json["is_fav"],
    isSaved: json["is_save"]*/
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_id": questionId,
    "is_suggestion": isSuggestion,
    "answer": answer,
    /*"is_fav": isFavourite,
    "is_save": isSaved*/
  };
}