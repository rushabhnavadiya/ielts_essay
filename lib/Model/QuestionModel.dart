import 'dart:convert';

QuestionModel questionFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel{
  String id;
  String typeId;
  String question;
  String isFavourite;
  String isSaved;

  QuestionModel({
    this.id,
    this.typeId,
    this.question,
    this.isFavourite,
    this.isSaved,
  });
  factory QuestionModel.fromJson(Map<String, dynamic> json) =>QuestionModel(
      id: json["id"],
      typeId: json["type_id"],
      question: json["question"],
      isFavourite: json["is_fav"],
      isSaved: json["is_save"]
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "type_id": typeId,
      "question": question,
      "is_fav": isFavourite??'0',
      "is_save": isSaved??'0',
  };
}