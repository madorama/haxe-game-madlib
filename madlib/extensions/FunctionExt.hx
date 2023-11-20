package madlib.extensions;

class FunctionExt {
    public inline static function identity<T>(x: T): T
        return x;

    extern overload public inline static function pipe<A, B>(f1: () -> A, f2: A -> B): B
        return f2(f1());

    extern overload public inline static function pipe<A, B, C>(f1: () -> A, f2: A -> B, f3: B -> C): C
        return f3(f2(f1()));

    extern overload public inline static function pipe<A, B, C, D>(f1: () -> A, f2: A -> B, f3: B -> C, f4: C -> D): D
        return f4(f3(f2(f1())));

    extern overload public inline static function pipe<A, B, C, D, E>(f1: () -> A, f2: A -> B, f3: B -> C, f4: C -> D, f5: D -> E): E
        return f5(f4(f3(f2(f1()))));

    extern overload public inline static function pipe<A, B, C, D, E, F>(f1: () -> A, f2: A -> B, f3: B -> C, f4: C -> D, f5: D -> E, f6: E -> F): F
        return f6(f5(f4(f3(f2(f1())))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G>(f1: () -> A, f2: A -> B, f3: B -> C, f4: C -> D, f5: D -> E, f6: E -> F,
            f7: F -> G): G
        return f7(f6(f5(f4(f3(f2(f1()))))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G, H>(f1: () -> A, f2: A -> B, f3: B -> C, f4: C -> D, f5: D -> E, f6: E -> F,
            f7: F -> G, f8: G -> H): H
        return f8(f7(f6(f5(f4(f3(f2(f1())))))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G, H, I>(f1: () -> A, f2: A -> B, f3: B -> C, f4: C -> D, f5: D -> E, f6: E -> F,
            f7: F -> G, f8: G -> H, f9: H -> I): I
        return f9(f8(f7(f6(f5(f4(f3(f2(f1()))))))));

    extern overload public inline static function pipe<A, B>(value: A, f1: A -> B): B
        return f1(value);

    extern overload public inline static function pipe<A, B, C>(value: A, f1: A -> B, f2: B -> C): C
        return f2(f1(value));

    extern overload public inline static function pipe<A, B, C, D>(value: A, f1: A -> B, f2: B -> C, f3: C -> D): D
        return f3(f2(f1(value)));

    extern overload public inline static function pipe<A, B, C, D, E>(value: A, f1: A -> B, f2: B -> C, f3: C -> D, f4: D -> E): E
        return f4(f3(f2(f1(value))));

    extern overload public inline static function pipe<A, B, C, D, E, F>(value: A, f1: A -> B, f2: B -> C, f3: C -> D, f4: D -> E, f5: E -> F): F
        return f5(f4(f3(f2(f1(value)))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G>(value: A, f1: A -> B, f2: B -> C, f3: C -> D, f4: D -> E, f5: E -> F, f6: F -> G): G
        return f6(f5(f4(f3(f2(f1(value))))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G, H>(value: A, f1: A -> B, f2: B -> C, f3: C -> D, f4: D -> E, f5: E -> F,
            f6: F -> G, f7: G -> H): H
        return f7(f6(f5(f4(f3(f2(f1(value)))))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G, H, I>(value: A, f1: A -> B, f2: B -> C, f3: C -> D, f4: D -> E, f5: E -> F,
            f6: F -> G, f7: G -> H, f8: H -> I): I
        return f8(f7(f6(f5(f4(f3(f2(f1(value))))))));

    extern overload public inline static function pipe<A, B, C, D, E, F, G, H, I, J>(value: A, f1: A -> B, f2: B -> C, f3: C -> D, f4: D -> E, f5: E -> F,
            f6: F -> G, f7: G -> H, f8: H -> I, f9: I -> J): J
        return f9(f8(f7(f6(f5(f4(f3(f2(f1(value)))))))));

    extern overload public inline static function curry<A, B, C>(func: A -> B -> C): A -> (B -> C)
        return a -> b -> func(a, b);

    extern overload public inline static function curry<A, B, C, D>(func: A -> B -> C -> D): A -> (B -> (C -> D))
        return a -> b -> c -> func(a, b, c);

    extern overload public inline static function curry<A, B, C, D, E>(func: A -> B -> C -> D -> E): A -> (B -> (C -> (D -> E)))
        return a -> b -> c -> d -> func(a, b, c, d);

    extern overload public inline static function curry<A, B, C, D, E, F>(func: A -> B -> C -> D -> E -> F): A -> (B -> (C -> (D -> (E -> F))))
        return a -> b -> c -> d -> e -> func(a, b, c, d, e);

    extern overload public inline static function uncurry<A, B, C>(func: A -> (B -> C)): A -> B -> C
        return (a, b) -> func(a)(b);

    extern overload public inline static function uncurry<A, B, C, D>(func: A -> (B -> (C -> D))): A -> B -> C -> D
        return (a, b, c) -> func(a)(b)(c);

    extern overload public inline static function uncurry<A, B, C, D, E>(func: A -> (B -> (C -> (D -> E)))): A -> B -> C -> D -> E
        return (a, b, c, d) -> func(a)(b)(c)(d);

    extern overload public inline static function uncurry<A, B, C, D, E, F>(func: A -> (B -> (C -> (D -> (E -> F))))): A -> B -> C -> D -> E -> F
        return (a, b, c, d, e) -> func(a)(b)(c)(d)(e);

    extern overload public inline static function toEffect<T>(func: Void -> T): Void -> Void
        return () -> func();

    extern overload public inline static function toEffect<A, B>(func: A -> B): A -> Void
        return (a) -> func(a);

    extern overload public inline static function toEffect<A, B, C>(func: A -> B -> C): A -> B -> Void
        return (a, b) -> func(a, b);

    extern overload public inline static function toEffect<A, B, C, D>(func: A -> B -> C -> D): A -> B -> C -> Void
        return (a, b, c) -> func(a, b, c);

    extern overload public inline static function toEffect<A, B, C, D, E>(func: A -> B -> C -> D -> E): A -> B -> C -> D -> Void
        return (a, b, c, d) -> func(a, b, c, d);

    extern overload public inline static function toEffect<A, B, C, D, E, F>(func: A -> B -> C -> D -> E -> F): A -> B -> C -> D -> E -> Void
        return (a, b, c, d, e) -> func(a, b, c, d, e);

    extern overload public inline static function flip<A, B, C>(f: A -> (B -> C)): B -> (A -> C)
        return a -> b -> f(b)(a);

    extern overload public inline static function flip<A, B, C>(f: A -> B -> C): B -> A -> C
        return (a, b) -> f(b, a);

    @:nullSafety(Off)
    extern overload public inline static function lazy<A, B>(func: A -> B, a: A): Void -> B {
        var r: Null<B> = null;
        return () -> if(r == null) r = func(a) else r;
    }

    @:nullSafety(Off)
    extern overload public inline static function lazy<A, B, C>(func: A -> B -> C, a: A, b: B): Void -> C {
        var r: Null<C> = null;
        return () -> if(r == null) r = func(a, b) else r;
    }

    @:nullSafety(Off)
    extern overload public inline static function lazy<A, B, C, D>(func: A -> B -> C -> D, a: A, b: B, c: C): Void -> D {
        var r: Null<D> = null;
        return () -> if(r == null) r = func(a, b, c) else r;
    }

    @:nullSafety(Off)
    extern overload public inline static function lazy<A, B, C, D, E>(func: A -> B -> C -> D -> E, a: A, b: B, c: C, d: D): Void -> E {
        var r: Null<E> = null;
        return () -> if(r == null) r = func(a, b, c, d) else r;
    }

    @:nullSafety(Off)
    extern overload public inline static function lazy<A, B, C, D, E, F>(func: A -> B -> C -> D -> E -> F, a: A, b: B, c: C, d: D, e: E): Void -> F {
        var r: Null<F> = null;
        return () -> if(r == null) r = func(a, b, c, d, e) else r;
    }

    extern overload public inline static function compose<A, B, C>(f: A -> B, g: B -> C): A -> C
        return a -> g(f(a));

    extern overload public inline static function compose<A, B>(f: () -> A, g: A -> B): () -> B
        return () -> g(f());
}
