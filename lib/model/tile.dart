import 'package:flame/game.dart';
import 'package:hot_and_cold/constants.dart';
import 'package:hot_and_cold/enum/direction.dart';
import 'package:hot_and_cold/enum/tile_type.dart';

class Tile {
  Vector2 vector = Vector2.zero();
  int x = 0;
  int y = 0;
  TileType type = TileType.none;

  Tile.empty();
  
  Tile(this.x, this.y) {
    vector = Vector2(x*Constants.tilesize, y*Constants.tilesize);
  }
  
  Tile.fromVector(this.vector) {
    x = vector.x ~/ Constants.tilesize;
    y = vector.y ~/ Constants.tilesize;
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

  static Tile getNextTile(Direction direction, Tile tile) {
    switch(direction) {
      case Direction.up:
        return Tile(tile.x, tile.y-1);
      case Direction.down:
        return Tile(tile.x, tile.y+1);
      case Direction.left:
        return Tile(tile.x-1, tile.y);
      case Direction.right:
        return Tile(tile.x+1, tile.y);
      case Direction.none:
        return Tile(0, 0);
    }
  }
}

// extension on Vector2 {
//   Vector vectorFromTile(Tile tile) {
//     return Vector2(tile.x * Constants.tilesize, tile.y * Constants.tilesize);
//   }
// }