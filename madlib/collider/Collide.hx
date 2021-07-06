package madlib.collider;

import haxe.ds.Option;
import hxmath.math.Vector2;
import madlib.geom.Bounds;

using madlib.extensions.DifferExt;
using madlib.extensions.IterableExt;

class Collide {
    public inline static function check(a: Entity, b: Entity): Bool
        return a != b && b.collidable && a.collider.collideEntity(b);

    public inline static function checkAt(a: Entity, b: Entity, dx: Float, dy: Float): Bool {
        a.x += dx;
        a.y += dy;
        final ret = check(a, b);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public inline static function checks(a: Entity, es: Iterable<Entity>): Bool
        return es.any(e -> check(a, e));

    public inline static function checksAt(a: Entity, es: Iterable<Entity>, dx: Float, dy: Float): Bool {
        a.x += dx;
        a.y += dy;
        final ret = checks(a, es);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public inline static function first(a: Entity, es: Iterable<Entity>): Option<Entity>
        return es.first(e -> check(a, e));

    public inline static function firstAt(a: Entity, es: Iterable<Entity>, dx: Float, dy: Float): Option<Entity> {
        a.x += dx;
        a.y += dy;
        final ret = first(a, es);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public inline static function all(a: Entity, es: Iterable<Entity>): Array<Entity>
        return [for(e in es) if(check(a, e)) e];

    public inline static function allAt(a: Entity, es: Iterable<Entity>, dx: Float, dy: Float): Array<Entity> {
        a.x += dx;
        a.y += dy;
        final ret = all(a, es);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public static function checkPoint(a: Entity, p: Vector2): Bool
        return a.collider.collidePoint(p);

    public static function checkPointAt(a: Entity, p: Vector2, dx: Float, dy: Float): Bool {
        a.x += dx;
        a.y += dy;
        final ret = checkPoint(a, p);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public static function checkLine(a: Entity, from: Vector2, to: Vector2): Bool
        return a.collider.collideLine(from, to);

    public static function checkLineAt(a: Entity, from: Vector2, to: Vector2, dx: Float, dy: Float): Bool {
        a.x += dx;
        a.y += dy;
        final ret = checkLine(a, from, to);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public static function checkBounds(a: Entity, bounds: Bounds): Bool
        return a.collider.collideBounds(bounds);

    public static function checkBoundsAt(a: Entity, bounds: Bounds, dx: Float, dy: Float): Bool {
        a.x += dx;
        a.y += dy;
        final ret = checkBounds(a, bounds);
        a.x -= dx;
        a.y -= dy;
        return ret;
    }

    public inline static function rayVsRay(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2): Bool {
        final aRay = a1.createRayFromVector(a2);
        final bRay = b1.createRayFromVector(b2);
        final test = differ.Collision.rayWithRay(aRay, bRay);
        return test != null;
    }

    public inline static function rayIntersection(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2): Option<Vector2> {
        final aRay = a1.createRayFromVector(a2);
        final bRay = b1.createRayFromVector(b2);
        final test = differ.Collision.rayWithRay(aRay, bRay);
        return if(test != null) Some(new Vector2(test.u1, test.u2)) else None;
    }

    public inline static function circleVsLine(pos: Vector2, radius: Float, from: Vector2, to: Vector2): Bool {
        final ray = from.createRayFromVector(to);
        final circle = pos.toCircle(radius);
        return circle.testRay(ray) != null;
    }

    public inline static function circleVsPoint(pos: Vector2, radius: Float, p: Vector2): Bool
        return Math.distanceSquared(p.x, p.y, pos.x, pos.y) < radius * radius;

    public inline static function circleVsCircle(p1: Vector2, r1: Float, p2: Vector2, r2: Float): Bool
        return Math.distanceSquared(p1.x, p1.y, p2.x, p2.y) < (r1 + r2) * (r1 + r2);

    public inline static function circleVsRect(pos: Vector2, radius: Float, x: Float, y: Float, w: Float, h: Float): Bool
        return rectVsCircle(x, y, w, h, pos, radius);

    public inline static function circleVsBounds(pos: Vector2, radius: Float, bounds: Bounds): Bool
        return boundsVsCircle(bounds, pos, radius);

    public inline static function rectVsCircle(x: Float, y: Float, w: Float, h: Float, pos: Vector2, radius: Float): Bool {
        final rect = differ.shapes.Polygon.rectangle(x, y, w, h, false);
        return rect.test(pos.toCircle(radius)) != null;
    }

    public inline static function boundsVsCircle(bounds: Bounds, pos: Vector2, radius: Float): Bool
        return rectVsCircle(bounds.left, bounds.top, bounds.width, bounds.height, pos, radius);

    public inline static function rectVsLine(x: Float, y: Float, w: Float, h: Float, from: Vector2, to: Vector2): Bool {
        final rect = differ.shapes.Polygon.rectangle(x, y, w, h, false);
        final ray = from.createRayFromVector(to);
        return rect.testRay(ray) != null;
    }

    public inline static function boundsVsLine(bounds: Bounds, from: Vector2, to: Vector2): Bool
        return rectVsLine(bounds.left, bounds.top, bounds.width, bounds.height, from, to);

    public inline static function rectVsPoint(x: Float, y: Float, w: Float, h: Float, point: Vector2): Bool
        return boundsVsPoint(new Bounds(x, y, w, h), point);

    public inline static function boundsVsPoint(bounds: Bounds, point: Vector2): Bool
        return bounds.contains(point);
}
