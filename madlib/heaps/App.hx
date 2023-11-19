package madlib.heaps;

import hxd.Window;
import madlib.GameScene;

@:access(madlib.GameScene)
@:access(madlib.heaps.Entity)
@:tink class App extends hxd.App {
    public var window: Window;

    static var destroyedEntities: Array<Entity> = [];

    final scenes: Array<GameScene> = [];

    public var currentScene(get, never): GameScene;

    inline function get_currentScene(): GameScene {
        return scenes[scenes.length - 1];
    }

    final pushReservedScenes: Array<GameScene> = [];
    final popReservedScenes: Array<GameScene> = [];

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
    }

    public inline function setWindow(?width: Int, ?height: Int, displayMode: DisplayMode = DisplayMode.Windowed) {
        window.displayMode = displayMode;
        window.resize(width ?? window.width, height ?? window.height);
        #if(hldx || hlsdl)
        @:privateAccess window.window.center();
        #end
        h3d.Engine.getCurrent().resize(width, height);
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

        for(s in popReservedScenes) {
            s.destroy();
            scenes.remove(s);
        }
        popReservedScenes.resize(0);

        for(e in destroyedEntities) {
            if(!e.onDestroyed) e.onDestroy();
        }
        destroyedEntities.resize(0);

        for(s in pushReservedScenes) {
            scenes.push(s);
            initScene(s);
        }
        pushReservedScenes.resize(0);

        GamePad.update();
    }

    inline function gc() {
        for(scene in scenes) {
            if(scene.destroyed)
                scenes.remove(scene);
        }
    }

    override inline function onResize() {
        super.onResize();

        for(scene in scenes)
            scene.onResize();
    }

    public inline function pushScene(scene: GameScene) {
        pushReservedScenes.push(scene);
    }

    public inline function popScene() {
        popReservedScenes.push(scenes[scenes.length - 1 - popReservedScenes.length]);
    }

    inline function initScene(scene: GameScene) {
        if(scene.initDone) {
            scene.init(s2d);
            scene.initDone = true;
        }
    }

    public inline function replaceScene(scene: GameScene) {
        if(scenes.length == 0) {
            scenes.push(scene);
        } else {
            scenes[scenes.length - 1].destroy();
            scenes[scenes.length - 1] = scene;
        }
    }

    public inline function clearScenes() {
        while(scenes.length > 0)
            popScene();
    }
}
