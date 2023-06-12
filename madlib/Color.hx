package madlib;

#if heaps
import h3d.Vector;
#end

using madlib.extensions.ArrayExt;
using madlib.extensions.NullExt;

@:structInit
class Color {
    public static final BLACK = fromRgbInt(0x000000);
    public static final WHITE = fromRgbInt(0xffffff);

    @:isVar public var red(default, set): Float;

    inline function set_red(v: Float)
        return red = Math.clamp(v, 0, 1);

    @:isVar public var green(default, set): Float;

    inline function set_green(v: Float)
        return green = Math.clamp(v, 0, 1);

    @:isVar public var blue(default, set): Float;

    inline function set_blue(v: Float)
        return blue = Math.clamp(v, 0, 1);

    @:isVar public var alpha(default, set): Float;

    inline function set_alpha(v: Float)
        return alpha = Math.clamp(v, 0, 1);

    public var redInt(get, set): Int;

    inline function get_redInt()
        return Math.round(red * 255);

    inline function set_redInt(v: Int) {
        red = v / 255;
        return v;
    }

    public var greenInt(get, set): Int;

    inline function get_greenInt()
        return Math.round(green * 255);

    inline function set_greenInt(v: Int) {
        green = v / 255;
        return v;
    }

    public var blueInt(get, set): Int;

    inline function get_blueInt()
        return Math.round(blue * 255);

    inline function set_blueInt(v: Int) {
        blue = v / 255;
        return v;
    }

    public var alphaInt(get, set): Int;

    inline function get_alphaInt()
        return Math.round(alpha * 255);

    inline function set_alphaInt(v: Int) {
        alpha = v / 255;
        return v;
    }

    public function new(a: Float = 1, r: Float = 1, g: Float = 1, b: Float = 1) {
        alpha = a;
        red = r;
        green = g;
        blue = b;
    }

    public inline function set(a: Float = 1, r: Float = 1, g: Float = 1, b: Float = 1): Color {
        alpha = a;
        red = r;
        green = g;
        blue = b;
        return this;
    }

    public var hue(get, set): Float;

    inline function get_hue() {
        final v = Math.atan2(Math.sqrt(3) * (green - blue), 2 * red - green - blue);
        return if(v != 0) ((Math.RAD_DEG * v) + 360) % 360 else 0;
    }

    inline function set_hue(v: Float) {
        setHSL(v, saturation, lightness);
        return v;
    }

    public var saturation(get, set): Float;

    inline function get_saturation()
        return (maxColor() - minColor()) / brightness;

    inline function set_saturation(v: Float) {
        setHSL(hue, v, lightness);
        return v;
    }

    public var lightness(get, set): Float;

    inline function get_lightness()
        return (maxColor() + minColor()) / 2;

    inline function set_lightness(v: Float) {
        setHSL(hue, saturation, v);
        return v;
    }

    public var brightness(get, set): Float;

    inline function get_brightness()
        return maxColor();

    inline function set_brightness(v: Float) {
        setHue(hue);
        final s = saturation;
        red = ((red - 1) * s + 1) * v;
        green = ((green - 1) * s + 1) * v;
        blue = ((blue - 1) * s + 1) * v;
        return v;
    }

    inline function maxColor(): Float
        return Math.max(red, Math.max(green, blue));

    inline function minColor(): Float
        return Math.min(red, Math.min(green, blue));

    public inline function setHue(hue: Float): Color {
        red = Math.abs(hue * 6 - 3) - 1;
        green = 2 - Math.abs(hue * 6 - 2);
        blue = 2 - Math.abs(hue * 6 - 4);
        return this;
    }

    public inline function setHSL(h: Float, s: Float, l: Float): Color {
        h /= 360;
        setHue(h);
        final c = (1 - Math.abs(2 * l - 1)) * s;
        alpha = alpha - 0.5 * c + l;
        red = red - 0.5 * c + l;
        green = green - 0.5 * c + l;
        blue = blue - 0.5 * c + l;
        return this;
    }

    public inline static function fromRgbInt(c: Int): Color {
        final color = new Color();
        color.redInt = (c >> 16) & 0xff;
        color.greenInt = (c >> 8) & 0xff;
        color.blueInt = c & 0xff;
        return color;
    }

    public inline static function fromArgbInt(c: Int): Color {
        final color = fromRgbInt(c);
        color.alphaInt = (c >> 24) & 0xff;
        return color;
    }

    public inline static function fromRgbInts(r: Int, g: Int, b: Int): Color {
        final color = new Color();
        color.redInt = r;
        color.greenInt = g;
        color.blueInt = b;
        return color;
    }

    public inline static function fromArgbInts(a: Int, r: Int, g: Int, b: Int): Color {
        final color = fromRgbInts(r, g, b);
        color.alphaInt = a;
        return color;
    }

    public inline static function fromRgb(r: Float, g: Float, b: Float): Color
        return new Color(r, g, b);

    public inline static function fromArgb(a: Float, r: Float, g: Float, b: Float): Color
        return new Color(r, g, b, a);

    public inline function toIntRgb(): Int
        return ((redInt << 16) | (greenInt << 8) | blueInt);

    public inline function toIntArgb(): Int
        return ((Std.int(alpha * 255) << 24) | toIntRgb());

    #if heaps
    public inline function toVector(): Vector
        return new Vector(red, green, blue, alpha);
    #end

    public inline function equals(color: Color): Bool
        return red == color.red && green == color.green && blue == color.blue && alpha == color.alpha;

    inline static function sharp(includeSharp: Bool = true): String
        return if(includeSharp) "#" else "";

    inline static function sanitizeHexStr(hex: String, includeSharp: Bool = true): Null<String> {
        hex = StringTools.trim(hex);
        final regex = ~/^#*([0-9abcdef]{6})$|^#*([0-9abcdef]{3})$/gi;
        if(regex.match(hex)) {
            return sharp(includeSharp) + if(regex.matched(2) != null) {
                // #?rgbのときは#?rrggbbの形式で返す
                final c = regex.matched(2);
                final r = c.charAt(0);
                final g = c.charAt(1);
                final b = c.charAt(2);
                r + r + g + g + b + b;
            } else {
                // #?rrggbbのときはそのまま返す
                regex.matched(1);
            }
        }
        return null;
    }

    public inline static function isValidHex(hex: String): Bool
        return sanitizeHexStr(hex) != null;

    public inline static function parse(hex: String): Color
        return sanitizeHexStr(hex).map(hex -> {
            final s = hex.substr(1, 99);
            final r = Std.parseInt('0x${s.substr(0, 2)}').withDefault(0);
            final g = Std.parseInt('0x${s.substr(2, 2)}').withDefault(0);
            final b = Std.parseInt('0x${s.substr(4, 2)}').withDefault(0);
            fromRgbInts(r, g, b);
        }).withDefault(new Color(1, 0, 0, 0));

    public inline static function hexToInt(hex: String): Int
        return sanitizeHexStr(hex).map(hex -> Std.parseInt('0x${hex.substr(1, 99)}')).withDefault(0);

    public inline static function hexToInta(hex: String): Int
        return sanitizeHexStr(hex, false).map(hex -> Std.parseInt('0xff${hex.substr(1, 99)}')).withDefault(0);

    public inline function toRgbHex(includeSharp: Bool = true): String
        return sharp(includeSharp) + StringTools.hex(toIntRgb(), 6);

    public inline function toArgbHex(includeSharp: Bool = true): String
        return sharp(includeSharp) + StringTools.hex(toIntArgb(), 8);

    public inline static function lerp(from: Color, to: Color, t: Float): Color {
        final r = Math.round(Math.lerp(from.red, to.red, t));
        final g = Math.round(Math.lerp(from.green, to.green, t));
        final b = Math.round(Math.lerp(from.blue, to.blue, t));
        return fromRgb(r, g, b);
    }

    public inline static function lerpRgba(from: Color, to: Color, t: Float): Color {
        final a = Math.round(Math.lerp(from.alpha, to.alpha, t));
        final r = Math.round(Math.lerp(from.red, to.red, t));
        final g = Math.round(Math.lerp(from.green, to.green, t));
        final b = Math.round(Math.lerp(from.blue, to.blue, t));
        return fromArgb(a, r, g, b);
    }

    public inline static function toBlack(color: Color, t: Float): Color
        return lerp(color, BLACK, t);

    public inline static function toWhite(color: Color, t: Float): Color
        return lerp(color, WHITE, t);
}
