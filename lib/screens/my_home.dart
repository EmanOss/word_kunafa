// import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../my_styles.dart';
import 'package:word_kunafa/screens/play.dart';


class MyHome extends StatefulWidget {
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late bool muted = false;

  void _settings(){
    showDialog(context: context, builder: (_)=>
        AlertDialog(
          title: Center(heightFactor: 1,
              child:Text("إعدادات", style: myStyles.dialogTitle,)),
          actions: [
            Center(heightFactor: 1,
                child:Row(children:[
                  Spacer(flex: 2,),
                  ElevatedButton(onPressed: ()=>{_toggleSound()},
                      child: Icon((muted)? Icons.volume_off:Icons.volume_down, size: 25,)),
            //       Spacer(flex: 1,),
            //       ElevatedButton(
            //           onPressed: () => _nextLevel(),
            //           child: const Icon(Icons.arrow_forward, size: 25,)),
                  Spacer(flex: 2,),
                        ])),
          ],
        ));
  }
  void _toggleSound(){
    setState(() {
      muted=!muted;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _play(){
      Navigator.push(context,
          // MaterialPageRoute(builder: (context) => PlayScreen()));
      MaterialPageRoute(builder: (context) =>
          ShowCaseWidget(
        builder: Builder(
          builder: (context) => PlayScreen(),),
      ),));
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text( 'كنافة كلمات',
              style: myStyles.title,
            )),
        actions: [
          IconButton(onPressed:()=> _settings(),
              icon:const Icon(Icons.settings, size:25,)),
        ],
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: _play,
                child: Text("إبدأ", style: myStyles.title,))
            // ElevatedButton(
            //   child: Text("Play"),
            //   onPressed: _startGame,
            // ),
          ],
        ),
      ),
    );
  }
}