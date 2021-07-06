package madlib;

import hxmath.math.IntVector2;
import hxmath.math.Vector2;

class Util {
    public inline static function coordId(x: Int, y: Int, width: Int): Int
        return x + y * width;

    public inline static function idCoord(index: Int, width: Int): IntVector2
        return new IntVector2(index % width, Math.floor(index / width));

    public inline static function tileCoord(x: Float, y: Float, tileWidth: Int, tileHeight: Int): IntVector2
        return new IntVector2(Math.floor(x / tileWidth), Math.floor(y / tileHeight));

    public inline static function snapGrid(x: Float, y: Float, tileWidth: Int, tileHeight: Int): IntVector2
        return new IntVector2(Math.floor(x / tileWidth) * tileWidth, Math.floor(y / tileHeight) * tileHeight);

    public inline static function range(start: Int, end: Int): Array<Int> {
        final result = [];
        final step = if(start <= end) 1 else -1;
        var i = start;
        while(if(start <= end) i <= end else end <= i) {
            result.push(i);
            i += step;
        }
        return result;
    }
}
