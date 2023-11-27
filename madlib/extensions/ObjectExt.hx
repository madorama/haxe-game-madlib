package madlib.extensions;

/**
 * Implementation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Objects.hx
 */
class ObjectExt {
    public inline static function compare(x: {}, y: {}): Int {
        var v = 0;
        var fields = [];
        if((v = ArrayExt.compare((fields = Reflect.fields(x)), Reflect.fields(y))) == 0) {
            for(field in fields) {
                if((v = DynamicExt.compare(Reflect.field(x, field), Reflect.field(y, field))) != 0)
                    break;
            }
        }
        return v;
    }

    public inline static function string(o: {}): String {
        final fields = Reflect.fields(o).map(field -> {
            final v = Reflect.field(o, field);
            final s = if(Std.isOfType(v, String)) {
                StringExt.quote((v: String));
            } else {
                DynamicExt.string(v);
            }
            return '${field} : ${s}';
        });
        return '{${fields.join(", ")}}';
    }

    public inline static function isEmpty(o: {}): Bool
        return size(o) == 0;

    public inline static function size(o: {}): Int
        return Reflect.fields(o).length;
}
