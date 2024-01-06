package madlib.extensions;

import haxe.Exception;

/**
 * implementation based on:
 * https://github.com/fponticelli/thx.core/blob/master/src/thx/Dynamics.hx
 */
class DynamicExt {
    public static function equals<T, U>(a: T, b: U): Bool {
        if(!TypeExt.sameType(a, b)) return false;

        if(untyped a == b) return true;

        switch Type.typeof(a) {
            case TFloat, TNull, TInt, TBool:
                return false;
            case TFunction:
                return Reflect.compareMethods(a, b);
            case TClass(c):
                final ca = Type.getClassName(c);
                final c = Type.getClass(b);
                if(c == null) return false;
                final cb = Type.getClassName(c);
                if(ca != cb) return false;

                if(Std.isOfType(a, String)) return false;

                if(Std.isOfType(a, Array)) {
                    final aa: Array<Dynamic> = cast a;
                    final ab: Array<Dynamic> = cast b;
                    if(aa.length != ab.length) return false;
                    for(i in 0...aa.length)
                        if(!equals(aa[i], ab[i]))
                            return false;
                    return true;
                }

                if(Std.isOfType(a, Date)) return untyped a.getTime() == b.getTime();

                if(MapExt.isMap(a)) {
                    final ha: Map<Dynamic, Dynamic> = cast a;
                    final hb: Map<Dynamic, Dynamic> = cast b;
                    final ka = IteratorExt.toArray(ha.keys());
                    final kb = IteratorExt.toArray(hb.keys());
                    if(ka.length != kb.length) return false;
                    for(key in ka)
                        if(!hb.exists(key) || !equals(ha.get(key), hb.get(key)))
                            return false;
                    return true;
                }

                var t = false;
                if((t = IteratorExt.isIterator(a)) || IterableExt.isIterable(a)) {
                    final va = t ? IteratorExt.toArray(cast a) : IterableExt.toArray(cast a);
                    final vb = t ? IteratorExt.toArray(cast b) : IterableExt.toArray(cast b);
                    if(va.length != vb.length) return false;
                    for(i in 0...va.length)
                        if(!equals(va[i], vb[i]))
                            return false;
                    return true;
                }

                var f = null;
                if(Reflect.hasField(a, 'equals') && Reflect.isFunction(f = Reflect.field(a, 'equals')))
                    return Reflect.callMethod(a, f, [b]);

                final c = Type.getClass(a);
                if(c == null) return false;
                final fields = Type.getInstanceFields(c);
                for(field in fields) {
                    final va = Reflect.field(a, field);
                    if(Reflect.isFunction(va)) continue;
                    final vb = Reflect.field(b, field);
                    if(!equals(va, vb)) return false;
                }
                return true;
            case TEnum(e):
                final ea = Type.getEnumName(e);
                final teb = Type.getEnum(cast b);
                final eb = Type.getEnumName(teb);
                if(ea != eb) return false;

                if(Type.enumIndex(cast a) != Type.enumIndex(cast b)) return false;
                final pa = Type.enumParameters(cast a);
                final pb = Type.enumParameters(cast b);
                for(i in 0...pa.length)
                    if(!equals(pa[i], pb[i]))
                        return false;
                return true;
            case TObject:
                final fa = Reflect.fields(a);
                final fb = Reflect.fields(b);
                for(field in fa) {
                    fb.remove(field);
                    if(!Reflect.hasField(b, field)) return false;
                    final va = Reflect.field(a, field);
                    if(Reflect.isFunction(va)) continue;
                    final vb = Reflect.field(b, field);
                    if(!equals(va, vb)) return false;
                }
                if(fb.length > 0) return false;

                var t = false;
                if((t = IteratorExt.isIterator(a)) || IterableExt.isIterable(a)) {
                    if(t && !IteratorExt.isIterator(b)) return false;
                    if(!t && !IterableExt.isIterable(b)) return false;

                    final aa = t ? IteratorExt.toArray(cast a) : IterableExt.toArray(cast a);
                    final ab = t ? IteratorExt.toArray(cast b) : IterableExt.toArray(cast b);
                    if(aa.length != ab.length) return false;
                    for(i in 0...aa.length)
                        if(!equals(aa[i], ab[i]))
                            return false;
                    return true;
                }
                return true;
            case TUnknown:
                throw "Unable to compare two unknown types";
        }
        throw new Exception('Unable to compare values: ${a} and ${b}');
    }

    public static function compare(x: Dynamic, y: Dynamic): Int {
        return if(x == null || y == null) {
            0;
        } else if(x == null) {
            -1;
        } else if(y == null) {
            1;
        } else if(!TypeExt.sameType(x, y)) {
            StringExt.compare(TypeExt.valueTypeToString(x), TypeExt.valueTypeToString(y));
        } else {
            switch Type.typeof(x) {
                case TInt:
                    if(x < y) -1 else if(x > y) 1 else 0;
                case TFloat:
                    if(x < y) -1 else if(x > y) 1 else 0;
                case TBool:
                    if(x == y) 0 else if(x == true) -1 else 1;
                case TObject:
                    ObjectExt.compare(x, y);
                case TClass(c):
                    final name = Type.getClassName(c);
                    switch name {
                        case "Array":
                            ArrayExt.compare(x, y);
                        case "String":
                            StringExt.compare(x, y);
                        case "Date":
                            DateExt.compare(x, y);
                        case _ if(Reflect.hasField(x, "compare")):
                            Reflect.callMethod(x, Reflect.field(x, "compare"), [y]);
                        default:
                            StringExt.compare(Std.string(x), Std.string(y));
                    }
                case TEnum(e):
                    EnumExt.compare(x, y);
                default:
                    0;
            }
        }
    }

    public static function string(v: Dynamic) {
        return switch Type.typeof(v) {
            case TNull:
                "null";
            case TInt, TFloat, TBool:
                '${v}';
            case TObject:
                ObjectExt.string(v);
            case TClass(c):
                switch Type.getClassName(c) {
                    case "Array":
                        ArrayExt.string(v);
                    case "String":
                        v;
                    case "Date":
                        (v: Date).toString();
                    default:
                        if(MapExt.isMap(v))
                            MapExt.string(v);
                        else
                            Std.string(v);
                }
            case TEnum(e):
                EnumExt.string(v);
            case TUnknown:
                "<unknown>";
            case TFunction:
                "<function>";
        }
    }
}
