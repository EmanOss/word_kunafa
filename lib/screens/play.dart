import 'package:flutter/material.dart';
import 'dart:convert';
import 'my_home.dart';
import 'package:flutter/services.dart' as rootBundle;

class PlayScreen extends StatefulWidget {
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _myStyles {
  static final letters = TextStyle(
    fontSize: 50,
    color: Colors.brown,
  );
  static final title = TextStyle(
    fontSize: 25,
  );
}

class level {
  //data Type
  // int? number;
  List<String>? letters;
  List<String>? correct;
  List<String>? bonus;
  // String? letters;
  // String? correct;
  // String? bonus;

// constructor
  level({this.letters, this.correct, this.bonus});

  //method that assign values to respective datatype vairables
  level.fromJson(Map<String, dynamic> json) {
    // number = json['id'];
    letters = json['letters'];
    correct = json['correct'];
    bonus = json['bonus'];
  }
}

class _PlayScreenState extends State<PlayScreen> {
  String _word = "";

  // List<String> _correct = [];

  void _addLetter(String c) {
    setState(() {
      _word += c;
    });
  }

  void _back() {
    Navigator.pop(context);
  }

  Future<List<level>> ReadJsonData() async {
    //read json file
    final jsondata =
        await rootBundle.rootBundle.loadString('data_repo/levels.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => level.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
            child: Text(
          "مستوى 1",
          style: _myStyles.title,
        )),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
                child: FutureBuilder(
              future: ReadJsonData(),
              builder: (context, data) {
                if (data.hasError) {
                  //in case if error found
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  //once data is ready this else block will execute
                  // items will hold all the data of DataModel
                  //items[index].name can be used to fetch name of product as done below
                  var items = data.data as List<level>;
                  return Expanded(
                    child: SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                          itemCount: items == null ? 0 : items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: ListView.builder(
                                                padding: const EdgeInsets.all(8),
                                                itemCount: items[index].letters?.length,
                                                itemBuilder: (BuildContext context, int i) {
                                                  return Container(
                                                    child: Center(child: Text('Entry ${items[index].letters![i]}')),
                                                  );
                                                }
                                            )
                                            // Text(
                                            //   items[index].letters.toString(),
                                            //   style: const TextStyle(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(
                                          //       left: 8, right: 8),
                                          //   child: Text(
                                          //     items[index].correct.toString(),
                                          //     style: const TextStyle(
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(
                                          //       left: 8, right: 8),
                                          //   child: Text(
                                          //     items[index].bonus.toString(),
                                          //     style: const TextStyle(
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                } else {
                  // show circular progress while data is getting fetched from json file
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
                // Text(_correct, style: _myStyles.title,),
                ),
            Text(
              _word,
              style: _myStyles.letters,
            ),
            Row(
              children: [
                const Spacer(flex: 1),
                // Column(
                //   children: [],
                // ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _addLetter("ر"),
                      child: Text(
                        "ر",
                        style: _myStyles.letters,
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: [],
                // ),
                const Spacer(flex: 1),
              ],
            ),
            Row(
              children: [
                const Spacer(flex: 1),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _addLetter("ت"),
                      child: Text("ت", style: _myStyles.letters),
                    ),
                  ],
                ),
                // Column(
                //   children: [Text("")],
                // ),
                const Spacer(flex: 1),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _addLetter("م"),
                      child: Text("م", style: _myStyles.letters),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
              ],
            ),
            // const Spacer(flex: 1),
            ElevatedButton(
                onPressed: () => setState(() {
                      _word = "";
                    }),
                child: const Icon(Icons.refresh)),
            ElevatedButton(
                onPressed: () => setState(() {
                      // if()
                      // _correct.add(_word);
                      _word = "";
                    }),
                child: const Icon(Icons.check)),
            // Text("مسح", style: _myStyles.title)),
          ],
        ),
      ),
    );
  }
}
