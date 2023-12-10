import 'package:flutter/material.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/view/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const mainMenu = MainMenu();
  const scaffold = Scaffold(body: mainMenu);
  final app = MaterialApp(home: scaffold, theme: Constants.mainTheme);
  runApp(app);
}
