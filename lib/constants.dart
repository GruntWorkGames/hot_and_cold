import 'package:flutter/material.dart';

class Constants {
  static const backgroundColor = Color.fromARGB(255, 50, 39, 80);
  static final mainTheme = ThemeData(

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.transparent;
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.grey;
        }),
      )
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.blue,
        fontSize: 42,
      ),
      headlineMedium: TextStyle(
        color: Colors.amber,
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