import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_kunafa/my_styles.dart';
import 'package:word_kunafa/screens/play.dart';

class endScreen extends StatelessWidget {
  const endScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void restartGame(){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PlayScreen()));
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(" ! لقد أنهيت كل المراحل", style: myStyles.words,),
            ElevatedButton(
                onPressed: ()=>{restartGame()},
                child: const Icon(Icons.refresh, size: 25,))
          ],
        ),
      ),
    );
  }
}
