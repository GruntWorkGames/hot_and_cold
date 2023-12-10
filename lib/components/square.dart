import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

class Square extends PositionComponent {
  PaletteEntry palette;
  Square(this.palette);
  
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromCircle(center: const Offset(32,32), radius: 32), 
    palette.paint()..style = PaintingStyle.stroke..strokeWidth = 3);
  }
}