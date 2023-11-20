package madlib.heaps;

import hxd.Window;
import madlib.GameScene;

@:access(madlib.GameScene)
@:access(madlib.heaps.Entity)
@:tink class App extends hxd.App {
    public var window: Window;

    static var destroyedEntities: Array<Entity> = [];

    public var ftime(default, null): Float = 0;

    public var elapsedFrames(get, never): Int;

    inline function get_elapsedFrames(): Int
        return Std.int(ftime);

    public var elapsedSeconds(get, never): Float;

    inline function get_elapsedSeconds(): Float
        return ftime / hxd.Timer.wantedFPS;

    public final uiCamera = new h2d.Camera();

    public static var tmod: Float = 1 / 60;

    public function new() {
        super();
        window = Window.getInstance();
        centerWindow();
    }

    public inline function centerWindow() {
        #if(hldx || hlsdl)
        @:privateAccess window.window.center();
        #end
    }

    public inline function setWindow(?width: Int, ?height: Int, displayMode: DisplayMode = DisplayMode.Windowed) {
        window.displayMode = displayMode;
        centerWindow();
        if(width != null && height != null) {
            window.resize(width ?? window.width, height ?? window.height);
            h3d.Engine.getCurrent().resize(width ?? 1280, height ?? 720);
        }
    }

    override function init() {
        super.init();
        Controller.init();
        window.addEventTarget(onWindowEvent);
    }

    function onWindowEvent(e: hxd.Event) {
        switch e.kind {
            case EOver: onMouseEnter();
            case EOut: onMouseLeave();
            case EFocus: onFocus();
            case EFocusLost: onBlur();
            default:
        }
    }

    function onFocus() {}

    function onBlur() {}

    function onMouseEnter() {}

    function onMouseLeave() {}

    override function update(dt: Float) {
        super.update(dt);
        @:privateAccess Input.mouseX = s2d.mouseX;
        @:privateAccess Input.mouseY = s2d.mouseY;

        App.tmod = hxd.Timer.tmod;

        ftime += App.tmod;

        for(e in destroyedEntities) {
            if(!e.onDestroyed) e.onDestroy();
        }
        destroyedEntities.resize(0);

        GamePad.update();
    }
}
