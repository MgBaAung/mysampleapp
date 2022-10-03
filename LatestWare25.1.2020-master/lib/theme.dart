import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Lato',
    scaffoldBackgroundColor: Colors.grey.shade200,
    cardTheme: CardTheme(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 17),
        minimumSize: Size(100, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 17),
        minimumSize: Size(100, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Lato',
      cardTheme: CardTheme(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 17),
          minimumSize: Size(100, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 17),
          minimumSize: Size(100, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
}
