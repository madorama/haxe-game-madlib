package madlib.extensions;

import madlib.Ord.OrderingImpl;

class IntExt {
    public inline static function compare(x: Int, y: Int): Int
        return if(x < y) -1 else if(x > y) 1 else 0;

    public static var order(default, never): Ord<Int> = (i0, i1) -> if(i0 > i1) GT else if(i0 == i1) EQ else LT;
}
