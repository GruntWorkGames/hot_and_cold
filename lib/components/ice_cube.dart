import 'dart:async';
import 'package:flame/effects.dart';
import 'package:hot_and_cold/components/sprite.dart';

class IceCube extends SpriteAnim {
  double lifespan = 5.0;
  Function? removeFunc;
  IceCube(this.lifespan);

  @override
  FutureOr<void> onLoad() {
    buildAnimations();

    final fade = OpacityEffect.fadeOut(EffectController(duration: lifespan), onComplete: (){
      removeFromParent();
      if(removeFunc != null) {
        removeFunc!();
      }
    });
    add(fade);
  }

  @override
  Future<void> buildAnimations() async {
    final json = await game.assets.readJson('json/ice_cube.json');
    final imageFile = json['imageFile'] ?? '';
    final image = await game.images.load(imageFile);
    animation = animationFromJson(image, json, 'animate');
  }
}