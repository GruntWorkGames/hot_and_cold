import 'dart:async' as asyn;
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:hot_and_cold/components/ice_cube.dart';
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
  final List<TilePos> _lava = [];

  bool ignoreInput = false;
  final List<TilePos> rocks = [];
  final List<IceCube> iceCubes = [];
  final square = my.Square(BasicPalette.green);
  final audio = AudioPlayer();

  @override 
  asyn.FutureOr<void> onLoad() async {
    await _addTilemap();
    _addPlayer();
    _loadLayerObjects();
    _setupCamera();
    _addKeyboardListeners();
    _createIceCubeTimer();
    world.add(square);
    
    audio.setVolume(0.1);
    audio.play(AssetSource('music/Sanctuary.wav'));
  }

  @override
  void onDispose() {
    audio.stop();
  }

  void _addPlayer() {
    player = Player();
    player.priority = 1;
    world.add(player);
    player.position = _readSpawnPos();
  }

  void _setupCamera() {
    camera.follow(player);
  }

  _createIceCubeTimer() {
    asyn.Timer.periodic(const Duration(seconds: 1), (timer) { 
      _createIceCube();
    });
  }

  Future<void> _addTilemap() async {
    tiledmap = await TiledComponent.load('map.tmx', Vector2(Constants.tilesize, Constants.tilesize));
    tiledmap.priority = 0;
    world.add(tiledmap);
  }

  Vector2 _readSpawnPos() {
    final objectGroup = tiledmap.tileMap. getLayer<ObjectGroup>('spawn');
    final spawnObject = objectGroup!.objects.first;
    return Vector2(spawnObject.x, spawnObject.y);
  }

  void _addKeyboardListeners() {
    aDown(Set<LogicalKeyboardKey> keysPressed) { 
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkLeft, (){});
      }
      return true; 
    }
    aUp(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleLeft, (){});
      return true; 
    }
    wDown(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkUp, (){});
      }
      return true; 
    }
    wUp(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleUp, (){});
      return true;
    }
    sDown(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkDown, (){});
      }
      return true; 
    }
    sUp(Set<LogicalKeyboardKey> keysPressed) { 
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleDown, (){});
      return true; 
    }
    dDown(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = true;
      if(!player.isMoving) {
        player.setAnimState(PlayerAnimState.walkRight, (){});
      }
      return true; 
    }
    dUp(Set<LogicalKeyboardKey> keysPressed) {
      player.isWalkPressed = false;
      player.setAnimState(PlayerAnimState.idleRight, (){});
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

    if(_isValidSpot(tile)) {
      square.palette = BasicPalette.green;
    } else {
      square.palette = BasicPalette.red;
    }
  }

  @override
  void onTapUp(TapUpEvent event) async {
    final tile = TilePos.fromVector(camera.globalToLocal(event.localPosition));
    if(_isValidSpot(tile)) {
      final Direction dir = _getDirectionForTile(tile);
      player.faceDirection(dir);
      await Future.delayed(const Duration(milliseconds: 100));
      player.jumpToTile(tile);
    }
  }

  void _loadLayerObjects() {
    final landGroup = tiledmap.tileMap.getLayer<ObjectGroup>('land');
    final landObj = landGroup?.objects.first;
    land = Rect.fromLTWH(landObj!.x, landObj.y, landObj.width, landObj.height); 

    final goalGroup = tiledmap.tileMap.getLayer<ObjectGroup>('goal');
    final goalObj = goalGroup?.objects.first;
    goal = Rect.fromLTWH(goalObj!.x, goalObj.y, goalObj.width, goalObj.height); 

    final rockGroup = tiledmap.tileMap.getLayer<ObjectGroup>('rock');
    for(final rockObj in rockGroup!.objects) {
      rocks.add(TilePos.fromVector(Vector2(rockObj.x, rockObj.y)));
    }

    final lavaGroup = tiledmap.tileMap.getLayer<ObjectGroup>('lava');
    final fullLava = lavaGroup!.objects.first;
    for(int x=fullLava.x~/Constants.tilesize; x<fullLava.width/Constants.tilesize; x++) {
      for(int y=fullLava.y~/Constants.tilesize; y<fullLava.height/Constants.tilesize; y++) {
        _lava.add(TilePos(x, y));
      }
    }
  }
  
  bool _isValidSpot(TilePos tile) {
    if(goal.containsPoint(tile.vector) && tile.vector.distanceTo(player.position) <= 200) {
      return true;
    }

    if(rocks.where((rock) => rock.x == tile.x && rock.y == tile.y && rock.vector.distanceTo(player.position) <= 200).toList().isNotEmpty) {
      return true;
    }
    
    if(iceCubes.where((ice) => ice.tile.x == tile.x && ice.tile.y == tile.y && ice.tile.vector.distanceTo(player.position) <= 200).toList().isNotEmpty) {
      return true;
    }

    if(land.containsPoint(tile.vector) && tile.vector.distanceTo(player.position) <= 200) {
      return true;
    }

    return false;
  }

  void _createIceCube() {
    final r = Random().nextInt(_lava.length);
    final pos = _lava[r];

    final cube = IceCube(5);
    cube.removeFunc = (){
      iceCubes.remove(cube); 
      if(player.position == cube.position) {
        player.removeFromParent();
      }
    };
    cube.position = pos.vector;
    cube.tile = pos;
    iceCubes.add(cube);
    world.add(cube);
    cube.priority = 0;
  }
  
  Direction _getDirectionForTile(TilePos tile) {
    final playerTile = TilePos.fromVector(player.position);
    if (tile.x == playerTile.x && tile.y == playerTile.y) {
      return Direction.none;
    }

    final difX = (tile.x - playerTile.x).abs();
    final difY = (tile.y - playerTile.y).abs();
    if(difX > difY) {// horiz
      if(playerTile.x > tile.x) {
        return Direction.left;
      } else if(playerTile.x < tile.x) {
        return Direction.right;
      }
    } else if(difY > difX) {
      if(playerTile.y < tile.y) {
        return Direction.down;
      } else if(playerTile.y > tile.y) {
        return Direction.up;
      }
    }

    if (tile.x == playerTile.x) {
      // moved up/down
      return playerTile.y > tile.y ? Direction.up : Direction.down;
    } else if (tile.y == playerTile.y) {
      return playerTile.x > tile.x ? Direction.left : Direction.right;
    } else {
      return Direction.none;
    }
  }

}