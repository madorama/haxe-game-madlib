package madlib;

import haxe.Exception;

using madlib.extensions.ArrayExt;

@:access(madlib.GameScene)
class SceneManager {
    final scenes: Array<GameScene> = [];

    public var currentScene(get, never): GameScene;

    inline function get_currentScene(): GameScene {
        if(scenes.length == 0)
            throw new Exception("empty scenes");
        return scenes[scenes.length - 1];
    }

    final pushReservedScenes: Array<GameScene> = [];
    final popReservedScenes: Array<GameScene> = [];

    public function new() {}

    public inline function push(scene: GameScene) {
        pushReservedScenes.push(scene);
    }

    public inline function pop() {
        if(scenes.length > 0) {
            final scene = scenes.pop();
            if(scene != null) popReservedScenes.push(scene);
        }
    }

    inline function init(scene: GameScene, s2d: h2d.Scene) {
        if(scene.initDone) {
            scene.init(s2d);
            scene.initDone = true;
        }
    }

    public inline function replace(scene: GameScene) {
        if(scenes.length > 0)
            scenes[scenes.length - 1].destroy();
        pushReservedScenes.push(scene);
    }

    public inline function clear() {
        while(scenes.length > 0)
            pop();
    }

    public function update(s2d: h2d.Scene, dt: Float) {
        if(popReservedScenes.length > 0) {
            for(s in popReservedScenes) {
                s.destroy();
                scenes.remove(s);
            }
            popReservedScenes.resize(0);
        }

        if(pushReservedScenes.length > 0) {
            for(s in pushReservedScenes) {
                scenes.push(s);
                init(s, s2d);
            }
            pushReservedScenes.resize(0);
        }

        for(scene in scenes)
            GameScene.doUpdate(scene, dt);
    }

    public function fixedUpdate(dt: Float) {
        for(scene in scenes)
            GameScene.doFixedUpdate(scene, dt);
    }

    public function afterUpdate(dt: Float) {
        for(scene in scenes)
            GameScene.doAfterUpdate(scene, dt);
    }

    public function gc() {
        for(scene in scenes) {
            if(scene.destroyed)
                scenes.remove(scene);
        }
    }

    public function onResize() {
        for(scene in scenes)
            scene.onResize();
    }

    public function pause<T: GameScene>(sceneType: Class<T>) {
        final scene = scenes.find(s -> Std.isOfType(s, sceneType));
        scene?.pause();
    }

    public function resume<T: GameScene>(sceneType: Class<T>) {
        final scene = scenes.find(s -> Std.isOfType(s, sceneType));
        scene?.resume();
    }

    public function doCurrentScene(action: GameScene -> Void) {
        action(currentScene);
    }

    public function doAllScene(action: GameScene -> Void) {
        for(scene in scenes)
            action(scene);
    }
}
