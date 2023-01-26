package madlib.heaps;

import hxd.Window;
import madlib.GameScene;

enum abstract LayerId(Int) to Int {
    final LayerShared = 0;
    final LayerUI = 10;
}

@:tink class App extends hxd.App {
    public var window: Window;

    @:lazy var root = new h2d.Scene();

    final scenes: Array<GameScene> = [];

    final pushReservedScenes: Array<GameScene> = [];
    final popReservedScenes: Array<GameScene> = [];

    public final uiCamera = new h2d.Camera();

    public static var tmod: Float = 1 / 60;

    public function new() {
        super();
        window = Window.getInstance();
    }

    public inline function setWindow(?width: Int, ?height: Int, displayMode: DisplayMode = DisplayMode.Windowed) {
        window.displayMode = displayMode;
        window.resize(width != null ? width : window.width, height != null ? height : window.height);
        #if(hldx || hlsdl)
        @:privateAccess window.window.center();
        #end
        h3d.Engine.getCurrent().resize(width, height);
    }

    override function init() {
        super.init();
        s2d.add(root, 0);

        uiCamera.layerVisible = layer -> layer == LayerUI;
        root.addCamera(uiCamera);

        Controller.init();
    }

    override function update(dt: Float) {
        super.update(dt);
        @:privateAccess Input.mouseX = s2d.mouseX;
        @:privateAccess Input.mouseY = s2d.mouseY;

        App.tmod = hxd.Timer.tmod;

        for(s in popReservedScenes) {
            s.dispose();
            scenes.remove(s);
        }
        popReservedScenes.resize(0);

        for(s in pushReservedScenes) {
            scenes.push(s);
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

    public inline function clearScenes() {
        while(scenes.length > 0)
            popScene();
    }
}
