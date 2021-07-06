package madlib.extensions;

class FunctionExt {
    public inline static function identity<T>(x: T): T
        return x;
}

class Function0Ext {
    public inline static function toEffect<T>(func: Void -> T): Void -> Void
        return () -> func();
}

class Function1Ext {
    public inline static function lazy<A, R>(func: A -> R, v: A): Void -> R {
        var r: Null<R> = null;
        return () -> if(r == null) r = func(v) else r;
    }

    public inline static function toEffect<A, R>(func: A -> R): A -> Void
        return (a) -> func(a);
}

class Function2Ext {
    public inline static function curry<A, B, R>(func: A -> B -> R): A -> (B -> R)
        return a -> b -> func(a, b);

    public inline static function uncurry<A, B, R>(func: A -> (B -> R)): A -> B -> R
        return (a, b) -> func(a)(b);

    public inline static function flip<A, B, R>(func: A -> B -> R): B -> A -> R
        return (b, a) -> func(a, b);

    public inline static function lazy<A, B, R>(func: A -> B -> R, a: A, b: B): Void -> R {
        var r: Null<R> = null;
        return () -> if(r == null) r = func(a, b) else r;
    }

    public inline static function toEffect<A, B, R>(func: A -> B -> R): A -> B -> Void
        return (a, b) -> func(a, b);
}

class Function3Ext {
    public inline static function curry<A, B, C, R>(func: A -> B -> C -> R): A -> (B -> (C -> R))
        return a -> b -> c -> func(a, b, c);

    public inline static function uncurry<A, B, C, R>(func: A -> (B -> (C -> R))): A -> B -> C -> R
        return (a, b, c) -> func(a)(b)(c);

    public inline static function lazy<A, B, C, R>(func: A -> B -> C -> R, a: A, b: B, c: C): Void -> R {
        var r: Null<R> = null;
        return () -> if(r == null) r = func(a, b, c) else r;
    }

    public inline static function toEffect<A, B, C, R>(func: A -> B -> C -> R): A -> B -> C -> Void
        return (a, b, c) -> func(a, b, c);
}

class Function4Ext {
    public inline static function curry<A, B, C, D, R>(func: A -> B -> C -> D -> R): A -> (B -> (C -> (D -> R)))
        return a -> b -> c -> d -> func(a, b, c, d);

    public inline static function uncurry<A, B, C, D, R>(func: A -> (B -> (C -> (D -> R)))): A -> B -> C -> D -> R
        return (a, b, c, d) -> func(a)(b)(c)(d);

    public inline static function lazy<A, B, C, D, R>(func: A -> B -> C -> D -> R, a: A, b: B, c: C, d: D): Void -> R {
        var r: Null<R> = null;
        return () -> if(r == null) r = func(a, b, c, d) else r;
    }

    public inline static function toEffect<A, B, C, D, R>(func: A -> B -> C -> D -> R): A -> B -> C -> D -> Void
        return (a, b, c, d) -> func(a, b, c, d);
}

class Function5Ext {
    public inline static function curry<A, B, C, D, E, R>(func: A -> B -> C -> D -> E -> R): A -> (B -> (C -> (D -> (E -> R))))
        return a -> b -> c -> d -> e -> func(a, b, c, d, e);

    public inline static function uncurry<A, B, C, D, E, R>(func: A -> (B -> (C -> (D -> (E -> R))))): A -> B -> C -> D -> E -> R
        return (a, b, c, d, e) -> func(a)(b)(c)(d)(e);

    public inline static function lazy<A, B, C, D, E, R>(func: A -> B -> C -> D -> E -> R, a: A, b: B, c: C, d: D, e: E): Void -> R {
        var r: Null<R> = null;
        return () -> if(r == null) r = func(a, b, c, d, e) else r;
    }

    public inline static function toEffect<A, B, C, D, E, R>(func: A -> B -> C -> D -> E -> R): A -> B -> C -> D -> E -> Void
        return (a, b, c, d, e) -> func(a, b, c, d, e);
}

class Function6Ext {
    public inline static function curry<A, B, C, D, E, F, R>(func: A -> B -> C -> D -> E -> F -> R): A -> (B -> (C -> (D -> (E -> (F -> R)))))
        return a -> b -> c -> d -> e -> f -> func(a, b, c, d, e, f);

    public inline static function uncurry<A, B, C, D, E, F, R>(func: A -> (B -> (C -> (D -> (E -> (F -> R)))))): A -> B -> C -> D -> E -> F -> R
        return (a, b, c, d, e, f) -> func(a)(b)(c)(d)(e)(f);

    public inline static function lazy<A, B, C, D, E, F, R>(func: A -> B -> C -> D -> E -> F -> R, a: A, b: B, c: C, d: D, e: E, f: F): Void -> R {
        var r: Null<R> = null;
        return () -> if(r == null) r = func(a, b, c, d, e, f) else r;
    }

    public inline static function toEffect<A, B, C, D, E, F, R>(func: A -> B -> C -> D -> E -> F -> R): A -> B -> C -> D -> E -> F -> Void
        return (a, b, c, d, e, f) -> func(a, b, c, d, e, f);
}
