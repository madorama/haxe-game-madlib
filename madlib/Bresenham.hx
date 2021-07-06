package madlib;

class Bresenham {
    public inline static function line(x0: Int, y0: Int, x1: Int, y1: Int): Array<{x: Int, y: Int}> {
        final dx = Math.abs(x1 - x0);
        final dy = Math.abs(y1 - y0);
        final sx = if(x0 < x1) 1 else -1;
        final sy = if(y0 < y1) 1 else -1;

        var err = dx - dy;
        final lines = [];

        while(true) {
            lines.push({ x: x0, y: y0 });
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

        return lines;
    }

    public inline static function iterateLine(x0: Int, y0: Int, x1: Int, y1: Int, cb: Int -> Int -> Void) {
        final dx = Math.abs(x1 - x0);
        final dy = Math.abs(y1 - y0);
        final sx = if(x0 < x1) 1 else -1;
        final sy = if(y0 < y1) 1 else -1;

        var err = dx - dy;
        while(true) {
            cb(x0, y0);
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
    }
}
