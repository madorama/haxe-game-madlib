package madlib.collider;

import hxmath.math.Vector2;
import madlib.geom.Bounds;

class Hitbox extends Collider {
    public function new(width: Float, height: Float, x: Float, y: Float) {
        super();
        this.width = width;
        this.height = height;
        position.set(x, y);
    }

    override function get_left(): Float
        return position.x;

    override function set_left(v: Float): Float
        return position.x = v;

    override function get_top(): Float
        return position.y;

    override function set_top(v: Float): Float
        return position.y = v;

    override function get_right(): Float
        return position.x + width;

    override function set_right(v: Float): Float
        return position.x = v - width;

    override function get_bottom(): Float
        return position.y + height;

    override function set_bottom(v: Float): Float
        return position.y = v - height;

    public function intersects(hitbox: Hitbox): Bool
        return absoluteLeft < hitbox.absoluteRight && absoluteRight > hitbox.absoluteLeft && absoluteBottom > hitbox.absoluteTop
            && absoluteTop < hitbox.absoluteBottom;

    public function intersectsValue(x: Float, y: Float, width: Float, height: Float): Bool
        return absoluteRight > x && absoluteBottom > y && absoluteLeft < x + width && absoluteTop < y + height;

    override function clone(): Collider
        return new Hitbox(width, height, position.x, position.y);

    public function setFromBounds(bounds: Bounds) {
        position.set(bounds.left, bounds.top);
        width = bounds.width;
        height = bounds.height;
    }

    public function set(x: Float, y: Float, w: Float, h: Float) {
        position.set(x, y);
        width = w;
        height = h;
    }

    public function getTopEdge(): {from: Vector2, to: Vector2}
        return {
            from: new Vector2(absoluteLeft, absoluteTop),
            to: new Vector2(absoluteRight, absoluteTop)
        }

    public function getBottomEdge(): {from: Vector2, to: Vector2}
        return {
            from: new Vector2(absoluteLeft, absoluteBottom),
            to: new Vector2(absoluteRight, absoluteBottom)
        }

    public function getLeftEdge(): {from: Vector2, to: Vector2}
        return {
            from: new Vector2(absoluteLeft, absoluteTop),
            to: new Vector2(absoluteLeft, absoluteBottom)
        }

    public function getRightEdge(): {from: Vector2, to: Vector2}
        return {
            from: new Vector2(absoluteRight, absoluteTop),
            to: new Vector2(absoluteRight, absoluteBottom)
        }

    override function collidePoint(p: Vector2): Bool
        return Collide.boundsVsPoint(bounds, p);

    override function collideBounds(bounds: Bounds): Bool
        return absoluteRight > bounds.left && absoluteBottom > bounds.top && absoluteLeft < bounds.right && absoluteTop < bounds.bottom;

    override function collideLine(from: Vector2, to: Vector2): Bool
        return Collide.boundsVsLine(bounds, from, to);

    override function collideCircle(circle: Circle): Bool
        return Collide.boundsVsCircle(bounds, circle.absolutePosition, circle.radius);

    override function collideGrid(grid: Grid): Bool
        return grid.collideBounds(bounds);

    override function collideHitbox(hitbox: Hitbox): Bool
        return intersects(hitbox);

    override function collideList(collider: ColliderList): Bool
        return collider.collideHitbox(this);

    override function collidePolygon(polygon: Polygon): Bool {
        return polygon.collideBounds(bounds);
    }
}
