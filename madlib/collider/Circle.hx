package madlib.collider;

import hxmath.math.Vector2;
import madlib.Option;
import madlib.collider.Collider.HitPosition;
import madlib.geom.Bounds;

using madlib.extensions.DifferExt;

class Circle extends Collider {
    public var radius: Float;

    public function new(radius: Float, x: Float = 0, y: Float = 0, ?entity: Entity) {
        super(entity);
        this.radius = radius;
        position.set(x, y);
    }

    public var scaledRadius(get, never): Float;

    function get_scaledRadius(): Float
        return radius * Math.max(entity.scaleX, entity.scaleY);

    override function get_width(): Float
        return radius * 2;

    override function set_width(v: Float): Float
        return radius = v * 0.5;

    override function get_height(): Float
        return radius * 2;

    override function set_height(v: Float): Float
        return radius = v * 0.5;

    override function get_left(): Float
        return position.x - radius;

    override function set_left(v: Float): Float
        return position.x = v + radius;

    override function get_top(): Float
        return position.y - radius;

    override function set_top(v: Float): Float
        return position.y = v + radius;

    override function get_right(): Float
        return position.x + radius;

    override function set_right(v: Float): Float
        return position.x = v - radius;

    override function get_bottom(): Float
        return position.y + radius;

    override function set_bottom(v: Float): Float
        return position.y = v - radius;

    override function clone(): Collider
        return new Circle(radius, position.x, position.y);

    #if heaps
    override function debugDraw(graphics: h2d.Graphics) {
        graphics.drawCircle(absolutePosition.x, absolutePosition.y, scaledRadius);
    }
    #end

    override function collidePoint(p: Vector2): Bool
        return Collide.circleVsPoint(absolutePosition, scaledRadius, p);

    override function collideBounds(bounds: Bounds): Bool
        return Collide.boundsVsCircle(bounds, absolutePosition, scaledRadius);

    override function intersectLine(from: Vector2, to: Vector2): Option<HitPosition>
        return Collide.intersectCircleVsLine(absolutePosition, scaledRadius, from, to);

    override function collideLine(from: Vector2, to: Vector2): Bool
        return Collide.circleVsLine(absolutePosition, scaledRadius, from, to);

    override function collideCircle(circle: Circle): Bool
        return Math.distanceSquared(absolutePosition.x, absolutePosition.y, circle.absolutePosition.x,
            circle.absolutePosition.y) < (scaledRadius + circle.scaledRadius) * (scaledRadius + circle.scaledRadius);

    override function collideHitbox(hitbox: Hitbox): Bool
        return hitbox.collideCircle(this);

    override function collideGrid(grid: Grid): Bool
        return grid.collideCircle(this);

    override function collideList(list: ColliderList): Bool
        return list.collideCircle(this);

    override function collidePolygon(polygon: Polygon): Bool
        return polygon.collideCircle(this);
}
