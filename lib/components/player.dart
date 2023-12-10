import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hot_and_cold/components/sprite.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/direction.dart';
import 'package:hot_and_cold/enum/player_anim_state.dart';
import 'package:hot_and_cold/model/tile.dart';

class Player extends SpriteAnim {
  bool isMoving = false;
  bool isWalkPressed = false;

  @override
  FutureOr<void> onLoad() async {
    await buildAnimations();
    anchor = const Anchor(0, 0.6);
  }

  void setAnimState(PlayerAnimState state, Function onComplete) {
    animationState = state;
    switch(state) {
      case PlayerAnimState.idleDown:
        playAnimFor(direction: Direction.down, state: state);
        break;
      case PlayerAnimState.idleUp:
        playAnimFor(direction: Direction.up, state: state);
        break;
      case PlayerAnimState.idleRight:
        playAnimFor(direction: Direction.right, state: state);
        break;
      case PlayerAnimState.idleLeft:
        playAnimFor(direction: Direction.left, state: state);
        break;
      case PlayerAnimState.walkDown:
        move(Direction.down, onComplete);
        break;
      case PlayerAnimState.walkUp:
        move(Direction.up, onComplete);
        break;
      case PlayerAnimState.walkRight:
        move(Direction.right, onComplete);
        break;
      case PlayerAnimState.walkLeft:
        move(Direction.left, onComplete);
        break;
      case PlayerAnimState.beginIdle:
        playAnimFor(direction: Direction.down, state: PlayerAnimState.idleDown);
        break;
    }
  }

  void playAnimFor({required Direction direction, required PlayerAnimState state}) {
    animation = animations[state];
  }

  void move(Direction direction, Function onMoveComplete) {
    final distance = getDistanceForMove(direction);
    final lastPos = position.clone();
    final move = MoveEffect.by(
      distance,
      EffectController(duration: 0.2),
      onComplete: () {
        // snap to grid.
        position = lastPos + distance;
        isMoving = false;
        actionFinished(PlayerAnimState.beginIdle);
        onMoveComplete();
      },
    );
    move.removeOnFinish = true;
    isMoving = true;

    add(move);
  }

  void actionFinished(PlayerAnimState st) {
    if (st == PlayerAnimState.beginIdle) {

      if(isWalkPressed) {
        setAnimState(animationState, (){});
      }

      switch (animationState) {
        case PlayerAnimState.walkUp:
          animation = animations[PlayerAnimState.idleUp];
          return;
        case PlayerAnimState.walkDown:
          animation = animations[PlayerAnimState.idleDown];
          return;
        case PlayerAnimState.walkLeft:
          animation = animations[PlayerAnimState.idleLeft];
          return;
        case PlayerAnimState.walkRight:
          animation = animations[PlayerAnimState.idleRight];
          return;
        case PlayerAnimState.beginIdle:
        case PlayerAnimState.idleDown:
        case PlayerAnimState.idleUp:
        case PlayerAnimState.idleLeft:
        case PlayerAnimState.idleRight:
      }
    } else {
      animation = animations[st];
      animationState = st;
    }
  }

  Vector2 getDistanceForMove(Direction direction) {
    final distance = Vector2(0, 0);
    switch (direction) {
      case Direction.up:
        distance.y -= Constants.tilesize;
        break;
      case Direction.down:
        distance.y += Constants.tilesize;
        break;
      case Direction.left:
        distance.x -= Constants.tilesize;
        break;
      case Direction.right:
        distance.x += Constants.tilesize;
        break;
      case Direction.none:
    }
    return distance;
  }

  @override
  Future<void> buildAnimations() async {
    final json = await game.assets.readJson('json/penguin_anim.json');
    final imageFile = json['imageFile'] ?? '';
    final image = await game.images.load(imageFile);
    for (final state in PlayerAnimState.values) {
      if (json.containsKey(state.name)) {
        animations[state] = animationFromJson(image, json, state.name);
      }
    }

    animation = animations[PlayerAnimState.idleDown];
  }

  void jumpToTile(TilePos tile) {
    final dif = tile.vector - position;
    final move = MoveEffect.by(
      dif,
      EffectController(duration: 0.4),
      onComplete: () {
        isMoving = false;
        actionFinished(PlayerAnimState.beginIdle);
      },
    );
    move.removeOnFinish = true;
    isMoving = true;

    final zoomIn = ScaleEffect.to(Vector2(1.25, 1.25), EffectController(duration: .15));
    final zoomOut = ScaleEffect.to(Vector2(1.0, 1.0), EffectController(duration: .15));
    final sequence = SequenceEffect([zoomIn, zoomOut]);
    add(sequence);
    add(move);
  }

  void faceDirection(Direction dir) {
     switch(dir) {
      case Direction.right:
        playAnimFor(direction: Direction.down, state: PlayerAnimState.idleRight);
        break;
      case Direction.left:
        playAnimFor(direction: Direction.up, state: PlayerAnimState.idleLeft);
        break;
      case Direction.down:
        playAnimFor(direction: Direction.right, state: PlayerAnimState.idleDown);
        break;
      case Direction.up:
        playAnimFor(direction: Direction.left, state: PlayerAnimState.idleUp);
        break;
      case Direction.none:

     }
  }
}