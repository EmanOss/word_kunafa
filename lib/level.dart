class level {
  //data Type
  List<dynamic>? letters;
  List<dynamic>? correct;
  // List<dynamic>? bonus;
// constructor
  level({this.letters, this.correct});

  //method that assign values to respective datatype vairables
  level.fromJson(Map<String, dynamic> json) {
    letters = List.from(json['letters']);
    correct = List.from(json['correct']);
    // bonus = List.from(json['bonus']);
  }
}