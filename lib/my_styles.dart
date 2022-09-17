import 'package:flutter/material.dart';

class myStyles {
  static const letters = TextStyle(
    fontSize: 50,
    color: Colors.brown,
  );
  static const title = TextStyle(
    fontSize: 25,
  );
  static const words = TextStyle(
    fontSize: 35,
    color: Colors.brown,
  );
  static const dialogTitle = TextStyle(
    fontSize: 40,
    color: Colors.brown,
  );
  static const btnText = TextStyle(
    fontSize: 20,
    // color: Colors.brown,
  );
  static final btn = ButtonStyle(
    minimumSize: MaterialStateProperty.all( Size(90, 50)),

  );
  static const tray = BoxDecoration(
    // image: DecorationImage(image: AssetImage("assets/tray1.jpg"))
  );
  static const glow = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(18.0),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.pink,
          spreadRadius: 4,
          blurRadius: 10,
        ),
        BoxShadow(
          color: Colors.pink,
          spreadRadius: -4,
          blurRadius: 5,
        )
      ]);

  // static const glow2 =
}
