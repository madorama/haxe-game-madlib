package madlib.extensions;

/**
 * Implementation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Enums.hx
 */
class EnumExt {
    public inline static function compare<T: EnumValue>(x: T, y: T): Int {
        final v = IntExt.compare(Type.enumIndex(x), Type.enumIndex(y));
        return if(v != 0) v else ArrayExt.compare(Type.enumParameters(x), Type.enumParameters(y));
    }

    public inline static function string<T: EnumValue>(x: T) {
        final cons = Type.enumConstructor(x);
        final params = [];
        for(param in Type.enumParameters(x))
            params.push(DynamicExt.string(x));
        return cons + (if(params.length == 0) "" else '(${params.join(", ")})');
    }
}
