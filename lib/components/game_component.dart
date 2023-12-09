import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class GameComponent extends FlameGame {
  @override 
  FutureOr<void> onLoad() {
    final text = TextComponent(text: 'Hello World');
    text.position.x = size.x / 2;
    text.position.y = size.y / 2;
    add(text);
  }
}