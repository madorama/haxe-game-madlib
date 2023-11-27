package madlib.extensions;

using madlib.extensions.ArrayExt;

/**
 * Implemantation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Types.hx
 */
class TypeExt {
    public inline static function isAnonymousObject(v: Dynamic): Bool
        return Reflect.isObject(v) && null == Type.getClass(v);

    public inline static function sameType<T, U>(x: T, y: U): Bool
        return valueTypeToString(x) == valueTypeToString(y);

    inline static function toString<T>(type: Type.ValueType, rawValue: T) {
        return switch type {
            case TNull: "Null";
            case TInt: "Int";
            case TFloat: "Float";
            case TBool: "Bool";
            case TObject:
                final fields = Reflect.fields(rawValue).map(field -> '${field}:${valueTypeToString(Reflect.field(rawValue, field))}').join(",");
                '{${fields}}';
            case TFunction: "Function";
            case TClass(c): Type.getClassName(c);
            case TEnum(e): Type.getEnumName(e);
            case _: throw 'invalid type ${type}';
        }
    }

    public inline static function valueTypeToString<T>(value: T): String
        return toString(Type.typeof(value), value);
}
