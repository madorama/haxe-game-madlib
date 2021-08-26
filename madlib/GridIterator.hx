package madlib;

class GridIterator {
    final width = 0;
    final height = 0;
    var i: Int = 0;

    public inline function new(w: Int, h: Int) {
        width = w;
        height = h;
    }

    public inline function hasNext() {
        return i < width * height;
    }

    public inline function next() {
        return new GridIteratorObject(i++, width);
    }
}

class GridIteratorObject {
    public var index(default, null): Int;
    public var x(default, null): Int;
    public var y(default, null): Int;

    public inline function new(index: Int, gridWidth: Int) {
        this.index = index;
        this.x = index % gridWidth;
        this.y = Std.int(index / gridWidth);
    }
}
