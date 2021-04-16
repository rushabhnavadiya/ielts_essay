import 'dart:convert';

EssayTypeModel essayTypeFromJson(String str) => EssayTypeModel.fromJson(json.decode(str));

String essayTypeToJson(EssayTypeModel data) => json.encode(data.toJson());

class EssayTypeModel {
  EssayTypeModel({
    this.id,
    this.type,
    this.description,
  });

  String id;
  String type;
  String description;

  factory EssayTypeModel.fromJson(Map<String, dynamic> json) => EssayTypeModel(
    id: json["id"],
    type: json["type"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "description": description == null ? null : description,
  };
}