package madlib;

import polygonal.ds.Comparable;

typedef ComparableOrd<T> = {
    public function compare(that: T): Ordering;
}

/**
 * Implementation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Ord.hx
 */
abstract Ordering(OrderingImpl) from OrderingImpl to OrderingImpl {
    public inline static function fromInt(value: Int): Ordering
        return value < 0 ? LT : (value > 0 ? GT : EQ);

    public inline static function fromFloat(value: Float): Ordering
        return value < 0 ? LT : (value > 0 ? GT : EQ);

    public inline function toInt(): Int
        return switch this {
            case LT: -1;
            case GT: 1;
            case EQ: 0;
        };
}

@:using(madlib.Ord.OrderingExt)
enum OrderingImpl {
    LT;
    GT;
    EQ;
}

class OrderingExt {
    public inline static function negate(o: Ordering): Ordering
        return switch o {
            case LT: GT;
            case EQ: EQ;
            case GT: LT;
        }
}

@:callable
abstract Ord<A>(A -> A -> Ordering) from A -> A -> Ordering to A -> A -> Ordering {
    public inline function order(a0: A, a1: A): Ordering
        return this(a0, a1);

    public inline function max(a0: A, a1: A): A
        return switch this(a0, a1) {
            case LT | EQ: a1;
            case GT: a0;
        }

    public inline function min(a0: A, a1: A): A
        return switch this(a0, a1) {
            case LT | EQ: a0;
            case GT: a1;
        }

    public inline function equal(a0: A, a1: A): Bool
        return this(a0, a1) == EQ;

    public inline function contramap<B>(f: B -> A): Ord<B>
        return (b0, b1) -> this(f(b0), f(b1));

    public inline function inverse(): Ord<A>
        return (a0, a1) -> this(a1, a0);

    public inline function intComparison(a0: A, a1: A): Int
        return switch this(a0, a1) {
            case LT: -1;
            case EQ: 0;
            case GT: 1;
        };

    public inline static function fromIntComparison<A>(f: A -> A -> Int): Ord<A>
        return (a, b) -> return Ordering.fromInt(f(a, b));

    public inline static function forComparable<T: Comparable<T>>(): Ord<T>
        return (a: T, b: T) -> Ordering.fromInt(a.compare(b));

    public inline static function forComparableOrd<T: ComparableOrd<T>>(): Ord<T>
        return (a: T, b: T) -> a.compare(b);
}
