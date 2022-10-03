// To parse this JSON data, do
//
//     final dictionaryModel = dictionaryModelFromJson(jsonString);

import 'dart:convert';

List<DictionaryModel> dictionaryModelFromJson(String str) => List<DictionaryModel>.from(json.decode(str).map((x) => DictionaryModel.fromJson(x)));

String dictionaryModelToJson(List<DictionaryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DictionaryModel {
  DictionaryModel({
    required this.id,
    required this.language,
    this.headword,
    this.senses,
  });

  String id;
  String language;
  Headword? headword;
  List<Sense>? senses;

  factory DictionaryModel.fromJson(Map<String, dynamic> json) => DictionaryModel(
    id: json["id"],
    language: json["language"],
    headword: Headword.fromJson(json["headword"]),
    senses: List<Sense>.from(json["senses"].map((x) => Sense.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language": language,
    "headword": headword!.toJson(),
    "senses": List<dynamic>.from(senses!.map((x) => x.toJson())),
  };
}

class Headword {
  Headword({
    required this.text,
    required this.pos,
  });

  String text;
  String pos;

  factory Headword.fromJson(Map<String, dynamic> json) => Headword(
    text: json["text"],
    pos: json["pos"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "pos": pos,
  };
}

class Sense {
  Sense({
    required this.id,
    this.definition,
  });

  String id;
  String? definition;

  factory Sense.fromJson(Map<String, dynamic> json) => Sense(
    id: json["id"],
    definition: json["definition"] == null ? null : json["definition"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "definition": definition == null ? null : definition,
  };
}
