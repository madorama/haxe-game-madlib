package madlib.extensions;

import madlib.Option;

class NullExt {
    public inline static function withDefault<T>(self: Null<T>, value: T): T
        return self ?? value;

    public inline static function withDefaultLazy<T>(self: Null<T>, f: () -> T): T
        return self ?? f();

    public inline static function toOption<T>(self: Null<T>): Option<T>
        return if(self == null) None else Some(self);

    public inline static function isNull<T>(self: Null<T>): Bool
        return self == null;

    public inline static function each<T>(self: Null<T>, action: T -> Void): Void {
        if(self != null)
            action(self);
    }

    public inline static function map<T, R>(self: Null<T>, f: T -> R): Null<R>
        return if(self != null) f(self) else null;
}
