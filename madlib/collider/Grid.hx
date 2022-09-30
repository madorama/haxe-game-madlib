package madlib.collider;

import h2d.Graphics;
import hxmath.math.Vector2;
import madlib.geom.Bounds;
import thx.error.NotImplemented;

using madlib.extensions.ArrayExt;

class Grid extends Collider {
    var cellWidth = 0.;
    var cellHeight = 0.;
    var data: Array<Array<Bool>> = [];

    public var cellsWidth(get, never): Int;
    public var cellsHeight(get, never): Int;

    function get_cellsWidth()
        return data[0].length;

    function get_cellsHeight()
        return data.length;

    public function new(cellsWidth: Int, cellsHeight: Int, cellWidth: Float, cellHeight: Float) {
        super();
        for(iy in 0...cellsHeight) {
            data[iy] = [];
            for(_ in 0...cellsWidth)
                data[iy].push(false);
        }
        this.cellWidth = cellWidth;
        this.cellHeight = cellHeight;
        type = Grid;
    }

    public static function create(cellWidth: Float, cellHeight: Float, data: Array<Array<Bool>>): Grid {
        final grid = new Grid(data.length, data[0].length, cellWidth, cellHeight);
        for(iy in 0...data.length) {
            for(ix in 0...data[iy].length)
                grid.set(ix, iy, data[iy][ix]);
        }
        return grid;
    }

    public function clear(val: Bool = false) {
        for(iy in 0...cellsHeight) {
            for(ix in 0...cellsWidth)
                data[iy][ix] = val;
        }
    }

    public function setRect(x: Int, y: Int, w: Int, h: Int, val: Bool = true) {
        if(x < 0) {
            w += x;
            x = 0;
        }
        if(y < 0) {
            h += y;
            y = 0;
        }
        if(x + w > cellsWidth)
            w = cellsWidth - x;
        if(y + h > cellsHeight)
            h = cellsHeight - y;

        for(iy in 0...h) {
            for(ix in 0...w)
                data[y + iy][x + ix] = val;
        }
    }

    public function checkRect(x: Int, y: Int, w: Int, h: Int): Bool {
        if(x < 0) {
            w += x;
            x = 0;
        }
        if(y < 0) {
            h += y;
            y = 0;
        }
        if(x + w > cellsWidth)
            w = cellsWidth - x;
        if(y + h > cellsHeight)
            h = cellsHeight - y;

        for(iy in 0...h) {
            for(ix in 0...w) {
                if(data[y + iy][x + ix])
                    return true;
            }
        }
        return false;
    }

    public inline function get(x: Int, y: Int) {
        return x >= 0 && y >= 0 && x < cellsWidth && y < cellsHeight && data[y][x];
    }

    public inline function set(x: Int, y: Int, val: Bool) {
        data[y][x] = val;
    }

    public inline function isEmpty(): Bool {
        return data.any(columns -> columns.any(v -> v));
    }

    override function get_width(): Float
        return cellWidth * cellsWidth;

    override function set_width(v: Float): Float
        throw new NotImplemented();

    override function get_height(): Float
        return cellHeight * cellsHeight;

    override function set_height(v: Float): Float
        throw new NotImplemented();

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

    override function clone(): Collider
        return Grid.create(cellWidth, cellHeight, data.copy());

    #if heaps
    override function debugDraw(graphics: h2d.Graphics) {
        for(iy in 0...cellsHeight) {
            for(ix in 0...cellsWidth) {
                if(!get(ix, iy))
                    continue;
                final x = absoluteLeft + ix * cellWidth;
                final y = absoluteTop + iy * cellHeight;
                graphics.drawRect(x, y, cellWidth, cellHeight);
            }
        }
    }
    #end

    override function collidePoint(p: Vector2): Bool {
        if(p.x >= absoluteLeft && p.y >= absoluteTop && p.x < absoluteRight && p.y < absoluteBottom) {
            final x = Std.int((p.x - absoluteLeft) / cellWidth);
            final y = Std.int((p.y - absoluteTop) / cellHeight);
            return data[y][x];
        }
        return false;
    }

    override function collideBounds(bounds: Bounds): Bool {
        if(bounds.overlaps(this.bounds)) {
            final x = Std.int((bounds.left - absoluteLeft) / cellWidth);
            final y = Std.int((bounds.top - absoluteTop) / cellHeight);
            final w = Std.int((bounds.right - absoluteLeft - 1) / cellWidth) - x + 1;
            final h = Std.int((bounds.bottom - absoluteTop - 1) / cellHeight) - y + 1;
            return checkRect(x, y, w, h);
        }
        return false;
    }

    override function collideLine(from: Vector2, to: Vector2): Bool {
        var from = from - absolutePosition;
        var to = to - absolutePosition;
        from = new Vector2(from.x / cellWidth, from.y / cellHeight);
        to = new Vector2(to.x / cellWidth, to.y / cellHeight);

        var x0 = Std.int(from.x);
        var y0 = Std.int(from.y);
        var x1 = Std.int(to.x);
        var y1 = Std.int(to.y);
        final dx = Math.abs(x1 - x0);
        final dy = Math.abs(y1 - y0);
        final sx = if(x0 < x1) 1 else -1;
        final sy = if(y0 < y1) 1 else -1;

        var err = dx - dy;

        while(true) {
            if(get(x0, y0))
                return true;

            if(x0 == x1 && y0 == y1)
                break;

            final e2 = 2 * err;
            if(e2 > -dy) {
                err -= dy;
                x0 += sx;
            }
            if(e2 < dx) {
                err += dx;
                y0 += sy;
            }
        }

        return false;
    }

    override function collideCircle(circle: Circle): Bool
        return false;

    override function collideGrid(grid: Grid): Bool
        throw new NotImplemented();

    override function collideHitbox(hitbox: Hitbox): Bool {
        return collideBounds(hitbox.bounds);
    }

    override function collideList(list: ColliderList): Bool {
        return list.collideGrid(this);
    }

    override function collidePolygon(polygon: Polygon): Bool
        return polygon.collideGrid(this);
}
