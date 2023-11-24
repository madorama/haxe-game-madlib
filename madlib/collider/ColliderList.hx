package madlib.collider;

import hxmath.math.Vector2;
import madlib.Option;
import madlib.collider.Collider.HitPosition;
import madlib.geom.Bounds;
import thx.error.NotImplemented;

using madlib.extensions.ArrayExt;

class ColliderList extends Collider {
    final colliders: Array<Collider>;

    public function new(colliders: Array<Collider>, ?entity: Entity) {
        super(entity);
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
        calcCache();
    }

    public function remove(removes: Array<Collider>) {
        for(c in removes)
            colliders.remove(c);
        calcCache();
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

    var _left: Float = 0;
    var _right: Float = 0;
    var _top: Float = 0;
    var _bottom: Float = 0;

    inline function calcCache() {
        _left = colliders[0].left;
        _right = colliders[0].right;
        _top = colliders[0].top;
        _bottom = colliders[0].bottom;

        for(c in colliders) {
            if(c.left < _left)
                _left = c.left;
            if(c.right > _right)
                _right = c.right;
            if(c.top < _top)
                _top = c.top;
            if(c.bottom > _bottom)
                _bottom = c.bottom;
        }
    }

    override function get_left(): Float
        return _left;

    override function set_left(v: Float): Float {
        final changeX = v - left;
        for(c in colliders)
            c.left += changeX;
        position.x += changeX;
        return left;
    }

    override function get_right(): Float
        return _right;

    override function set_right(v: Float): Float {
        final changeX = v - right;
        for(c in colliders)
            c.right += changeX;
        position.x += changeX;
        return right;
    }

    override function get_top(): Float
        return _top;

    override function set_top(v: Float): Float {
        final changeY = v - top;
        for(c in colliders)
            c.top += changeY;
        position.y += changeY;
        return top;
    }

    override function get_bottom(): Float
        return _bottom;

    override function set_bottom(v: Float): Float {
        final changeY = v - bottom;
        for(c in colliders)
            c.bottom += changeY;
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
