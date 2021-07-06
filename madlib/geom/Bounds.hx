package madlib.geom;

import hxmath.math.Vector2;

@:structInit
class Bounds {
    public var x: Float;
    public var y: Float;
    public var width: Float;
    public var height: Float;

    public var left(get, never): Float;
    public var top(get, never): Float;
    public var right(get, never): Float;
    public var bottom(get, never): Float;

    inline function get_left()
        return x;

    inline function get_top()
        return y;

    inline function get_right()
        return x + width;

    inline function get_bottom()
        return y + height;

    public var area(get, never): Float;

    inline function get_area()
        return width * height;

    public inline function getCenter(): Vector2
        return new Vector2(x + width * .5, y + height * .5);

    public function new(x: Float, y: Float, width: Float, height: Float) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public inline static function fromPoints(a: Vector2, b: Vector2)
        return new Bounds(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(b.x - a.x), Math.abs(b.y - a.y));

    public inline function set(x: Float, y: Float, width: Float, height: Float) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public inline function equals(b: Bounds)
        return x == b.x && y == b.y && width == b.width && height == b.height;

    public inline function clone(): Bounds
        return new Bounds(x, y, width, height);

    public inline function overlaps(b: Bounds): Bool
        return !(left > b.right || top > b.bottom || right < b.left || bottom < b.top);

    public inline function contains(p: Vector2): Bool
        return p.x >= left && p.x < right && p.y >= top && p.y < bottom;

    public inline function intersection(b: Bounds): Bounds {
        final t = clone();
        if(x < b.x) {
            t.width -= b.x - x;
            x = b.x;
        }
        if(y < b.y) {
            t.height -= b.y - y;
            y = b.y;
        }
        if(right > b.right)
            t.width -= right - b.right;
        if(bottom > b.bottom)
            t.height -= bottom - b.bottom;
        return t;
    }
}
