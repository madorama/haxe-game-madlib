package madlib.extensions;

import haxe.ds.Option;

class OptionExt {
    public inline static function withDefault<T>(self: Option<T>, defaultValue: T): T
        return switch self {
            case Some(v):
                v;
            case None:
                defaultValue;
        }

    public inline static function withDefaultLazy<T>(self: Option<T>, f: () -> T): T
        return switch self {
            case Some(v):
                v;
            case None:
                f();
        }

    public inline static function map<T, R>(self: Option<T>, f: T -> R): Option<R>
        return switch self {
            case Some(v):
                Some(f(v));
            case None:
                None;
        }

    public inline static function flatten<T>(self: Option<Option<T>>): Option<T>
        return switch self {
            case Some(v):
                v;
            case None:
                None;
        }

    public inline static function flatMap<T, R>(self: Option<T>, f: T -> Option<R>): Option<R>
        return switch self {
            case Some(v):
                f(v);
            case None:
                None;
        }

    public inline static function isNone<T>(self: Option<T>): Bool
        return switch self {
            case None: true;
            default: false;
        }

    public inline static function exists<T>(self: Option<T>, predicate: T -> Bool): Bool
        return switch self {
            case Some(v):
                predicate(v);
            case None:
                false;
        }

    public inline static function contains<T>(self: Option<T>, value: T): Bool
        return switch self {
            case Some(v):
                v == value;
            case None:
                false;
        }

    public inline static function each<T>(self: Option<T>, action: T -> Void) {
        switch self {
            case None:
            case Some(v):
                action(v);
        }
    }

    public inline static function ofValue<T>(value: Null<T>): Option<T>
        return if(value == null) None else Some(value);

    public inline static function toArray<T>(self: Option<T>): Array<T>
        return switch self {
            case Some(v):
                [v];
            case None:
                [];
        }

    public inline static function get<T>(self: Option<T>): Null<T>
        return switch self {
            case Some(v):
                v;
            case None:
                null;
        }
}
