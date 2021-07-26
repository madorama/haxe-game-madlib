package madlib;

typedef Tuple<T0, T1> = Tuple2<T0, T1>;

@:structInit
class Tuple1<T0> {
    public final _0: T0;

    public inline function new(_0: T0) {
        this._0 = _0;
    }

    public inline static function of<T0>(_0: T0): Tuple1<T0>
        return new Tuple1(_0);

    public inline function map<X>(f: T0 -> X): Tuple1<X>
        return new Tuple1(f(_0));

    public inline function apply<R>(f: T0 -> R): R
        return f(_0);

    public inline function toString()
        return 'Tuple1($_0)';
}

@:structInit
@:tink class Tuple2<T0, T1> {
    public final _0: T0;
    public final _1: T1;

    public inline function new(_0: T0, _1: T1) {
        this._0 = _0;
        this._1 = _1;
    }

    public inline static function of<T0, T1>(_0: T0, _1: T1): Tuple2<T0, T1>
        return new Tuple2(_0, _1);

    @:calculated var left = _0;

    @:calculated var right = _1;

    public inline function flip(): Tuple2<T1, T0>
        return new Tuple2(_1, _0);

    public inline function dropLeft(): Tuple1<T1>
        return new Tuple1(_1);

    public inline function dropRight(): Tuple1<T0>
        return new Tuple1(_0);

    public inline function mapFirst<X>(f: T0 -> X): Tuple2<X, T1>
        return new Tuple2(f(_0), _1);

    public inline function mapSecond<X>(f: T1 -> X): Tuple2<T0, X>
        return new Tuple2(_0, f(_1));

    public inline function mapPair<X, Y>(f0: T0 -> X, f1: T1 -> Y): Tuple2<X, Y>
        return new Tuple2(f0(_0), f1(_1));

    public inline function apply<R>(f: T0 -> T1 -> R): R
        return f(_0, _1);

    public inline function toString()
        return 'Tuple2($_0, $_1)';
}

@:structInit
class Tuple3<T0, T1, T2> {
    public final _0: T0;
    public final _1: T1;
    public final _2: T2;

    public inline function new(_0: T0, _1: T1, _2: T2) {
        this._0 = _0;
        this._1 = _1;
        this._2 = _2;
    }

    public inline function flip(): Tuple3<T2, T1, T0>
        return new Tuple3(_2, _1, _0);

    public inline function dropLeft(): Tuple2<T1, T2>
        return new Tuple2(_1, _2);

    public inline function dropRight(): Tuple2<T0, T1>
        return new Tuple2(_0, _1);

    public inline function mapFirst<X>(f: T0 -> X): Tuple3<X, T1, T2>
        return new Tuple3(f(_0), _1, _2);

    public inline function mapSecond<X>(f: T1 -> X): Tuple3<T0, X, T2>
        return new Tuple3(_0, f(_1), _2);

    public inline function mapThird<X>(f: T2 -> X): Tuple3<T0, T1, X>
        return new Tuple3(_0, _1, f(_2));

    public inline function mapAll<X, Y, Z>(f0: T0 -> X, f1: T1 -> Y, f2: T2 -> Z): Tuple3<X, Y, Z>
        return new Tuple3(f0(_0), f1(_1), f2(_2));

    public inline function apply<R>(f: T0 -> T1 -> T2 -> R): R
        return f(_0, _1, _2);

    public inline function toString()
        return 'Tuple3($_0, $_1, $_2)';
}
