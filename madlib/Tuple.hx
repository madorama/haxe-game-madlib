package madlib;

typedef Tuple<T0, T1> = Tuple2<T0, T1>;

@:structInit
private class AbsTuple1<T0> {
    public final _0: T0;

    public inline function new(_0: T0)
        this._0 = _0;
}

@:forward(_0)
abstract Tuple1<T0>(AbsTuple1<T0>) from AbsTuple1<T0> {
    public inline function new(_0: T0)
        this = new AbsTuple1(_0);

    public inline static function of<T0>(_0: T0): Tuple1<T0>
        return new Tuple1(_0);

    public inline function map<X>(f: T0 -> X): Tuple1<X>
        return new Tuple1(f(this._0));

    public inline function apply<R>(f: T0 -> R): R
        return f(this._0);

    @:op(A == B)
    inline static function equals<T0>(x: Tuple1<T0>, y: Tuple1<T0>): Bool
        return x._0 == y._0;

    @:op(A != B)
    inline static function notEquals<T0>(x: Tuple1<T0>, y: Tuple1<T0>): Bool
        return !equals(x, y);

    public inline function toString()
        return 'Tuple1(${this._0})';
}

@:structInit
@:tink private class AbsTuple2<T0, T1> {
    public final _0: T0;
    public final _1: T1;

    public inline function new(_0: T0, _1: T1) {
        this._0 = _0;
        this._1 = _1;
    }

    @:calculated inline var left = _0;

    @:calculated inline var right = _1;
}

@:forward(_0, _1, left, right)
abstract Tuple2<T0, T1>(AbsTuple2<T0, T1>) from AbsTuple2<T0, T1> {
    public inline function new(_0: T0, _1: T1)
        this = new AbsTuple2(_0, _1);

    public inline static function of<T0, T1>(_0: T0, _1: T1): Tuple2<T0, T1>
        return new Tuple2(_0, _1);

    public inline function flip(): Tuple2<T1, T0>
        return new Tuple2(this._1, this._0);

    public inline function dropLeft(): Tuple1<T1>
        return new Tuple1(this._1);

    public inline function dropRight(): Tuple1<T0>
        return new Tuple1(this._0);

    public inline function mapFirst<X>(f: T0 -> X): Tuple2<X, T1>
        return new Tuple2(f(this._0), this._1);

    public inline function mapSecond<X>(f: T1 -> X): Tuple2<T0, X>
        return new Tuple2(this._0, f(this._1));

    public inline function mapPair<X, Y>(f0: T0 -> X, f1: T1 -> Y): Tuple2<X, Y>
        return new Tuple2(f0(this._0), f1(this._1));

    public inline function apply<R>(f: T0 -> T1 -> R): R
        return f(this._0, this._1);

    @:op(A == B)
    inline static function equals<T0, T1>(x: Tuple2<T0, T1>, y: Tuple2<T0, T1>): Bool
        return x.left == y.left && x.right == y.right;

    @:op(A != B)
    inline static function notEquals<T0, T1>(x: Tuple2<T0, T1>, y: Tuple2<T0, T1>): Bool
        return !equals(x, y);

    public inline function toString()
        return 'Tuple2(${this._0}, ${this._1})';
}

@:structInit
private class AbsTuple3<T0, T1, T2> {
    public final _0: T0;
    public final _1: T1;
    public final _2: T2;

    public inline function new(_0: T0, _1: T1, _2: T2) {
        this._0 = _0;
        this._1 = _1;
        this._2 = _2;
    }
}

@:forward(_0, _1, _2)
abstract Tuple3<T0, T1, T2>(AbsTuple3<T0, T1, T2>) from AbsTuple3<T0, T1, T2> {
    public inline function new(_0: T0, _1: T1, _2: T2)
        this = new AbsTuple3(_0, _1, _2);

    public inline static function of<T0, T1, T2>(_0: T0, _1: T1, _2: T2): Tuple3<T0, T1, T2>
        return new Tuple3(_0, _1, _2);

    public inline function flip(): Tuple3<T2, T1, T0>
        return new Tuple3(this._2, this._1, this._0);

    public inline function dropLeft(): Tuple2<T1, T2>
        return new Tuple2(this._1, this._2);

    public inline function dropRight(): Tuple2<T0, T1>
        return new Tuple2(this._0, this._1);

    public inline function mapFirst<X>(f: T0 -> X): Tuple3<X, T1, T2>
        return new Tuple3(f(this._0), this._1, this._2);

    public inline function mapSecond<X>(f: T1 -> X): Tuple3<T0, X, T2>
        return new Tuple3(this._0, f(this._1), this._2);

    public inline function mapThird<X>(f: T2 -> X): Tuple3<T0, T1, X>
        return new Tuple3(this._0, this._1, f(this._2));

    public inline function mapAll<X, Y, Z>(f0: T0 -> X, f1: T1 -> Y, f2: T2 -> Z): Tuple3<X, Y, Z>
        return new Tuple3(f0(this._0), f1(this._1), f2(this._2));

    public inline function apply<R>(f: T0 -> T1 -> T2 -> R): R
        return f(this._0, this._1, this._2);

    @:op(A == B)
    inline static function equals<T0, T1, T2>(x: Tuple3<T0, T1, T2>, y: Tuple3<T0, T1, T2>): Bool
        return x._0 == y._0 && x._1 == y._1 && x._2 == y._2;

    @:op(A != B)
    inline static function notEquals<T0, T1, T2>(x: Tuple3<T0, T1, T2>, y: Tuple3<T0, T1, T2>): Bool
        return !equals(x, y);

    public inline function toString()
        return 'Tuple3(${this._0}, ${this._1}, ${this._2})';
}
