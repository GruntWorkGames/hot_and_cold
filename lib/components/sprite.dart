import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/player_anim_state.dart';
import 'package:hot_and_cold/model/tile.dart';

class SpriteAnim extends SpriteAnimationComponent with HasGameRef {
  SpriteAnim();
  final Map<PlayerAnimState, SpriteAnimation> animations = {};
  PlayerAnimState animationState = PlayerAnimState.idleDown;
  TilePos tile = TilePos.empty();

  Future<void> buildAnimations() async {

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