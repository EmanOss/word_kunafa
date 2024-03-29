import 'dart:io';
import 'dart:math';
// import 'package:audioplayers/audioplayers.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wiredash/wiredash.dart';
import 'package:word_kunafa/DictionaryModel.dart';
import 'package:word_kunafa/wordFile.dart';
import 'dart:convert';
import '../SwipePainter.dart';
import '../api_service.dart';
import '../area.dart';
import '../level.dart';
import '../wordFile.dart';
import '../my_styles.dart';
import 'end_screen.dart';
import 'my_home.dart' as home;
import 'package:flutter/services.dart' as rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'package:percent_indicator/percent_indicator.dart';


class PlayScreen extends StatefulWidget {
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  String _word = "";
  int winLength =6;
  List<String> _solved = [];
  int _currLevel=0;
  List<level> allLevels=[];
  late AnimationController _controller;
  late Animation<double> anim;
  late Future<List<level>> _myJsonData;
  late List<GlobalKey> letterKeys=[];
  late List<area> letterAreas =[];
  late List<Offset> _myPoints = [];
  late List<Offset> _vertices = [];
  bool levelDone = false;
  final _confettiController = ConfettiController();
  late Map<String,dynamic> wordDefs ={};
  late List<dynamic> allWords=[];
  final GlobalKey mailKey = GlobalKey(), hintKey = GlobalKey(), swipeKey= GlobalKey();
  // late final prefs;
  late bool shownTut;
  // final player = AudioPlayer();                   // Create a player

  final correctAudio = AudioPlayer();
  bool muted = false;

  void _addLetter(String c, double x, double y) {
    if(!(_word.contains(c))){
      setState(() {
        _word += c;
        _vertices.add(Offset(x,y));
      });
    }
  }
  void _clearWord() {
    setState(() {
      _word ="";
    });
  }
  bool _checkWord(String w){
    _checkWord2(w);
    return allLevels[_currLevel].correct!.contains(w) && !_solved.contains(w);
  }
  Future<void> _addSolvedWord(String w, BuildContext c) async {
    _clearWord();
    // print(sound);
    if(_checkWord(w)) {
      if(!muted)
        correctAudio.play();
      // await correctAudio.stop();
      setState(() {
        _solved.add(w);
      });
      if(_solved.length == winLength)
        _endLevel(c);
    }

  }
  void _endLevel(BuildContext c){
    _confettiController.play();
    setState(() {levelDone = true;});
    // showDialog(context: c,
    //     builder: (_)=>
    //         AlertDialog(contentPadding:EdgeInsets.all(20),
    //           title: Center(heightFactor: 1,
    //               child:Text("تهانينا", style: myStyles.dialogTitle,)),
    //           content: Center(heightFactor: 1,
    //               child:Text("لقد تخطيت المرحلة")),
    //           actions: [Center(heightFactor: 1,
    //               child:ElevatedButton(
    //             onPressed: () => _nextLevel(),
    //             child: Text("التالي",style: myStyles.btnText,))), ],));
    // Navigator.pop(context);
  }
  Future<void> _nextLevel() async {
    if(_currLevel+1 < allLevels.length){
      final prefs = await SharedPreferences.getInstance();
      _confettiController.stop();
      setState(() {
        prefs.setInt('currLevel', _currLevel+1);
        _currLevel = prefs.getInt('currLevel')?? 0;
        // _currLevel++;
        _solved = [];
        _word = "";
        letterKeys = [];
        _initKeys();
        letterAreas = [];
        levelDone=false;
      });
    }
    else{
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => endScreen()));
    }
  }
  void _checkReset(){
    showDialog(context: context, builder: (_)=>
        AlertDialog(
          content: Directionality(textDirection: TextDirection.rtl,
              child:Text('هل أنت متأكد من العودة لأول مستوى؟')),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: ()=>{Navigator.pop(context)},
                child:Text('لا'), style:myStyles.smallBtn),
            ElevatedButton(
                onPressed: ()=>{_resetGame()},
                child:Text('نعم') , style:myStyles.smallBtn),
          ],
        ));
  }
  Future<void> _resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    _confettiController.stop();
    setState(() {
      prefs.setInt('currLevel', 0);
      _currLevel=0;
      _solved=[];
      _word="";
      letterKeys=[];
      _initKeys();
      letterAreas=[];
      levelDone=false;
    });
    Navigator.pop(context);
  }
  void _settings(){
    showDialog(context: context, builder: (_)=> 
        AlertDialog(
          title: Center(heightFactor: 1,
            child:Text("إعدادات", style: myStyles.dialogTitle,)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: ()=>{_checkReset()},
                child:const Icon(Icons.refresh, size: 30,)),
            ElevatedButton(
              onPressed: () => setState(() {
                Navigator.pop(context);
                ShowCaseWidget.of(context)!.startShowCase([swipeKey, hintKey, mailKey]);
              }),
              child: const Icon(Icons.help_outline, size: 30,),),],));
  }
  void _showLetter() {
      List? curr = allLevels[_currLevel].correct;
      Random random = new Random();
      int i = random.nextInt(curr!.length);
      while (_solved.contains(curr[i])) {
        random.nextInt(curr.length);
      }
      setState(() {
        _word = curr[i][0];
      });
      Navigator.pop(context);
  }
  void _hint(){
    showDialog(context: context, builder: (_)=>
        AlertDialog(
          title: Center(heightFactor: 1,
              child:Text("مساعدة", style: myStyles.dialogTitle,)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(onPressed: ()=>{_showLetter()},
                child: Text("إظهار أول حرف", style: myStyles.btnText), ),
          ],));
  }
  void _back() {
    Navigator.pop(context);
  }
  void _initKeys() {
    for(int i=0; i<allLevels[_currLevel].letters!.length;i++){
      letterKeys.add(GlobalKey());
    }
  }
  @override
  void initState() {
    super.initState();
    _initLevel();
    _initAudio();
    _myJsonData = ReadJsonData();
    collectDictionary();
    //animation section
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
    _showTut();
  }
  Future<void> _showTut() async {
    final prefs= await SharedPreferences.getInstance();
    setState(() {
      shownTut = prefs.getBool('shownTut')?? false;
    });
    if(!shownTut){
      WidgetsBinding.instance!.addPostFrameCallback(
            (_) => ShowCaseWidget.of(context)!.startShowCase(
          [swipeKey, hintKey, mailKey],),);
      setState(() {
        shownTut=true;
        prefs.setBool('shownTut', true);
      });
    }

  }
  Future<void> _initLevel() async {
    setState(() async {
      final prefs = await SharedPreferences.getInstance();
      _currLevel = prefs.getInt('currLevel') ?? 0;
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
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
    _initKeys();
    return res;
  }
  void _getWidgetInfo() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for(int i=0;i<allLevels[_currLevel].letters!.length;i++){
          final RenderBox renderBox = letterKeys[i].currentContext?.findRenderObject() as RenderBox;
          double w = renderBox.size.width;
          double h = renderBox.size.height;
          double x1 = renderBox.localToGlobal(Offset.zero).dx;
          double y1 = renderBox.localToGlobal(Offset.zero).dy;
          letterAreas.add(area(x1,x1+w,y1,y1+h));
          // print(x1.toString() +"  "+ (x1+w).toString() +"  "+y1.toString()+"  "+(y1+h).toString());
        }});
  void _bugReport(){
    Wiredash.of(context).show(inheritMaterialTheme: true);
  }
  Future<void> _initAudio() async {
    await correctAudio.setUrl('assets/audio/correct1.mp3');
  }

  late DictionaryModel? _wordModel;
  Future<bool?> _checkWord2(String word) async {
    print(allWords.contains(word));
    return allWords.contains(word);
  }
  Future<void> collectDictionary() async {
    //without defs, the json is a big list and just do .contains
    final jsondata1 = await rootBundle.rootBundle.loadString('assets/words.json');
    setState((){
      allWords = jsonDecode(jsondata1);
    });
    // allWords.contains();

    //with defs -KEEP - todo decide how to do this
    // final jsondata = await rootBundle.rootBundle.loadString('assets/wordsDef.json');
    // List<dynamic> p = jsonDecode(jsondata) as List<dynamic>;
    // var defs = p.map((e) => wordFile.fromJson(e)).toList();
    // for(var w in defs){
    //   setState(() {
    //     wordDefs[w.word!]=w.def;
    //   });
    // }
    // print(newDefs.containsKey('إنتظر'));
  }

  @override
  Widget build(BuildContext context) {
    if(letterAreas.length==0)_getWidgetInfo();
    return Stack(children: [CustomPaint(
        foregroundPainter: SwipePainter(_myPoints, _vertices),
        child: Scaffold(
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
            Showcase(
                key:mailKey,
                description:'اضغط هنا لإضافة تعليق أو للابلاغ عن مشكلة',
                child:IconButton(onPressed:()=> _bugReport(),
                icon:const Icon(Icons.email, size:25,))),
            Showcase(
                key:hintKey,
                description:'اضغط هنا للحصول على مساعدة',
                // disposeOnTap: true,
                // onTargetClick: () {_hint();
                // setState(() {ShowCaseWidget.of(context)!.startShowCase([mailKey]);});},
                child:IconButton(onPressed:()=> _hint(),
                icon:const Icon(Icons.lightbulb, size:25,))),
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
          SizedBox(
            height: 30,
            width: 300,
            child:LinearPercentIndicator(
            // width: 200.0,
            barRadius: Radius.circular(10),
            lineHeight: 20.0,
            // center: Text((_solved.length).toString() +' / 5',
            //   style: TextStyle(color: Colors.white),
            // ),
            percent: _solved.length/winLength,
            progressColor: Colors.teal,
            ),),
          Directionality(
            textDirection: TextDirection.rtl,
            child:Container(height: 200, decoration: myStyles.tray,
                  child:GridView.count(
                    crossAxisCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _solved.map<Container>((s) =>Container(alignment: Alignment.topCenter,
                          child:Text(s, style: myStyles.words,),)).toList(),),)),
            // AnimatedBuilder(
            //     builder: (context, child) {
            //       return Transform.translate(
            //         offset: Offset(anim.value,1),
            //         child: Container(height: 100,
            //           child:Text(_word,style: myStyles.letters,),),
            //       );
            //     },
            //     animation: _controller, //Tween(begin: 0, end: 2*pi).animate(_controller),
            //     child://Container(child:Text("HI")),
                Container(height: 100, child:Text(
                  _word,style: myStyles.letters,),),
            // ),
            Showcase(
                key:swipeKey,
                description:'اسحب الحروف لتكون كلمات',
                child:FutureBuilder(
              // key: letterKeys,
              future: _myJsonData,
              builder: (context, data) {
                if (data.hasError) {
                  //in case if error found
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  //once data is ready this else block will execute
                  // items will hold all the data of DataModel
                  //items[index].name can be used to fetch name of product as done below
                  // var items = data.data as List<level>;
                  return Directionality(
                      textDirection: TextDirection.rtl,
                      child:Flex(direction: Axis.horizontal,
                        children: [ Expanded(
                              child: SizedBox(
                                      height: 220,
                                      width: 50,
                                      child: GridView.builder(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2 / 1),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: allLevels[_currLevel].letters!.length,
                                        itemBuilder: (context, index) {
                              return Container(alignment: Alignment.topCenter,
                                  child:GestureDetector(
                                    key: letterKeys[index],
                                    onPanStart: (DragStartDetails d){
                                      _addLetter(allLevels[_currLevel].letters![index],letterAreas[index].cx, letterAreas[index].cy);
                                      // print('cx '+ letterAreas[index].x1.toString()+', '+ letterAreas[index].x2.toString()+' '+letterAreas[index].cx.toString());
                                      // print('cy '+ letterAreas[index].y1.toString()+', '+ letterAreas[index].y2.toString()+' '+letterAreas[index].cy.toString());
                                      setState(() {_myPoints.add(Offset(d.globalPosition.dx,d.globalPosition.dy));});
                                    },
                                    onPanUpdate:(DragUpdateDetails dd){
                                      for(int i=0; i<letterAreas.length;i++){
                                        if(letterAreas[i].overlaps(dd.globalPosition.dx, dd.globalPosition.dy)){
                                            _addLetter(allLevels[_currLevel].letters![i],letterAreas[i].cx, letterAreas[i].cy);
                                        }}
                                      setState(() {_myPoints.add(Offset(dd.globalPosition.dx,dd.globalPosition.dy));});
                                      },
                                    onPanEnd:(DragEndDetails d){
                                      _addSolvedWord(_word, context); _clearWord();
                                      setState(() {_myPoints=[]; _vertices=[];});
                                      },
                                        child:Text(allLevels[_currLevel].letters![index], style: myStyles.letters,)
                                  )
                              );},)
                    )) ],));
                }
                else {
                  // show circular progress while data is getting fetched from json file
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
            if(levelDone)
            ElevatedButton(
                style: myStyles.btn,
                onPressed: () => (_nextLevel()),
                child: const Icon(
                  Icons.arrow_back,
                  size: 35,
                )),],
        ),
      ),
    )),
        ConfettiWidget(
        confettiController: _confettiController,
        shouldLoop: true,
        blastDirectionality: BlastDirectionality.explosive,
        // blastDirection: ,
        colors: const [Colors.teal, Colors.grey]),
    ]);
  }
}
