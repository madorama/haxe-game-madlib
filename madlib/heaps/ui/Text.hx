package madlib.heaps.ui;

import h2d.Font;
import h2d.RenderContext;
import madlib.Option;

class Text extends h2d.Text {
    static var internalDefaultFont: Option<Font> = None;

    public static var defaultFont(get, set): Font;

    inline static function get_defaultFont(): Font
        return internalDefaultFont.withDefault(hxd.res.DefaultFont.get());

    inline static function set_defaultFont(v: Font): Font {
        internalDefaultFont = Some(v);
        return v;
    }

    public var pivotX = 0.;
    public var pivotY = 0.;

    public function new(text: String, ?font: h2d.Font, ?parent: h2d.Object) {
        final font = if(font == null) madlib.heaps.ui.Text.defaultFont else font;
        super(font, parent);
        this.text = text;
    }

    public inline function setPivot(x: Float, y: Float) {
        pivotX = x;
        pivotY = y;
    }

    override function drawRec(ctx: RenderContext) {
        final baseX = x;
        final baseY = y;
        x = x - this.textWidth * Math.clamp(pivotX, 0, 1);
        y = y - this.textHeight * Math.clamp(pivotY, 0, 1);
        super.drawRec(ctx);
        x = baseX;
        y = baseY;
    }

    public static inline function create(text: String, ?font: h2d.Font, ?parent: h2d.Object): Text
        return new Text(text, font, parent);
}
