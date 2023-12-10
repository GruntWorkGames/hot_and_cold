import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hot_and_cold/components/game_component.dart';
import 'package:hot_and_cold/view/gui.dart';

class GameView extends ConsumerWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = GameComponent();
    final gameWidget = GameWidget(game: game);
    final stack = Stack(children: [gameWidget, const Gui()]);
    return Scaffold(
      body: stack, 
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.withOpacity(0.4),
      ), 
    );
  }
}