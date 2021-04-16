import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ielts_essay/Model/AnswerModel.dart';
import 'package:ielts_essay/Model/EssayTypeModel.dart';
import 'package:ielts_essay/Model/QuestionModel.dart';
import 'package:ielts_essay/Model/SuggestionModel.dart';

Future<EssayModel> loadEssayData() async {
  final data = await rootBundle.loadString("assets/data.json");
  // print(data);
  return essayModelFromJson(data);
}

EssayModel essayModelFromJson(String str) => EssayModel.fromJson(json.decode(str));

String essayModelToJson(EssayModel data) => json.encode(data.toJson());

class EssayModel {
  EssayModel({
    this.question,
    this.answer,
    this.essayType,
    this.suggestion,
  });

  List<QuestionModel> question;
  List<AnswerModel> answer;
  List<EssayTypeModel> essayType;
  List<SuggestionModel> suggestion;

  factory EssayModel.fromJson(Map<String, dynamic> json) => EssayModel(
    question: List<QuestionModel>.from(json["question"].map((x) => QuestionModel.fromJson(x))),
    answer: List<AnswerModel>.from(json["answer"].map((x) => AnswerModel.fromJson(x))),
    essayType: List<EssayTypeModel>.from(json["essay_type"].map((x) => EssayTypeModel.fromJson(x))),
    suggestion: List<SuggestionModel>.from(json["suggestion"].map((x) => SuggestionModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "question": List<dynamic>.from(question.map((x) => x.toJson())),
    "answer": List<dynamic>.from(answer.map((x) => x.toJson())),
    "essay_type": List<dynamic>.from(essayType.map((x) => x.toJson())),
    "suggestion": List<dynamic>.from(suggestion.map((x) => x.toJson())),
  };
}