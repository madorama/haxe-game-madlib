package madlib.extensions;

class FloatExt {
    public inline static function compare(x: Float, y: Float): Int {
        return if(x < y) -1 else if(x > y) 1 else 0;
    }

    public static var order(default, never) = Ord.fromIntComparison(compare);
}
