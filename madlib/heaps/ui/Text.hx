package madlib.heaps.ui;

import h2d.Font;
import h2d.RenderContext;
import h2d.Text.Align;
import madlib.Option;

class Text extends Entity {
    static var internalDefaultFont: Option<Font> = None;

    public static var defaultFont(get, set): Font;

    inline static function get_defaultFont(): Font
        return internalDefaultFont.withDefault(hxd.res.DefaultFont.get());

    inline static function set_defaultFont(v: Font): Font {
        internalDefaultFont = Some(v);
        return v;
    }

    var _text: h2d.Text;

    public var text(get, set): String;

    inline function get_text(): String
        return _text.text;

    inline function set_text(v: String): String {
        _text.text = v;
        width = _text.textWidth;
        height = _text.textHeight;
        return v;
    }

    public function new(text: String, ?font: h2d.Font, ?parent: h2d.Object) {
        super();
        final font = font ?? madlib.heaps.ui.Text.defaultFont;
        _text = new h2d.Text(font, parent);
        this.text = text;
        addChild(_text);
    }

    public static inline function create(text: String, ?font: h2d.Font, ?parent: h2d.Object): Text
        return new Text(text, font, parent);
}
