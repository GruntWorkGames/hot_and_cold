import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:hot_and_cold/components/player.dart';
import 'package:hot_and_cold/components/square.dart'as my;
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/direction.dart';
import 'package:hot_and_cold/enum/player_anim_state.dart';
import 'package:hot_and_cold/model/tile.dart';

class MainComponent extends FlameGame
  with HasKeyboardHandlerComponents, MouseMovementDetector, TapCallbacks {

  late final TiledComponent tiledmap;
  late final Player player;
  late final Rect land;
  late final Rect goal;

  bool ignoreInput = false;
  final List<TilePos> rocks = [];
  final List<TilePos> iceCubes = [];
  final square = my.Square(BasicPalette.green);

  @override 
  FutureOr<void> onLoad() async {
    await addTilemap();
    addPlayer();
    loadLayerObjects();
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
    // final r = tiledmap.toRect().toFlameRectangle();
    final x = 0;
    final y = 0;

    final endX = 1024.0;
    final endY = 1024.0;

    final Rectangle r = Rectangle.fromLTWH(500, 300, endX/2, endY/2);
    
    
    camera.viewport = FixedSizeViewport(Constants.tilesize * 16, Constants.tilesize * 16);
    camera.setBounds(r, considerViewport: true);
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
    final tile = TilePos.fromVector(camera.globalToLocal(event.localPosition));
    if(isValidSpot(tile)) {
      // final square = my.Square(BasicPalette.blue);
      // square.position = tile.vector;
      // world.add(square);
      player.jumpToTile(tile);
    }
  }

  void loadLayerObjects() {
    final landGroup = tiledmap.tileMap.getLayer<ObjectGroup>('land');
    final landObj = landGroup?.objects.first;
    land = Rect.fromLTWH(landObj!.x, landObj.y, landObj.width, landObj.height); 

    final goalGroup = tiledmap.tileMap.getLayer<ObjectGroup>('goal');
    final goalObj = goalGroup?.objects.first;
    goal = Rect.fromLTWH(goalObj!.x, goalObj.y, goalObj.width, goalObj.height); 

    final rockGroup = tiledmap.tileMap.getLayer<ObjectGroup>('rock');
    for(final rockObj in rockGroup!.objects) {
      rocks.add(TilePos.fromVector(Vector2(rockObj.x, rockObj.y)));
      print('rock added: ${rockObj.x}, ${rockObj.y}');
    }
  }
  
  bool isValidSpot(TilePos tile) {
    if(goal.containsPoint(tile.vector)) {
      return true;
    }

    if(rocks.where((rock) => rock.x == tile.x && rock.y == tile.y).toList().isNotEmpty) {
      return true;
    }
    
    if(iceCubes.where((ice) => ice.x == tile.x && ice.y == tile.y).toList().isNotEmpty) {
      return true;
    }

    return false;
  }

  List<Tile> getTilesForDirection(Direction direction) {
    return [];
  }
}