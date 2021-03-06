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

    public final uiCamera = new h2d.Camera();

    public function new(width: Int, height: Int, fullscreen: Bool = false) {
        super();
        window = Window.getInstance();
        window.resize(width, height);

        if(fullscreen)
            window.displayMode = Fullscreen;

        #if(hldx || hlsdl)
        @:privateAccess window.window.center();
        #end
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

        GamePad.update();
        Tween.inst.update();
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
        scenes.push(scene);
    }

    public inline function popScene() {
        final s = scenes.pop();
        if(s != null)
            s.dispose();
    }

    public inline function clearScenes() {
        while(scenes.length > 0)
            popScene();
    }
}
