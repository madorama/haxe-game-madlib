package madlib.extensions;

import differ.math.Vector;
import differ.shapes.Circle;
import differ.shapes.Polygon;
import differ.shapes.Ray;
import differ.shapes.Shape;
import hxmath.math.Vector2;
import madlib.geom.Bounds;

class DifferExt {
    public inline static function createRay(x: Float, y: Float, tx: Float, ty: Float): Ray
        return new Ray(new Vector(x, y), new Vector(tx, ty));

    public inline static function createPoint(point: Vector2): Polygon
        return Polygon.square(point.x, point.y, 1, false);

    public inline static function toRectangle(bounds: Bounds): Polygon
        return Polygon.rectangle(bounds.left, bounds.top, bounds.width, bounds.height, false);

    public inline static function toCircle(pos: Vector2, radius: Float): Circle
        return new Circle(pos.x, pos.y, radius);

    public inline static function createRayFromVector(sv: Vector2, tv: Vector2): Ray
        return new Ray(new Vector(sv.x, sv.y), new Vector(tv.x, tv.y));
}
