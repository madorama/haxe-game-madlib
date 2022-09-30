package madlib.collider;

import h2d.Graphics;
import hxmath.math.Vector2;
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

    public function new(x: Float, y: Float, vertices: Array<Vector2>) {
        super();
        this.vertices = vertices.map(v -> new differ.math.Vector(v.x, v.y));

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
        width = maxX - minX;
        height = maxY - minY;

        calcBounds();

        position.set(x, y);

        type = Polygon;
    }

    function calcBounds() {
        final dx = if(entity != null) entity.pivotX * width else 0;
        final dy = if(entity != null) entity.pivotY * height else 0;
        final vs = vertices.map(v -> new differ.math.Vector(v.x - dx, v.y - dy));
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
        super.debugDraw(graphics);
        final vs = polygon.transformedVertices;
        for(v in vs.concat([vs[0]])) {
            graphics.lineTo(absoluteX + v.x, absoluteY + v.y);
        }
        graphics.endFill();
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
