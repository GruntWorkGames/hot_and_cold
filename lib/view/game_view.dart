import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_and_cold/components/main_component.dart';
import 'package:hot_and_cold/view/gui.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = MainComponent();
    final gameWidget = GameWidget(game: game);
    final stack = Stack(children: [gameWidget, const Gui()]);
    return Scaffold(
      body: stack, 
      appBar: AppBar(
      ), 
    );
  }
}