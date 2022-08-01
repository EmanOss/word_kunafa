import 'package:flutter/material.dart';
import 'dart:convert';
import '../level.dart';
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
  static final words = TextStyle(
    fontSize: 25,
  );
}

class _PlayScreenState extends State<PlayScreen> {
  String _word = "";
  List<String> _solved = [];
  List<String> _solvedBonus = [];
  int _currLevel=1;
  // List<String> currCorrect=[];
  // List<String> currBonus=[];
  // List<String> currLetters=[];
  List<level> allLevels=[];

  void _addLetter(String c) {
    setState(() {
      _word += c;
    });
  }
  void _clearWord() {
    setState(() {
      _word ="";
    });
  }
  int _checkWord(String w){
    //retuns 1 if word is correct, 2 if it's in the bonus list, 0 if it's wrong
    return(allLevels[_currLevel].correct!.contains(w))?
    1: (allLevels[_currLevel].bonus!.contains(w))? 2:0;
  }
  void _addSolvedWord(String w) {
    int check = _checkWord(w);
    if(check==1) {
      setState(() {
        _solved.add(w);
      });
      _clearWord();
    }
    else
    if(check==2) {
      setState(() {
        _solvedBonus.add(w);
      });
      _clearWord();
    }
    else {
      //err
    }
  }

  void _back() {
    Navigator.pop(context);
  }


  Future<List<level>> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.rootBundle.loadString('data_repo/levels.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;
    //map json and initialize using DataModel
    var res = list.map((e) => level.fromJson(e)).toList();
    setState(() {
      allLevels = res;
    });
    return res;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
            child: Text(
              (_currLevel+1).toString()+" مستوى ",
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
                      // print("items hena");
                      // print(items[2].letters);
                      return Flex(direction: Axis.horizontal,
                        children: [ Expanded(
                          child: SizedBox(
                            height: 200.0,
                            child: ListView.builder(
                                itemCount: items == null ? 0 : items.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      child:Container(
                                        height: 200.0,
                                        width: 300.0,
                                        child:  Expanded(
                                          child:  ListView.builder(
                                              itemCount: items.length,
                                              itemBuilder: (context, index){
                                                return Card(child:
                                                Padding(padding: const EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children:
                                                      items[_currLevel].correct!.map<Card>((s) =>
                                                          Card(child:Center(child:Text(s, style: _myStyles.words,),))).toList(),
                                                      // Text(items[index].letters![0]),
                                                    )));
                                              }),),)
                                  );
                                }),
                          ),
                        )
                        ],);
                    } else {
                      // show circular progress while data is getting fetched from json file
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
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
            ElevatedButton(
                onPressed: () => _clearWord(),
                child: const Icon(Icons.refresh)),
            ElevatedButton(
                onPressed: () => _addSolvedWord(_word),
                child: const Icon(Icons.check)),
          ],
        ),
      ),
    );
  }
}
