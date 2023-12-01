package madlib.collider;

import differ.Collision;
import differ.data.RayCollision;
import hxmath.math.Vector2;
import madlib.Option;
import madlib.collider.Collider.HitPosition;
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

    public inline static function intersectEntity(from: Vector2, to: Vector2, a: Entity): Option<HitPosition> {
        return if(a.collidable) {
            a.collider.intersectLine(from, to);
        } else {
            None;
        }
    }

    public inline static function intersectFirstEntity(from: Vector2, to: Vector2, es: Iterable<Entity>): Option<{entity: Entity, hitPosition: HitPosition}> {
        var minPosition = None;
        var minLength = Math.FLOAT_MAX;
        for(e in es) {
            if(!e.collidable) continue;
            switch e.collider.intersectLine(from, to) {
                case None:
                case Some(hit):
                    final length = Math.abs(from.length - hit.start.length);
                    minLength = Math.min(minLength, length);
                    if(minLength >= length) {
                        minPosition = Some({ entity: e, hitPosition: hit });
                    }
            }
        }
        return minPosition;
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

    inline static function createHitPosition(?test: RayCollision): Option<HitPosition> {
        return if(test != null) {
            final sx = RayCollisionHelper.hitStartX(test);
            final sy = RayCollisionHelper.hitStartY(test);
            final hitEnd = if(test.end <= 1) {
                final ex = RayCollisionHelper.hitEndX(test);
                final ey = RayCollisionHelper.hitEndY(test);
                Some(new Vector2(ex, ey));
            } else {
                None;
            }
            Some({ start: new Vector2(sx, sy), end: hitEnd });
        } else {
            None;
        }
    }

    public inline static function intersectCircleVsLine(pos: Vector2, radius: Float, from: Vector2, to: Vector2): Option<HitPosition>
        return createHitPosition(Collision.rayWithShape(from.createRayFromVector(to), pos.toCircle(radius)));

    public inline static function circleVsLine(pos: Vector2, radius: Float, from: Vector2, to: Vector2): Bool {
        final ray = from.createRayFromVector(to);
        final circle = pos.toCircle(radius);
        return circle.testRay(ray) != null;
    }

    public inline static function circleVsPoint(pos: Vector2, radius: Float, p: Vector2): Bool
        return Math.distanceSquared(p.x, p.y, pos.x, pos.y) < radius * radius;

    public inline static function circleVsCircle(p1: Vector2, r1: Float, p2: Vector2, r2: Float): Bool
        return Math.distanceSquared(p1.x, p1.y, p2.x, p2.y) < (r1 + r2) * (r1 + r2);

    public inline static function boundsVsCircle(bounds: Bounds, pos: Vector2, radius: Float): Bool {
        final rect = differ.shapes.Polygon.rectangle(bounds.left, bounds.top, bounds.width, bounds.height, false);
        return rect.test(pos.toCircle(radius)) != null;
    }

    public inline static function intersectBoundsVsLine(bounds: Bounds, from: Vector2, to: Vector2): Option<HitPosition> {
        final rect = differ.shapes.Polygon.rectangle(bounds.left, bounds.top, bounds.width, bounds.height, false);
        return createHitPosition(rect.testRay(from.createRayFromVector(to)));
    }

    public inline static function boundsVsLine(bounds: Bounds, from: Vector2, to: Vector2): Bool {
        final rect = differ.shapes.Polygon.rectangle(bounds.left, bounds.top, bounds.width, bounds.height, false);
        final ray = from.createRayFromVector(to);
        return rect.testRay(ray) != null;
    }

    public inline static function boundsVsPoint(bounds: Bounds, point: Vector2): Bool
        return bounds.contains(point);

    public inline static function boundsVsBounds(bounds1: Bounds, bounds2: Bounds): Bool
        return bounds1.toRectangle().test(bounds2.toRectangle()) != null;

    public inline static function polyVsPoint(pos: Vector2, polygon: differ.shapes.Polygon, p: Vector2) {
        final newPoly = new differ.shapes.Polygon(pos.x, pos.y, polygon.transformedVertices);
        return differ.Collision.pointInPoly(p.x, p.y, newPoly);
    }

    public inline static function intersectPolyVsLine(pos: Vector2, polygon: differ.shapes.Polygon, from: Vector2, to: Vector2): Option<HitPosition> {
        final ray = from.createRayFromVector(to);
        final newPoly = new differ.shapes.Polygon(pos.x, pos.y, polygon.transformedVertices);
        return createHitPosition(differ.Collision.rayWithShape(ray, newPoly));
    }

    public inline static function polyVsLine(pos: Vector2, polygon: differ.shapes.Polygon, from: Vector2, to: Vector2): Bool {
        final ray = from.createRayFromVector(to);
        final newPoly = new differ.shapes.Polygon(pos.x, pos.y, polygon.transformedVertices);
        final test = differ.Collision.rayWithShape(ray, newPoly);
        return test != null;
    }

    public inline static function polyVsCircle(pos: Vector2, polygon: differ.shapes.Polygon, circlePos: Vector2, radius: Float): Bool {
        final circle = new differ.shapes.Circle(circlePos.x, circlePos.y, radius);
        final newPoly = new differ.shapes.Polygon(pos.x, pos.y, polygon.transformedVertices);
        final test = newPoly.testCircle(circle);
        return test != null;
    }

    public inline static function polyVsRect(pos: Vector2, polygon: differ.shapes.Polygon, x: Float, y: Float, w: Float, h: Float, rotation: Float): Bool {
        final rect = differ.shapes.Polygon.rectangle(x, y, w, h);
        rect.rotation = rotation;
        final newPoly = new differ.shapes.Polygon(pos.x, pos.y, polygon.transformedVertices);
        final test = differ.Collision.shapeWithShape(newPoly, rect);
        return test != null;
    }

    public inline static function polyVsPoly(posA: Vector2, a: differ.shapes.Polygon, posB: Vector2, b: differ.shapes.Polygon): Bool {
        final newA = new differ.shapes.Polygon(posA.x, posA.y, a.transformedVertices);
        final newB = new differ.shapes.Polygon(posB.x, posB.y, b.transformedVertices);
        final test = differ.Collision.shapeWithShape(newA, newB);
        return test != null;
    }

    inline static function verticesToPolygon(vertices: Array<Vector2>): differ.shapes.Polygon {
        final vs = vertices.map(v -> new differ.math.Vector(v.x, v.y));
        return new differ.shapes.Polygon(0, 0, vs);
    }

    public inline static function vertsVsPoint(vertices: Array<Vector2>, p: Vector2): Bool
        return polyVsPoint(Vector2.zero, verticesToPolygon(vertices), p);

    public inline static function vertsVsCircle(vertices: Array<Vector2>, pos: Vector2, radius: Float): Bool
        return polyVsCircle(Vector2.zero, verticesToPolygon(vertices), pos, radius);

    public inline static function intersectVertsVsLine(vertices: Array<Vector2>, from: Vector2, to: Vector2): Option<HitPosition>
        return intersectPolyVsLine(Vector2.zero, verticesToPolygon(vertices), from, to);

    public inline static function vertsVsLine(vertices: Array<Vector2>, from: Vector2, to: Vector2): Bool
        return polyVsLine(Vector2.zero, verticesToPolygon(vertices), from, to);

    public inline static function vertsVsRect(vertices: Array<Vector2>, x: Float, y: Float, w: Float, h: Float, rotation: Float): Bool
        return polyVsRect(Vector2.zero, verticesToPolygon(vertices), x, y, w, h, rotation);

    public inline static function vertsVsPoly(vertices: Array<Vector2>, pos: Vector2, polygon: differ.shapes.Polygon): Bool
        return polyVsPoly(Vector2.zero, verticesToPolygon(vertices), pos, polygon);

    public inline static function vertsVsVerts(a: Array<Vector2>, b: Array<Vector2>): Bool
        return vertsVsPoly(a, Vector2.zero, verticesToPolygon(b));
}
