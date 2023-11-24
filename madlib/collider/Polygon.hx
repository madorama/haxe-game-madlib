package madlib.collider;

import differ.math.Vector;
import h2d.Graphics;
import hxmath.math.Vector2;
import madlib.Option;
import madlib.collider.Collider.HitPosition;
import madlib.geom.Bounds;

class Polygon extends Collider {
    var minX = Math.DOUBLE_MAX;
    var minY = Math.DOUBLE_MAX;
    var maxX = Math.DOUBLE_MIN;
    var maxY = Math.DOUBLE_MIN;

    var vertices: Array<differ.math.Vector> = [];
    var polygon: differ.shapes.Polygon;

    override function set_rotation(v: Float): Float {
        rotation = v;
        calcBounds();
        return v;
    }

    public function new(x: Float, y: Float, vertices: Array<Vector2>, ?entity: Entity) {
        super(entity);
        this.vertices = vertices.map(v -> new Vector(v.x, v.y));

        // Get width and height
        minX = Math.DOUBLE_MAX;
        minY = Math.DOUBLE_MAX;
        maxX = Math.DOUBLE_MIN;
        maxY = Math.DOUBLE_MIN;
        for(v in vertices) {
            if(v.x <= minX) minX = v.x;
            if(v.y <= minY) minY = v.y;
            if(v.x >= maxX) maxX = v.x;
            if(v.y >= maxY) maxY = v.y;
        }

        polygon = new differ.shapes.Polygon(0, 0, []);
        width = maxX - minX;
        height = maxY - minY;

        calcBounds();

        position.set(x, y);

        type = Polygon;
    }

    function calcBounds() {
        final dx = entity.pivotX * width;
        final dy = entity.pivotY * height;
        final vs = vertices.map(v -> new Vector(v.x - dx, v.y - dy));
        polygon = new differ.shapes.Polygon(dx, dy, vs);
        polygon.rotation = rotation;

        minX = Math.DOUBLE_MAX;
        minY = Math.DOUBLE_MAX;
        maxX = Math.DOUBLE_MIN;
        maxY = Math.DOUBLE_MIN;
        for(v in polygon.transformedVertices) {
            if(v.x <= minX) minX = v.x;
            if(v.y <= minY) minY = v.y;
            if(v.x >= maxX) maxX = v.x;
            if(v.y >= maxY) maxY = v.y;
        }
    }

    function getAbsoluteVertices(): Array<Vector> {
        final oldX = polygon.x;
        final oldY = polygon.y;
        polygon.scaleX = entity.scaleX;
        polygon.scaleY = entity.scaleY;
        final vs = polygon.transformedVertices.copy();
        final vs = polygon.transformedVertices.map(v -> {
            v.x = (position.x * (entity.scaleX - 1)) + v.x;
            v.y = (position.y * (entity.scaleY - 1)) + v.y;
            return v;
        });
        polygon.scaleX = 1;
        polygon.scaleY = 1;
        polygon.x = oldX;
        polygon.y = oldY;
        return vs;
    }

    override function get_bounds(): Bounds {
        innerBounds.x = absoluteX + minX;
        innerBounds.y = absoluteY + minY;
        innerBounds.width = maxX - minX;
        innerBounds.height = maxY - minY;
        return innerBounds;
    }

    override function get_width(): Float
        return maxX - minX;

    override function get_height(): Float
        return maxY - minY;

    override function get_left(): Float
        return position.x + minX;

    override function set_left(v: Float): Float
        return position.x = v + minX;

    override function get_top(): Float
        return position.y + minY;

    override function set_top(v: Float): Float
        return position.y = v + minY;

    override function get_right(): Float
        return position.x + maxX;

    override function set_right(v: Float): Float
        return position.x = v + maxX;

    override function get_bottom(): Float
        return position.y + maxY;

    override function set_bottom(v: Float): Float
        return position.y = v + maxY;

    #if heaps
    override function debugDraw(graphics: Graphics) {
        final vs = getAbsoluteVertices();
        for(v in vs.concat([vs[0]])) {
            graphics.lineTo(absoluteX + v.x, absoluteY + v.y);
        }
    }
    #end

    override function clone(): Collider {
        final poly = new Polygon(position.x, position.y, vertices.map(v -> new Vector2(v.x, v.y)));
        poly.rotation = rotation;
        return poly;
    }

    override function collidePoint(p: Vector2): Bool
        return Collide.polyVsPoint(absolutePosition, polygon, p);

    override function collideBounds(bounds: Bounds): Bool
        return Collide.polyVsRect(absolutePosition, polygon, bounds.x, bounds.y, bounds.width, bounds.height, 0);

    override function intersectLine(from: Vector2, to: Vector2): Option<HitPosition>
        return Collide.intersectPolyVsLine(absolutePosition, polygon, from, to);

    override function collideLine(from: Vector2, to: Vector2): Bool
        return Collide.polyVsLine(absolutePosition, polygon, from, to);

    override function collideCircle(circle: Circle): Bool
        return Collide.polyVsCircle(absolutePosition, polygon, circle.absolutePosition, circle.radius);

    override function collideGrid(grid: Grid): Bool {
        final testBounds = grid.collideBounds(this.bounds);
        return testBounds;
    }

    override function collideHitbox(hitbox: Hitbox): Bool
        return collideBounds(hitbox.bounds);

    override function collideList(collider: ColliderList): Bool
        return collider.collidePolygon(this);

    override function collidePolygon(polygon: Polygon): Bool
        return Collide.polyVsPoly(absolutePosition, this.polygon, polygon.absolutePosition, polygon.polygon);

    public inline static function rect(x: Float, y: Float, width: Float, height: Float, rotation: Float = 0): Polygon {
        final vs = [
            new Vector2(x, y),
            new Vector2(x + width, y),
            new Vector2(x + width, y + height),
            new Vector2(x, y + height),
        ];
        final poly = new Polygon(x, y, vs);
        poly.rotation = rotation;
        return poly;
    }
}
