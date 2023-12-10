import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:hot_and_cold/components/player.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/player_anim_state.dart';

class GameComponent extends FlameGame with HasKeyboardHandlerComponents {

  late final TiledComponent tiledmap;
  late final Player player;
  bool ignoreInput = false;

  @override 
  FutureOr<void> onLoad() async {
    await addTilemap();
    addTileAnimations();
    addPlayer();
    setupCamera();
    addKeyboardListeners();
  }

  void addPlayer() {
    player = Player();
    world.add(player);
    player.position = readSpawnPos();
  }

  void setupCamera() {
    camera.follow(player);
  }

  Future<void> addTilemap() async {
    tiledmap = await TiledComponent.load('map.tmx', Vector2(Constants.tilesize, Constants.tilesize));
    world.add(tiledmap);
  }

  void addTileAnimations() {
    
  }
  
  Vector2 readSpawnPos() {
    final objectGroup = tiledmap.tileMap. getLayer<ObjectGroup>('spawn');
    final spawnObject = objectGroup!.objects.first;
    return Vector2(spawnObject.x, spawnObject.y);
  }

   void addKeyboardListeners() {
    aDown(Set<LogicalKeyboardKey> keysPressed) { 
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkLeft);
      }
      return true; 
    }
    aUp(Set<LogicalKeyboardKey> keysPressed) {
      player.setAnimState(PlayerAnimState.idleLeft);
      return true; 
    }
    wDown(Set<LogicalKeyboardKey> keysPressed) {
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkUp);
      }
      return true; 
    }
    wUp(Set<LogicalKeyboardKey> keysPressed) {
      player.setAnimState(PlayerAnimState.idleUp);
      return true;
    }
    sDown(Set<LogicalKeyboardKey> keysPressed) {
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkDown);
      }
      return true; 
    }
    sUp(Set<LogicalKeyboardKey> keysPressed) { 
      player.setAnimState(PlayerAnimState.idleDown);
      return true; 
    }
    dDown(Set<LogicalKeyboardKey> keysPressed) {
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkRight);
      }
      return true; 
    }
    dUp(Set<LogicalKeyboardKey> keysPressed) {
      player.setAnimState(PlayerAnimState.idleRight);
      return true;
    }

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.keyA: aUp,
          LogicalKeyboardKey.keyD: dUp,
          LogicalKeyboardKey.keyW: wUp,
          LogicalKeyboardKey.keyS: sUp,
        },
        keyDown: {
          LogicalKeyboardKey.keyA: aDown,
          LogicalKeyboardKey.keyD: dDown,
          LogicalKeyboardKey.keyW: wDown,
          LogicalKeyboardKey.keyS: sDown,
        },
      ),
    );
  }
}