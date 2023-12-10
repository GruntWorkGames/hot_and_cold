import 'package:flutter/material.dart';

class Constants {
  static const tilesize = 64.0;

  static const color1 = Colors.deepOrange;
  static const color2 = Colors.blue;
  static const backgroundColor = Colors.blue;

  static final mainTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.transparent;
        }),
        backgroundColor: MaterialStateProperty.all(color1)
        ), 
      ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: color1,
        fontSize: 42,
      ),
      headlineMedium: TextStyle(
        color: color1,
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