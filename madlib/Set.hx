package madlib;

/**
 * Implementation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Set.hx
 */
abstract Set<T>(Map<T, Bool>) {
    inline function new(map: Map<T, Bool>)
        this = map;

    public inline static function createString(?it: Iterable<String>) {
        final map: Map<String, Bool> = new Map();
        final set: Set<String> = new Set(map);
        if(it != null) set.pushMany(it);
        return set;
    }

    public inline static function createInt(?it: Iterable<Int>): Set<Int> {
        final map: Map<Int, Bool> = new Map();
        final set: Set<Int> = new Set(map);
        if(it != null) set.pushMany(it);
        return set;
    }

    public inline static function createObject<T: {}>(?it: Iterable<T>): Set<T> {
        final map: Map<T, Bool> = new Map();
        final set: Set<T> = new Set(map);
        if(it != null) set.pushMany(it);
        return set;
    }

    public inline static function createEnum<T: EnumValue>(?it: Iterable<T>): Set<T> {
        final map: Map<T, Bool> = new Map();
        final set: Set<T> = new Set(map);
        if(it != null) set.pushMany(it);
        return set;
    }

    public var length(get, never): Int;

    inline function get_length(): Int {
        var l = 0;
        for(i in this)
            ++l;
        return l;
    }

    public inline function push(v: T)
        this.set(v, true);

    public inline function add(v: T): Bool
        return if(this.exists(v)) {
            false;
        } else {
            this.set(v, true);
            true;
        }

    public inline function empty(): Set<T> {
        final inst: Map<T, Bool> = Type.createInstance(Type.getClass(this), []);
        return new Set(inst);
    }

    public inline function copy(): Set<T> {
        final inst = empty();
        for(k in this.keys())
            inst.push(k);
        return inst;
    }

    public inline function difference(other: Set<T>): Set<T> {
        final result = copy();
        for(item in result)
            result.remove(item);
        return result;
    }

    public inline function filter(pred: T -> Bool): Set<T>
        return reduce(empty(), (acc, v) -> {
            if(pred(v)) acc.add(v);
            return acc;
        });

    public inline function map<R>(f: T -> R): Array<R>
        return reduce([], (acc, v) -> {
            acc.push(f(v));
            return acc;
        });

    public inline function exists(v: T): Bool
        return this.exists(v);

    public inline function remove(v: T): Bool
        return this.remove(v);

    public inline function intersection(other: Set<T>): Set<T> {
        final result = empty();
        for(item in iterator())
            if(result.exists(item))
                result.push(item);
        return result;
    }

    public inline function pushMany(values: Iterable<T>) {
        for(value in values)
            push(value);
    }

    public inline function iterator()
        return this.keys();

    public inline function reduce<R>(init: R, f: R -> T -> R): R {
        for(v in iterator())
            init = f(init, v);
        return init;
    }

    public inline function union(other: Set<T>): Set<T> {
        final newSet = copy();
        newSet.pushMany(other);
        return newSet;
    }

    @:to public inline function toArray(): Array<T> {
        final result: Array<T> = [];
        for(k in iterator())
            result.push(k);
        return result;
    }

    @:to public inline function toString(): String
        return '{${toArray().join(", ")}}';
}
