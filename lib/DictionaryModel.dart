// To parse this JSON data, do
//
//     final dictionaryModel = dictionaryModelFromJson(jsonString);

import 'dart:convert';

DictionaryModel dictionaryModelFromJson(String str) => DictionaryModel.fromJson(json.decode(str));

String dictionaryModelToJson(DictionaryModel data) => json.encode(data.toJson());

class DictionaryModel {
  DictionaryModel({
    required this.nResults,
    required this.pageNumber,
    required this.resultsPerPage,
    required this.nPages,
    required this.availableNPages,
    required this.results,
  });

  int nResults;
  int pageNumber;
  int resultsPerPage;
  int nPages;
  int availableNPages;
  List<Result> results;

  factory DictionaryModel.fromJson(Map<String, dynamic> json) => DictionaryModel(
    nResults: json["n_results"],
    pageNumber: json["page_number"],
    resultsPerPage: json["results_per_page"],
    nPages: json["n_pages"],
    availableNPages: json["available_n_pages"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "n_results": nResults,
    "page_number": pageNumber,
    "results_per_page": resultsPerPage,
    "n_pages": nPages,
    "available_n_pages": availableNPages,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.id,
    required this.language,
    required this.headword,
    this.senses,
  });

  String id;
  String language;
  Headword headword;
  List<Sense>? senses;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    language: json["language"],
    headword: Headword.fromJson(json["headword"]),
    senses: List<Sense>.from(json["senses"].map((x) => Sense.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language": language,
    "headword": headword.toJson(),
    "senses": List<dynamic>.from(senses!.map((x) => x.toJson())),
  };
  @override
  String toString() {
    return '{ id: ' + id.toString() + ', '
        +'\n language: ' + language.toString() + ', '
        +'\n headword: ' + headword.text + ', '
        +'\n senses: ' + senses.toString() +' }';

  }
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

  @override
  String toString() {
    return 'id: '+id+', definition: '+definition!;
  }
}






// // To parse this JSON data, do
// //
// //     final dictionaryModel = dictionaryModelFromJson(jsonString);
//
// import 'dart:convert';
//
// DictionaryModel dictionaryModelFromJson(String str) => DictionaryModel.fromJson(json.decode(str));
//
// String dictionaryModelToJson(DictionaryModel data) => json.encode(data.toJson());
//
// class DictionaryModel {
//   DictionaryModel({
//     required this.id,
//     required this.source,
//     required this.language,
//     this.version,
//     this.headword,
//     this.senses,
//   });
//
//   String id;
//   String source;
//   String language;
//   int? version;
//   Headword? headword;
//   List<Sense>? senses;
//
//   factory DictionaryModel.fromJson(Map<String, dynamic> json) => DictionaryModel(
//     id: json["id"],
//     source: json["source"],
//     language: json["language"],
//     version: json["version"],
//     headword: Headword.fromJson(json["headword"]),
//     senses: List<Sense>.from(json["senses"].map((x) => Sense.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "source": source,
//     "language": language,
//     "version": version,
//     "headword": headword!.toJson(),
//     "senses": List<dynamic>.from(senses!.map((x) => x.toJson())),
//   };
// }
//
// class Headword {
//   Headword({
//     required this.text,
//     this.pronunciation,
//     required this.pos,
//     this.gender,
//     this.alternativeScripts,
//     this.inflections,
//   });
//
//   String text;
//   Pronunciation? pronunciation;
//   String pos;
//   String? gender;
//   AlternativeScripts? alternativeScripts;
//   List<Inflection>? inflections;
//
//   factory Headword.fromJson(Map<String, dynamic> json) => Headword(
//     text: json["text"],
//     pronunciation: Pronunciation.fromJson(json["pronunciation"]),
//     pos: json["pos"],
//     gender: json["gender"],
//     alternativeScripts: AlternativeScripts.fromJson(json["alternative_scripts"]),
//     inflections: List<Inflection>.from(json["inflections"].map((x) => Inflection.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "text": text,
//     "pronunciation": pronunciation!.toJson(),
//     "pos": pos,
//     "gender": gender,
//     "alternative_scripts": alternativeScripts!.toJson(),
//     "inflections": List<dynamic>.from(inflections!.map((x) => x.toJson())),
//   };
// }
//
// class AlternativeScripts {
//   AlternativeScripts({
//     this.arabic,
//   });
//
//   String? arabic;
//
//   factory AlternativeScripts.fromJson(Map<String, dynamic> json) => AlternativeScripts(
//     arabic: json["arabic"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "arabic": arabic,
//   };
// }
//
// class Inflection {
//   Inflection({
//     this.text,
//     this.number,
//   });
//
//   String? text;
//   String? number;
//
//   factory Inflection.fromJson(Map<String, dynamic> json) => Inflection(
//     text: json["text"],
//     number: json["number"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "text": text,
//     "number": number,
//   };
// }
//
// class Pronunciation {
//   Pronunciation({
//     this.value,
//   });
//
//   String? value;
//
//   factory Pronunciation.fromJson(Map<String, dynamic> json) => Pronunciation(
//     value: json["value"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "value": value,
//   };
// }
//
// class Sense {
//   Sense({
//     required this.id,
//     this.synonyms,
//     this.antonyms,
//     this.translations,
//   });
//
//   String id;
//   List<String>? synonyms;
//   List<String>? antonyms;
//   Translations? translations;
//
//   factory Sense.fromJson(Map<String, dynamic> json) => Sense(
//     id: json["id"],
//     synonyms: List<String>.from(json["synonyms"].map((x) => x)),
//     antonyms: List<String>.from(json["antonyms"].map((x) => x)),
//     translations: Translations.fromJson(json["translations"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "synonyms": List<dynamic>.from(synonyms!.map((x) => x)),
//     "antonyms": List<dynamic>.from(antonyms!.map((x) => x)),
//     "translations": translations!.toJson(),
//   };
// }
//
// class Translations {
//   Translations({
//     this.de,
//   });
//
//   De? de;
//
//   factory Translations.fromJson(Map<String, dynamic> json) => Translations(
//     de: De.fromJson(json["de"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "de": de!.toJson(),
//   };
// }
//
// class De {
//   De({
//     required this.text,
//     this.gender,
//   });
//
//   String text;
//   String? gender;
//
//   factory De.fromJson(Map<String, dynamic> json) => De(
//     text: json["text"],
//     gender: json["gender"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "text": text,
//     "gender": gender,
//   };
// }
