package madlib.collider;

import hxmath.math.Vector2;
import madlib.Option;
import madlib.collider.Collider.HitPosition;
import madlib.geom.Bounds;
import thx.error.NotImplemented;

using madlib.extensions.ArrayExt;

class ColliderList extends Collider {
    final colliders: Array<Collider>;

    public function new(colliders: Array<Collider>) {
        super();
        this.colliders = colliders;
        type = List;
    }

    public function add(adds: Array<Collider>) {
        for(c in adds) {
            if(entity != null)
                c.added(entity);

            if(colliders.contains(c))
                continue;

            colliders.push(c);
        }
    }

    public function remove(removes: Array<Collider>) {
        for(c in removes)
            colliders.remove(c);
    }

    override function added(entity: Entity) {
        super.added(entity);
        for(c in colliders)
            c.added(entity);
    }

    override function get_width(): Float
        return right - left;

    override function set_width(v: Float): Float
        throw new NotImplemented();

    override function get_height(): Float
        return bottom - top;

    override function set_height(v: Float): Float
        throw new NotImplemented();

    override function get_left(): Float {
        var left = colliders[0].left;
        for(c in colliders) {
            if(c.left < left)
                left = c.left;
        }
        return left;
    }

    override function set_left(v: Float): Float {
        final changeX = v - left;
        for(_ in colliders)
            position.x += changeX;
        return left;
    }

    override function get_right(): Float {
        var right = colliders[0].right;
        for(c in colliders) {
            if(c.right > right)
                right = c.right;
        }
        return right;
    }

    override function set_right(v: Float): Float {
        final changeX = v - right;
        for(_ in colliders)
            position.x += changeX;
        return right;
    }

    override function get_top(): Float {
        var top = colliders[0].top;
        for(c in colliders) {
            if(c.top < top)
                top = c.top;
        }
        return top;
    }

    override function set_top(v: Float): Float {
        final changeY = v - top;
        for(_ in colliders)
            position.y += changeY;
        return top;
    }

    override function get_bottom(): Float {
        var bottom = colliders[0].bottom;
        for(c in colliders) {
            if(c.bottom > bottom)
                bottom = c.bottom;
        }
        return bottom;
    }

    override function set_bottom(v: Float): Float {
        final changeY = v - bottom;
        for(_ in colliders)
            position.y += changeY;
        return bottom;
    }

    override function clone(): Collider {
        final clones = [];
        for(c in colliders)
            clones.push(c.clone());
        return new ColliderList(clones);
    }

    #if heaps
    override function debugDraw(graphics: h2d.Graphics) {
        for(c in colliders)
            c.debugDraw(graphics);
    }
    #end

    override function collidePoint(p: Vector2): Bool {
        for(c in colliders) {
            if(c.collidePoint(p))
                return true;
        }
        return false;
    }

    override function collideBounds(bounds: Bounds): Bool {
        for(c in colliders) {
            if(c.collideBounds(bounds))
                return true;
        }
        return false;
    }

    override function intersectLine(from: Vector2, to: Vector2): Option<HitPosition> {
        var minPosition = None;
        var minLength = Math.FLOAT_MAX;
        for(c in colliders) {
            switch c.intersectLine(from, to) {
                case None:
                case Some(hit):
                    final length = Math.abs(from.length - hit.hitStart.length);
                    minLength = Math.min(minLength, length);
                    if(minLength >= length) {
                        minPosition = Some(hit);
                    }
            }
        }
        return minPosition;
    }

    override function collideLine(from: Vector2, to: Vector2): Bool {
        for(c in colliders) {
            if(c.collideLine(from, to))
                return true;
        }
        return false;
    }

    override function collideCircle(circle: Circle): Bool {
        for(c in colliders) {
            if(c.collideCircle(circle))
                return true;
        }
        return false;
    }

    override function collideGrid(grid: Grid): Bool {
        for(c in colliders) {
            if(c.collideGrid(grid))
                return true;
        }
        return false;
    }

    override function collideHitbox(hitbox: Hitbox): Bool {
        for(c in colliders) {
            if(c.collideHitbox(hitbox))
                return true;
        }
        return false;
    }

    override function collideList(list: ColliderList): Bool {
        for(c in colliders) {
            if(c.collideList(list))
                return true;
        }
        return false;
    }

    override function collidePolygon(polygon: Polygon): Bool
        return colliders.any(c -> c.collidePolygon(polygon));
}
