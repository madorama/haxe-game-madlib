package madlib;

import haxe.ds.Option;

enum Result<E, T> {
    Ok(value: T);
    Err(error: E);
}

class ResultExt {
    public inline static function withDefault<E, T>(self: Result<E, T>, value: T): T
        return switch self {
            case Ok(v):
                v;
            case Err(_):
                value;
        }

    public inline static function withDefaultLazy<E, T>(self: Result<E, T>, getValue: () -> T): T
        return switch self {
            case Ok(v):
                v;
            case Err(_):
                getValue();
        }

    public inline static function map<E, T, R>(self: Result<E, T>, f: T -> R): Result<E, R>
        return switch self {
            case Ok(v):
                Ok(f(v));
            case Err(err):
                Err(err);
        }

    public inline static function flatMap<E, T, R>(self: Result<E, T>, f: T -> Result<E, R>): Result<E, R>
        return switch self {
            case Ok(value):
                f(value);
            case Err(err):
                Err(err);
        }

    public inline static function toOption<E, T>(self: Result<E, T>): Option<T>
        return switch self {
            case Ok(value):
                Some(value);
            case Err(_):
                None;
        }

    public inline static function mapError<E, T, F>(self: Result<E, T>, f: E -> F): Result<F, T>
        return switch self {
            case Ok(value):
                Ok(value);
            case Err(err):
                Err(f(err));
        }

    public inline static function isOk<E, T>(self: Result<E, T>): Bool
        return switch self {
            case Ok(_):
                true;
            case Err(_):
                false;
        }

    public inline static function isErr<E, T>(self: Result<E, T>): Bool
        return !isOk(self);

    public inline static function unwrap<E, T, R>(self: Result<E, T>, f: T -> R, defaultValue: R): R
        return switch self {
            case Ok(value):
                f(value);
            case Err(_):
                defaultValue;
        }

    public inline static function merge<T>(self: Result<T, T>): T
        return switch self {
            case Ok(value):
                value;
            case Err(error):
                error;
        }

    public inline static function flatten<E, T>(self: Result<E, Result<E, T>>): Result<E, T>
        return switch self {
            case Ok(value):
                value;
            case Err(err):
                Err(err);
        }

    public inline static function andMap<E, T, R>(self: Result<E, T -> R>, x: Result<E, T>): Result<E, R>
        return switch self {
            case Ok(f):
                map(x, f);
            case Err(err):
                Err(err);
        }
}
