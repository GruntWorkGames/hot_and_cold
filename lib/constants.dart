import 'package:flutter/material.dart';

class Constants {
  static const backgroundColor = Colors.blue;
  static final mainTheme = ThemeData(

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.transparent;
        }),
        backgroundColor: MaterialStateProperty.all(Colors.orange)
        ), 
      ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.orange,
        fontSize: 42,
      ),
      headlineMedium: TextStyle(
        color: Colors.blue,
        fontSize: 36
      )
    ),

    textButtonTheme: const TextButtonThemeData(),
    iconButtonTheme: const IconButtonThemeData(),
    iconTheme: const IconThemeData(),
    actionIconTheme: const ActionIconThemeData(),
    inputDecorationTheme: const InputDecorationTheme()
  );
}