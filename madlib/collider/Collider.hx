package madlib.collider;

import hxmath.math.Vector2;
import madlib.Option;
import madlib.geom.Bounds;

enum ColliderType {
    Circle;
    Grid;
    Hitbox;
    List;
    Polygon;
}

typedef HitPosition = {
    hitStart: Vector2,
    hitEnd: Option<Vector2>,
}

class Collider {
    public var entity(default, null): Entity = Entity.empty;
    public var position = Vector2.zero;

    var type = Circle;

    @:isVar public var rotation(get, set): Float = 0;

    inline function get_rotation(): Float
        return rotation;

    function set_rotation(v: Float): Float
        return rotation = v;

    @:isVar public var width(get, set): Float = 0;
    @:isVar public var height(get, set): Float = 0;
    @:isVar public var top(get, set): Float = 0;
    @:isVar public var bottom(get, set): Float = 0;
    @:isVar public var left(get, set): Float = 0;
    @:isVar public var right(get, set): Float = 0;

    function get_width()
        return width;

    function set_width(v)
        return width = v;

    function get_height()
        return height;

    function set_height(v)
        return height = v;

    function get_left()
        return left;

    function set_left(v)
        return left = v;

    function get_right()
        return right;

    function set_right(v)
        return right = v;

    function get_top()
        return top;

    function set_top(v)
        return top = v;

    function get_bottom()
        return bottom;

    function set_bottom(v)
        return bottom = v;

    public var centerX(get, set): Float;
    public var centerY(get, set): Float;

    function get_centerX()
        return left + width * .5;

    function set_centerX(v: Float)
        return left = v - width * .5;

    function get_centerY()
        return top + height * .5;

    function set_centerY(v: Float)
        return top = v - height * .5;

    public var size(get, never): Vector2;
    public var halfSize(get, never): Vector2;

    function get_size()
        return new Vector2(width, height);

    function get_halfSize()
        return new Vector2(width * .5, height * .5);

    public var absolutePosition(get, never): Vector2;

    function get_absolutePosition()
        return new Vector2(absoluteX, absoluteY);

    public var absoluteX(get, never): Float;
    public var absoluteY(get, never): Float;
    public var absoluteCenterX(get, never): Float;
    public var absoluteCenterY(get, never): Float;
    public var absoluteTop(get, never): Float;
    public var absoluteBottom(get, never): Float;
    public var absoluteLeft(get, never): Float;
    public var absoluteRight(get, never): Float;

    function get_absoluteX()
        return entity.pivotedX + position.x;

    function get_absoluteY()
        return entity.pivotedY + position.y;

    function get_absoluteCenterX()
        return absoluteX + width * .5;

    function get_absoluteCenterY()
        return absoluteY + height * .5;

    function get_absoluteTop()
        return entity.pivotedY + top;

    function get_absoluteBottom()
        return entity.pivotedY + bottom;

    function get_absoluteLeft()
        return entity.pivotedX + left;

    function get_absoluteRight()
        return entity.pivotedX + right;

    var innerBounds = new Bounds(0, 0, 0, 0);

    public var bounds(get, never): Bounds;

    inline function get_bounds() {
        innerBounds.x = absoluteLeft;
        innerBounds.y = absoluteTop;
        innerBounds.width = absoluteRight - absoluteLeft;
        innerBounds.height = absoluteBottom - absoluteTop;
        return innerBounds;
    }

    public function new(?entity: Entity) {
        if(entity != null) this.entity = entity;
    }

    public inline function center() {
        position.x = -width * 0.5;
        position.y = -height * 0.5;
    }

    public function added(entity: Entity) {
        this.entity = entity;
    }

    #if heaps
    public function debugDraw(graphics: h2d.Graphics) {
        final b = bounds;
        graphics.drawRect(b.left, b.top, b.width, b.height);
    }
    #end

    public inline function collideEntity(entity: Entity): Bool
        return if(entity.collider == null) false else collide(entity.collider);

    public function collide(c: Collider): Bool
        return switch c.type {
            case Circle:
                collideCircle(cast c);
            case Grid:
                collideGrid(cast c);
            case Hitbox:
                collideHitbox(cast c);
            case List:
                collideList(cast c);
            case Polygon:
                collidePolygon(cast c);
        }

    public function collidePoint(p: Vector2): Bool
        return false;

    public function collideBounds(bounds: Bounds): Bool
        return false;

    public function intersectLine(from: Vector2, to: Vector2): Option<HitPosition>
        return None;

    public function collideLine(from: Vector2, to: Vector2): Bool
        return false;

    public function collideCircle(circle: Circle): Bool
        return false;

    public function collideGrid(grid: Grid): Bool
        return false;

    public function collideHitbox(hitbox: Hitbox): Bool
        return false;

    public function collideList(list: ColliderList): Bool
        return false;

    public function collidePolygon(polygon: Polygon): Bool
        return false;

    public function clone(): Collider
        return new Collider(entity);
}
