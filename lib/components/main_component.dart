import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:hot_and_cold/components/player.dart';
import 'package:hot_and_cold/components/square.dart'as my;
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/player_anim_state.dart';
import 'package:hot_and_cold/model/tile.dart';

class MainComponent extends FlameGame
  with HasKeyboardHandlerComponents, MouseMovementDetector, TapCallbacks {

  late final TiledComponent tiledmap;
  late final Player player;
  bool ignoreInput = false;
  final List<Tile> rocks = [];
  final List<Tile> iceCubes = [];
  final square = my.Square(BasicPalette.green);

  @override 
  FutureOr<void> onLoad() async {
    await addTilemap();
    addPlayer();
    setupCamera();
    addKeyboardListeners();
    world.add(square);
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

  Vector2 readSpawnPos() {
    final objectGroup = tiledmap.tileMap. getLayer<ObjectGroup>('spawn');
    final spawnObject = objectGroup!.objects.first;
    return Vector2(spawnObject.x, spawnObject.y);
  }

  void addKeyboardListeners() {
    aDown(Set<LogicalKeyboardKey> keysPressed) { 
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkLeft);
      }
      return true; 
    }
    aUp(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleLeft);
      return true; 
    }
    wDown(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkUp);
      }
      return true; 
    }
    wUp(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleUp);
      return true;
    }
    sDown(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkDown);
      }
      return true; 
    }
    sUp(Set<LogicalKeyboardKey> keysPressed) { 
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleDown);
      return true; 
    }
    dDown(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkRight);
      }
      return true; 
    }
    dUp(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = false;
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

 @override
  void onMouseMove(PointerHoverInfo info) {
    final tile = TilePos.fromVector(camera.globalToLocal(info.eventPosition.global));
    tile.set(tile.x, tile.y-1);
    square.position = tile.vector;

    if(isValidSpot(tile)) {
      square.palette = BasicPalette.green;
    } else {
      square.palette = BasicPalette.red;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    // final tile = TilePos.fromVector(camera.globalToLocal(event.localPosition));
    // final square = my.Square(BasicPalette.red);
    // square.position = tile.vector;
    // world.add(square);
  }
  
  bool isValidSpot(TilePos tile) {
    return false;
  }
}