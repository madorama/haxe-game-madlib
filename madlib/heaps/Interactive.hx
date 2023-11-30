package madlib.heaps;

import madlib.Event.Events;

class Interactive {
    final interactive: h2d.Interactive;

    public var cursor(get, set): Null<hxd.Cursor>;

    inline function get_cursor(): Null<hxd.Cursor>
        return interactive.cursor;

    inline function set_cursor(v: Null<hxd.Cursor>): Null<hxd.Cursor>
        return interactive.cursor = v;

    public var allowMultiClick(get, set): Bool;

    inline function get_allowMultiClick(): Bool
        return interactive.allowMultiClick;

    inline function set_allowMultiClick(v: Bool): Bool
        return interactive.allowMultiClick = v;

    public var width(get, set): Float;

    inline function get_width(): Float
        return interactive.width;

    inline function set_width(v: Float): Float
        return interactive.width = v;

    public var height(get, set): Float;

    inline function get_height(): Float
        return interactive.height;

    inline function set_height(v: Float): Float
        return interactive.height = v;

    public var isEllipse(get, set): Bool;

    inline function get_isEllipse(): Bool
        return interactive.isEllipse;

    inline function set_isEllipse(v: Bool): Bool
        return interactive.isEllipse = v;

    public var cancelEvents(get, set): Bool;

    inline function get_cancelEvents(): Bool
        return interactive.cancelEvents;

    inline function set_cancelEvents(v: Bool): Bool
        return interactive.cancelEvents = v;

    public var propagateEvents(get, set): Bool;

    inline function get_propagateEvents(): Bool
        return interactive.propagateEvents;

    inline function set_propagateEvents(v: Bool): Bool
        return interactive.propagateEvents = v;

    public var enableRightButton(get, set): Bool;

    inline function get_enableRightButton(): Bool
        return interactive.enableRightButton;

    inline function set_enableRightButton(v: Bool): Bool
        return interactive.enableRightButton = v;

    public var backgroundColor(get, set): Null<Int>;

    inline function get_backgroundColor(): Null<Int>
        return interactive.backgroundColor;

    inline function set_backgroundColor(v: Null<Int>): Null<Int>
        return interactive.backgroundColor = v;

    public var shape(get, set): h2d.col.Collider;

    inline function get_shape(): h2d.col.Collider
        return interactive.shape;

    inline function set_shape(v: h2d.col.Collider): h2d.col.Collider
        return interactive.shape = v;

    public var shapeX(get, set): Float;

    inline function get_shapeX(): Float
        return interactive.shapeX;

    inline function set_shapeX(v: Float): Float
        return interactive.shapeX = v;

    public var shapeY(get, set): Float;

    inline function get_shapeY(): Float
        return interactive.shapeY;

    inline function set_shapeY(v: Float): Float
        return interactive.shapeY = v;

    public final onStartCapture = new Events<hxd.Event>();
    public final onCancelCapture = new Events<Unit>();
    public final onOver = new Events<hxd.Event>();
    public final onOut = new Events<hxd.Event>();
    public final onPush = new Events<hxd.Event>();
    public final onRelease = new Events<hxd.Event>();
    public final onReleaseOutside = new Events<hxd.Event>();
    public final onClick = new Events<hxd.Event>();
    public final onMove = new Events<hxd.Event>();
    public final onWheel = new Events<hxd.Event>();
    public final onFocus = new Events<hxd.Event>();
    public final onFocusLost = new Events<hxd.Event>();
    public final onKeyUp = new Events<hxd.Event>();
    public final onKeyDown = new Events<hxd.Event>();
    public final onCheck = new Events<hxd.Event>();
    public final onTextInput = new Events<hxd.Event>();

    public function new(interactive: h2d.Interactive) {
        this.interactive = interactive;
        interactive.onOver = onOver.invoke;
        interactive.onOut = onOut.invoke;
        interactive.onPush = onPush.invoke;
        interactive.onRelease = onRelease.invoke;
        interactive.onReleaseOutside = onReleaseOutside.invoke;
        interactive.onClick = onClick.invoke;
        interactive.onMove = onMove.invoke;
        interactive.onWheel = onWheel.invoke;
        interactive.onFocus = onFocus.invoke;
        interactive.onFocusLost = onFocusLost.invoke;
        interactive.onKeyUp = onKeyUp.invoke;
        interactive.onKeyDown = onKeyDown.invoke;
        interactive.onCheck = onCheck.invoke;
        interactive.onTextInput = onTextInput.invoke;
    }

    public inline function preventClick() {
        interactive.preventClick();
    }

    public inline function startCapture() {
        if(interactive.getScene() != null) {
            interactive.startCapture(onStartCapture.invoke, () -> onCancelCapture.invoke(Unit));
        }
    }

    public inline function stopCapture() {
        interactive.stopCapture();
    }

    public inline function focus() {
        interactive.focus();
    }

    public inline function blur() {
        interactive.blur();
    }

    public inline function isOver(): Bool
        return interactive.isOver();

    public inline function hasFocus(): Bool
        return interactive.hasFocus();
}
