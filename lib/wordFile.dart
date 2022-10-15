class wordFile {
  //data Type
  String? word;
  String? def;
// constructor
  wordFile({this.word, this.def});

  //method that assign values to respective datatype variables
  wordFile.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    def = json['def'];
    // print(word);
    // print(def);
  }
}