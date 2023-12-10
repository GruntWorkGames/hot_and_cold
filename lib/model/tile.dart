import 'package:flame/game.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/direction.dart';
import 'package:hot_and_cold/enum/tile_type.dart';

class TilePos {
  Vector2 vector = Vector2.zero();
  int x = 0;
  int y = 0;
  TileType type = TileType.none;

  TilePos.empty();
  
  TilePos(this.x, this.y) {
    vector = Vector2(x*Constants.tilesize, y*Constants.tilesize);
  }
  
  TilePos.fromVector(this.vector) {
    x = vector.x ~/ Constants.tilesize;
    y = vector.y ~/ Constants.tilesize;
    vector.x = x * Constants.tilesize;
    vector.y = y * Constants.tilesize;
  }

  void set(int x, int y) {
    this.x = x;
    this.y = y;
    vector = Vector2(x*Constants.tilesize, y*Constants.tilesize);
  }

  void setVec(Vector2 vector) {
    this.vector = vector;
    x = vector.x ~/ Constants.tilesize;
    y = vector.y ~/ Constants.tilesize;
  }

  static TilePos getNextTile(Direction direction, TilePos tile) {
    switch(direction) {
      case Direction.up:
        return TilePos(tile.x, tile.y-1);
      case Direction.down:
        return TilePos(tile.x, tile.y+1);
      case Direction.left:
        return TilePos(tile.x-1, tile.y);
      case Direction.right:
        return TilePos(tile.x+1, tile.y);
      case Direction.none:
        return TilePos(0, 0);
    }
  }

  Vector2 toVector2() {
    return Vector2(x.toDouble(), y.toDouble());
  }
}