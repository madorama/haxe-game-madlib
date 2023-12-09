package madlib;

import haxe.Exception;
import haxe.macro.Expr;
import hxmath.math.Vector3;

class Math {
    public static final I8_MIN = -0x80;
    public static final I8_MAX = 0x7f;
    public static final U8_MAX = 0xff;
    public static final I16_MIN = -0x8000;
    public static final I16_MAX = 0x7fff;
    public static final U16_MAX = 0xffff;
    public static final I32_MIN = #if(cpp) -0x7fffffff; #else 0x80000000; #end
    public static final I32_MAX = 0x7fffffff;
    public static final U32_MAX = 0xffffffff;

    public static final FLOAT_MAX = 3.4028234663852886e+38;
    public static final FLOAT_MIN = -3.4028234663852886e+38;
    public static final DOUBLE_MAX = 1.7976931348623157e+308;
    public static final DOUBLE_MIN = -1.7976931348623157e+308;

    public static final NaN = std.Math.NaN;
    public static final POSITIVE_INFINITY = std.Math.POSITIVE_INFINITY;
    public static final NEGATIVE_INFINITY = std.Math.NEGATIVE_INFINITY;

    inline static function get_POSITIVE_INFINITY()
        return std.Math.POSITIVE_INFINITY;

    inline static function get_NEGATIVE_INFINITY()
        return std.Math.NEGATIVE_INFINITY;

    public inline static function isNaN(v: Float): Bool
        return std.Math.isNaN(v);

    public inline static function isFinite(v: Float): Bool
        return std.Math.isFinite(v);

    public static inline final PI_HALF = 1.5707963267948966;
    public static inline final PI = 3.14159265358979323;
    public static inline final PI2 = 6.283185307179586;
    public static inline final TAU = PI2;
    public static inline final RAD_DEG = 180 / PI;
    public static inline final DEG_RAD = PI / 180;
    public static inline final LN2 = 0.6931471805599453;
    public static inline final EPSILON = 1e-10;
    public static inline final SQRT2 = 1.414213562373095;

    public inline static function toRad(deg: Float): Float
        return deg * DEG_RAD;

    public inline static function toDeg(rad: Float): Float
        return rad * RAD_DEG;

    public inline static function percent(v: Float, min: Float, max: Float): Float {
        if(max - min == 0)
            throw new Exception("divide by zero");
        return (v - min) / (max - min);
    }

    public inline static function percentToValue(p: Float, min: Float, max: Float)
        return min + (max - min) * p;

    public inline static function sign(a: Float): Int
        return if(a > 0.) 1 else if(a < 0.) -1 else 0;

    public inline static function signEqual(a: Float, b: Float): Bool
        return sign(a) == sign(b);

    public inline static function min<T: Float>(a: T, b: T): T
        return if(a < b) a else b;

    public inline static function max<T: Float>(a: T, b: T): T
        return if(a > b) a else b;

    public inline static function abs<T: Float>(a: T): T
        return if(a < 0) -a else a;

    public inline static function clamp<T: Float>(val: T, min: T, max: T): T
        return if(val < min) min else if(val > max) max else val;

    public inline static function eqSign(a: Int, b: Int): Bool
        return (a ^ b) >= 0;

    public inline static function feqSign(a: Float, b: Float): Bool
        return a * b >= 0;

    public inline static function isEven(a: Int): Bool
        return (a & 1) == 0;

    public inline static function isOdd(a: Int): Bool
        return (a & 1) != 0;

    public inline static function isPow2(a: Int): Bool
        return a > 0 && (a & (a - 1)) == 0;

    public inline static function log(v: Float): Float
        return std.Math.log(v);

    public inline static function sin(v: Float): Float
        return #if heaps hxd.Math.sin(v) #else std.Math.sin(v) #end;

    public inline static function cos(v: Float): Float
        return #if heaps hxd.Math.cos(v) #else std.Math.cos(v) #end;

    public inline static function tan(v: Float): Float
        return #if heaps hxd.Math.tan(v) #else std.Math.tan(v) #end;

    public inline static function asin(v: Float): Float
        return #if heaps hxd.Math.asin(v) #else std.Math.asin(v) #end;

    public inline static function acos(v: Float): Float
        return #if heaps hxd.Math.acos(v) #else std.Math.acos(v) #end;

    public inline static function atan(v: Float): Float
        return #if heaps hxd.Math.atan(v) #else std.Math.atan(v) #end;

    public inline static function atan2(y: Float, x: Float): Float
        return #if heaps hxd.Math.atan2(y, x) #else std.Math.atan2(y, x) #end;

    public inline static function sqrt(v: Float): Float
        return #if heaps hxd.Math.sqrt(v) #else std.Math.sqrt(v) #end;

    public inline static function exp(a: Float): Float
        return std.Math.exp(a);

    public inline static function fround(v: Float): Float
        return std.Math.fround(v);

    public inline static function round(v: Float): Int
        return #if heaps hxd.Math.round(v) #else std.Math.round(v) #end;

    public inline static function roundTo(a: Float, decimals: Int): Float {
        return if(decimals <= 0) {
            fround(a);
        } else {
            final x = pow(10, decimals);
            std.Math.fround(a * x) / x;
        }
    }

    public inline static function fceil(v: Float): Float
        return std.Math.fceil(v);

    public inline static function ceil(v: Float): Int
        return #if heaps hxd.Math.ceil(v) #else std.Math.ceil(v) #end;

    public inline static function ceilTo(a: Float, decimals: Int): Float {
        return if(decimals <= 0) {
            ceil(a);
        } else {
            final x = pow(10, decimals);
            std.Math.fceil(a * x) / x;
        }
    }

    public inline static function ffloor(v: Float): Float
        return std.Math.ffloor(v);

    public inline static function floor(v: Float): Int
        return #if heaps hxd.Math.floor(v) #else std.Math.floor(v) #end;

    public inline static function pow(v: Float, exp: Float): Float
        return #if heaps hxd.Math.pow(v, exp) #else std.Math.pow(v, exp) #end;

    public inline static function lerp(a: Float, b: Float, t: Float): Float
        return (1 - t) * a + t * b;

    public inline static function slerp(a: Vector3, b: Vector3, t: Float): Vector3 {
        final a = a.clone();
        final b = b.clone();
        a.normalize();
        b.normalize();
        final angle = acos(a * b);
        final sinTheta = sin(angle);
        final pa = sin(angle * (1 - t));
        final pb = sin(angle * t);

        return (pa * a + pb * b) / sinTheta;
    }

    public inline static function angle(a: Float): Float {
        a %= PI2;
        return if(a > PI) a - PI2 else if(a <= -PI) a + PI2 else a;
    }

    public inline static function angleLerp(a: Float, b: Float, t: Float): Float
        return a + angle(b - a) * t;

    public inline static function angleMove(a: Float, b: Float, max: Float): Float {
        final a = angle(b - a);
        return if(a > -max && a < max) b else a + (if(a < 0) -max else max);
    }

    public inline static function invSqrt(v: Float): Float
        return 1. / sqrt(v);

    public inline static function cmpAbs(a: Float, b: Float, eps: Float = EPSILON): Bool
        return abs(a - b) <= eps;

    public inline static function cmpZero(a: Float, eps: Float = EPSILON): Bool
        return abs(a) <= eps;

    public inline static function snap(a: Float, b: Float): Float
        return floor((a + b * .5) / b);

    public inline static function inRange(a: Float, min: Float, max: Float): Bool
        return a >= min && a <= max;

    public inline static function fdim(a: Float, b: Float): Float
        return if(a - b > 0) a - b else 0.0;

    public inline static function sMod(n: Float, mod: Float): Float {
        if(mod != 0.0) {
            while(n >= mod)
                n -= mod;
            while(n < 0)
                n += mod;
        }
        return n;
    }

    public inline static function hMod(n: Float, mod: Float): Float {
        while(n > mod)
            n -= mod * 2;
        while(n < -mod)
            n += mod * 2;
        return n;
    }

    inline static function gcdAux(x: Int, y: Int): Int
        return if(y == 0) x else gcdAux(y, x % y);

    public inline static function gcd(x: Int, y: Int): Int
        return gcdAux(abs(x), abs(y));

    public inline static function lcm(x: Int, y: Int): BigInt
        return (x: BigInt) / gcd(x, y) * (y: BigInt);

    public inline static function maxPrecision(x: Float, precision: Int): Float
        return if(x == 0) {
            x;
        } else {
            var correction = 10;
            for(_ in 0...precision - 1)
                correction *= 10;
            round(correction * x) / correction;
        }

    /**
     * @return vがtrueのときは1、falseのときは0
     */
    public inline static function ofBool(v: Bool): Int
        return if(v) 1 else 0;

    public inline static function posMod(i: Int, m: Int): Int {
        final mod = i % m;
        return if(mod >= 0) mod else mod + m;
    }

    public inline static function umod<T: Float>(v: T, m: T): T {
        final r = v % m;
        return if(r >= 0) r else r + m;
    }

    public inline static function distanceSquared<T: Float>(ax: T, ay: T, bx: T, by: T): Float
        return hypot(ax - bx, ay - by);

    public inline static function hypot(x: Float, y: Float): Float
        return sqrt(x * x + y * y);

    public inline static function factorial(v: Int): Int {
        var r = 1;
        for(i in 1...(v + 1))
            r *= i;
        return r;
    }

    public inline static function normalizeDeg(a: Float): Float {
        while(a < -180)
            a += 360;
        while(a > 180)
            a -= 360;
        return a;
    }

    public inline static function normalizeRad(a: Float): Float {
        while(a < -PI)
            a += PI2;
        while(a > PI)
            a -= PI2;
        return a;
    }

    public inline static function toAngle(x: Float, y: Float): Float
        return atan2(-y, -x) + PI;

    public inline static function intToBitString(v: Int, pad = 8): String {
        var out = "";
        var i = 0;
        while(setBit(0, i) <= v && i < 32)
            out = (if(hasBit(v, i++)) "1" else "0") + out;
        return StringTools.lpad(out, "0", pad);
    }

    public inline static function setBit(baseValue: Int, bitIndex: Int): Int
        return baseValue | (1 << bitIndex);

    public inline static function makeBitsFromArray(bools: Array<Bool>): Int {
        if(bools.length > 32)
            throw new Exception("Too many values (32bits max)");

        var v = 0;
        for(i in 0...bools.length) {
            if(bools[i])
                v = setBit(v, i);
        }
        return v;
    }

    public static function makeBitsFromBools(b0 = false, b1 = false, b2 = false, b3 = false, b4 = false, b5 = false, b6 = false, b7 = false): Int {
        var v = 0;
        if(b0) v = setBit(v, 0);
        if(b1) v = setBit(v, 1);
        if(b2) v = setBit(v, 2);
        if(b3) v = setBit(v, 3);
        if(b4) v = setBit(v, 4);
        if(b5) v = setBit(v, 5);
        if(b6) v = setBit(v, 6);
        if(b7) v = setBit(v, 7);
        return v;
    }

    public inline static function hasBit(v: Int, bitIndex: Int): Bool
        return v & (1 << bitIndex) != 0;

    public inline static function bitCount(v: Int): Int {
        v = v - ((v >> 1) & 0x55555555);
        v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
        return (((v + (v >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
    }

    public inline static function isValidNumber(v: Float): Bool
        return !isNaN(v) && isFinite(v);

    public inline static function parseInt(str: String, defaultValue: Int): Int {
        return if(str == "") {
            defaultValue;
        } else {
            final v = Std.parseInt(str);
            if(v == null)
                defaultValue;
            else if(isValidNumber(v))
                v
            else
                defaultValue;
        }
    }

    public inline static function valueMove(v: Float, target: Float, maxValue: Float): Float
        return if(v < target) min(v + maxValue, target) else if(v > target) max(v - maxValue, target) else v;

    /**
     * Int[0～255]をFloat[0.0～1.0]に変換する
     */
    public inline static function b2f(v: Int): Float
        return clamp(v, 0, 255) / 0xFF;

    /**
     * Float[0.0～1.0]をInt[0～255]に変換する
     */
    public inline static function f2b(v: Float): Int
        return Std.int(clamp(v, 0, 1) * 255.0);

    public inline static function wrap(v: Int, min: Int, max: Int): Int {
        final range = max - min + 1;
        if(v < min)
            v += range * Std.int((min - v) / range + 1);
        return min + (v - min) % range;
    }

    public inline static function dotProduct(ax: Float, ay: Float, bx: Float, by: Float): Float
        return ax * bx + ay * by;

    public inline static function isPrime(n: Int): Bool
        return if(n % 2 == 0)
            n == 2;
        else if(n % 3 == 0)
            n == 3;
        else {
            final loop = sqrt(n);
            var i = 5;
            var result = true;
            while(i < loop) {
                if(n % i == 0 || n % (i + 2) == 0) {
                    result = false;
                    break;
                }
                i += 6;
            }
            result;
        }

    public inline static function clz(n: Int): Int {
        final asUint = n >>> 0;
        return if(asUint == 0) 32 else 31 - Std.int(log(asUint) / LN2);
    }
}
