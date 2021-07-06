package madlib.heaps;

import hxd.Key;

using madlib.extensions.ArrayExt;

class Input {
    @:isVar public static var mouseX(get, null): Float = 0.;
    @:isVar public static var mouseY(get, null): Float = 0.;

    inline static function get_mouseX()
        return mouseX;

    inline static function get_mouseY()
        return mouseY;

    public inline static function isAnyDown(keys: Array<Int>): Bool
        return keys.any(Key.isDown);

    public inline static function isAnyPressed(keys: Array<Int>): Bool
        return keys.any(Key.isPressed);

    public inline static function isAnyReleased(keys: Array<Int>): Bool
        return keys.any(Key.isReleased);

    public inline static function isAllDown(keys: Array<Int>): Bool
        return keys.all(Key.isDown);

    public inline static function isAllPressed(keys: Array<Int>): Bool
        return keys.all(Key.isPressed);

    public inline static function isAllReleased(keys: Array<Int>): Bool
        return keys.all(Key.isReleased);

    public inline static function isShift(): Bool
        return Key.isDown(Key.SHIFT);

    public inline static function isCtrl(): Bool
        return Key.isDown(Key.CTRL);

    public inline static function isAlt(): Bool
        return Key.isDown(Key.ALT);
}
