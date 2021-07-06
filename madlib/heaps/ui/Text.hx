package madlib.heaps.ui;

import h2d.Font;
import haxe.ds.Option;

using madlib.extensions.OptionExt;

class Text {
    static var internalDefaultFont: Option<Font> = None;

    public static var defaultFont(get, set): Font;

    inline static function get_defaultFont(): Font
        return internalDefaultFont.withDefault(hxd.res.DefaultFont.get());

    inline static function set_defaultFont(v: Font): Font {
        internalDefaultFont = Some(v);
        return v;
    }

    public inline static function create(s: String, ?font: Font, ?parent: h2d.Object): h2d.Text {
        final font = if(font == null) defaultFont else font;
        final text = new h2d.Text(font, parent);
        text.text = s;
        return text;
    }
}
