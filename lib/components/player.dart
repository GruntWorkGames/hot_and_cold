
import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/direction.dart';
import 'package:hot_and_cold/enum/player_anim_state.dart';
import 'package:hot_and_cold/model/tile.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  bool isMoving = false;
  final Map<PlayerAnimState, SpriteAnimation> animations = {};
  PlayerAnimState animationState = PlayerAnimState.idleDown;
  Tile tile = Tile.empty();

  @override
  FutureOr<void> onLoad() async {
    await buildAnimations();
    anchor = const Anchor(0, 0.5);
  }

  void setAnimState(PlayerAnimState state) {
    animationState = state;
    switch(state) {
      case PlayerAnimState.idleDown:
        isMoving = false;
        playAnimFor(direction: Direction.down, state: state);
        break;
      case PlayerAnimState.idleUp:
        isMoving = false;
        playAnimFor(direction: Direction.up, state: state);
        break;
      case PlayerAnimState.idleRight:
        isMoving = false;
        playAnimFor(direction: Direction.right, state: state);
        break;
      case PlayerAnimState.idleLeft:
        isMoving = false;
        playAnimFor(direction: Direction.left, state: state);
        break;
      case PlayerAnimState.walkDown:
        if(isMoving) {
          break;
        }
        isMoving = true;
        playAnimFor(direction: Direction.down, state: state);
        move(Direction.down);
        break;
      case PlayerAnimState.walkUp:
        if(isMoving) {
          break;
        }
        isMoving = true;
        playAnimFor(direction: Direction.up, state: state);
        move(Direction.up);
        break;
      case PlayerAnimState.walkRight:
        print('set anim state');
        isMoving = true;
        playAnimFor(direction: Direction.right, state: state);
        move(Direction.right);
        break;
      case PlayerAnimState.walkLeft:
        print('set anim state');
        isMoving = true;
        playAnimFor(direction: Direction.left, state: state);
        move(Direction.left);
        break;
      case PlayerAnimState.beginIdle:
        playAnimFor(direction: Direction.down, state: PlayerAnimState.idleDown);
        break;
    }
  }

  void playAnimFor({required Direction direction, required PlayerAnimState state}) {
    animation = animations[state];
  }

  void move(Direction direction) {
    final distance = getDistanceForMove(direction);
    final lastPos = position.clone();
    final move = MoveEffect.by(
      distance,
      EffectController(duration: 0.2),
      onComplete: () {
        // snap to grid. issue with moveTo/moveBy not being perfect...
        position = lastPos + distance;
        // final tilePos = Tile.fromVector(position);
        actionFinished(PlayerAnimState.beginIdle);
        // onMoveCompleted(tilePos);
      },
    );
    move.removeOnFinish = true;

    add(move);
  }

  void actionFinished(PlayerAnimState st) {
    if (st == PlayerAnimState.beginIdle) {
      if(isMoving) {
        print('is moving');
        setAnimState(animationState);
        return;
      } else {
        print('isNotMoving');
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

  SpriteAnimation animationFromJson(Image image, Map<String, dynamic> json, String animName) {
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(Constants.tilesize, Constants.tilesize));
    final Map<String, dynamic> anim = json[animName];
    final List<SpriteAnimationFrameData> frames = [];
    final double stepTime = anim['timePerFrame'] ?? 0;
    if (anim.containsKey('frames')) {
      final List<dynamic> frameData = anim['frames'];
      for (final frame in frameData) {
        final x = frame['y'] ?? 0;
        final y = frame['x'] ?? 0;
        final f = spriteSheet.createFrameData(x, y, stepTime: stepTime);
        frames.add(f);
      }
    }

    return SpriteAnimation.fromFrameData(image, SpriteAnimationData(frames));
  }
}