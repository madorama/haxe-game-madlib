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

    public inline function toString()
        return 'Tuple3($_0, $_1, $_2)';
}
