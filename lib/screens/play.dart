import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../level.dart';
import '../my_styles.dart';
import 'my_home.dart';
import 'package:flutter/services.dart' as rootBundle;

class PlayScreen extends StatefulWidget {
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  String _word = "";
  List<String> _solved = [];
  int _currLevel=0;
  List<level> allLevels=[];
  late AnimationController _controller;
  late Animation<double> anim;
  late Future<List<level>> _myJsonData;

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
  bool _checkWord(String w){
    //retuns 1 if word is correct, 2 if it's in the bonus list, 0 if it's wrong
    return allLevels[_currLevel].correct!.contains(w) && !_solved.contains(w);
  }
  Future<void> _addSolvedWord(String w, BuildContext c) async {
    if(_checkWord(w)) {
      setState(() {
        _solved.add(w);
      });
      _clearWord();
      if(_solved.length == 5)
        _endLevel(c);
    }
    else {
      _controller.forward();
      await Future.delayed(Duration(seconds: 1));
      _controller.stop();
      _clearWord();
      }
  }
  void _endLevel(BuildContext c){
    showDialog(context: c,
        builder: (_)=>
            AlertDialog(contentPadding:EdgeInsets.all(20),
              title: Center(heightFactor: 1,
                  child:Text("تهانينا", style: myStyles.dialogTitle,)),
              content: Center(heightFactor: 1,
                  child:Text("لقد تخطيت المرحلة")),
              actions: [Center(heightFactor: 1,
                  child:ElevatedButton(
                onPressed: () => _nextLevel(),
                child: Text("التالي",style: myStyles.btnText,))), ],));
    // Navigator.pop(context);
  }
  void _nextLevel(){
    setState(() {
      _currLevel++;
      _solved=[];
      _word="";
    });
    Navigator.pop(context);
  }
  void _resetGame(){
    setState(() {
      _currLevel=0;
      _solved=[];
      _word="";
    });
    Navigator.pop(context);
  }
  void _settings(){
    showDialog(context: context, builder: (_)=> 
        AlertDialog(
          title: Center(heightFactor: 1,
            child:Text("إعدادات", style: myStyles.dialogTitle,)),
          actions: [
          Center(heightFactor: 1,
          child:Row(children:[
            Spacer(flex: 2,),
            ElevatedButton(onPressed: ()=>{_resetGame()},
                child: const Icon(Icons.refresh, size: 25,)),
            Spacer(flex: 1,),
            ElevatedButton(
                onPressed: () => _endLevel(context),
                child: const Icon(Icons.arrow_forward, size: 25,)),
            Spacer(flex: 2,),])),
          ],
        ));
  }
  void _showLetter() {
      List? curr = allLevels[_currLevel].correct;
      Random random = new Random();
      int i = random.nextInt(curr!.length);
      while (_solved.contains(curr[i])) {
        random.nextInt(curr.length);
      }
      _word = curr[i][0];
      Navigator.pop(context);
  }
  void _hint(){
    showDialog(context: context, builder: (_)=>
        AlertDialog(
          title: Center(heightFactor: 1,
              child:Text("مساعدة", style: myStyles.dialogTitle,)),
          actions: [
            Center(heightFactor: 1,
                child:Row(children:[
                  Spacer(flex: 2,),
                  ElevatedButton(onPressed: ()=>{_showLetter()},
                      child: Text("إظهار أول حرف")),
                  Spacer(flex: 2,),
                  ])),
          ],
        ));
  }

  void _back() {
    Navigator.pop(context);
  }
    void initState() {
    super.initState();
    _myJsonData = ReadJsonData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 70),
      vsync: this,
    );
    anim = Tween<double>(
      begin: 0,
      end: 7,
    ).animate(_controller)
      ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<level>> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.rootBundle.loadString('assets/levels.json');
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
              style: myStyles.title,
            )),
        leading: IconButton(onPressed:()=> _back(),
            icon:const Icon(Icons.arrow_back_ios, size:25,)),
        actions: [
          IconButton(onPressed:()=> _hint(),
              icon:const Icon(Icons.lightbulb, size:25,)),
          IconButton(onPressed:()=> _settings(),
          icon:const Icon(Icons.settings, size:25,)),
        ],
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
            Container(height: 200, decoration: myStyles.tray,
                  child:GridView.count(
                    crossAxisCount: 3,
                    children: _solved.map<Container>((s) =>Container(alignment: Alignment.topCenter,
                          child:Text(s, style: myStyles.words,),)).toList(),),),
            AnimatedBuilder(
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(anim.value,1),
                    child: Container(height: 100,
                      child:Text(_word,style: myStyles.letters,),),
                  );
                },
                animation: _controller, //Tween(begin: 0, end: 2*pi).animate(_controller),
                child://Container(child:Text("HI")),
                Container(height: 100, child:Text(
                  _word,style: myStyles.letters,),)
            ),
            FutureBuilder(
              future: _myJsonData,
              builder: (context, data) {
                if (data.hasError) {
                  //in case if error found
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  //once data is ready this else block will execute
                  // items will hold all the data of DataModel
                  //items[index].name can be used to fetch name of product as done below
                  var items = data.data as List<level>;
                  return Flex(direction: Axis.horizontal,
                    children: [ Expanded(
                      child: SizedBox(
                        height: 220,
                        width: 50,
                        child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio: 2/1,
                              children:
                            //   [
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            // GestureDetector(onTap: ()=> _addLetter(items[_currLevel].letters![0]),child:
                            // Container(alignment: Alignment.topCenter,child:Text( items[_currLevel].letters![0], style: myStyles.letters,),),),
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            //
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            //     Container(alignment: Alignment.topCenter,child:Text( items[_currLevel].letters![1], style: myStyles.letters,),),
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            //     Container(alignment: Alignment.topCenter,child:Text( items[_currLevel].letters![2], style: myStyles.letters,),),
                            //     Container(alignment: Alignment.topCenter,child:Spacer(),),
                            //   ]
                          items[_currLevel].letters!.map<Container>((s) =>
                              Container(alignment: Alignment.topCenter,
                                child:GestureDetector(onTap:()=>_addLetter(s),
                                    child:Text(s, style: myStyles.letters,)),)).toList(),
                        )
                      )
                    ) ],);
                }
                else {
                  // show circular progress while data is getting fetched from json file
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Spacer(flex: 2,),
              ElevatedButton(
                style: myStyles.btn,
                onPressed: () => _clearWord(),
                child: const Icon(Icons.delete, size:35,)),
            Spacer(flex:1),
            ElevatedButton(
                style: myStyles.btn,
                onPressed: () => _addSolvedWord(_word, context),
                child: const Icon(Icons.check, size: 35,)),
              Spacer(flex: 2,),
            ]),

          ],
        ),
      ),
    );
  }
}
