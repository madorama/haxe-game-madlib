package madlib;

import madlib.geom.Bounds;
import polygonal.ds.Dll;

using madlib.extensions.IterableExt;
using thx.Maps;

@:allow(madlib.heaps.App)
class GameScene {
    public static var FIXED_UPDATE_FPS = 60;

    public var paused(default, null): Bool = false;
    public var destroyed(default, null): Bool = false;
    public final gridSize = 16;
    public final worldGrid: Map<String, Array<Entity>> = [];

    final tw = new Tween();

    final entities = new Dll<Entity>(16);

    var fixedUpdateAccum = 0.;

    inline function getDefaultFrameRate(): Float #if heaps return hxd.Timer.wantedFPS; #else return 60; #end

    public inline function getFixedUpdateAccumRatio(): Float
        return fixedUpdateAccum / (getDefaultFrameRate() / FIXED_UPDATE_FPS);

    var utmod = 1.;
    var ftime = 0.;
    var uftime = 0.;

    var baseTimeMul = 1.0;

    public var tmod(get, never): Float;

    inline function get_tmod(): Float
        return utmod * getComputedTimeMultiplier();

    inline function getComputedTimeMultiplier(): Float
        return Math.max(0., baseTimeMul);

    public function new() {}

    var initDone = false;

    public function initOnceBeforeUpdate() {}

    public function beforeUpdate() {
        resetWorldGrid();
    }

    public function update() {}

    public function fixedUpdate() {}

    public function afterUpdate() {}

    inline function entityBeforeUpdate(e: Entity) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.beforeUpdate();
    }

    inline function entityUpdate(e: Entity) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.update();
    }

    inline function entityAfterUpdate(e: Entity) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.afterUpdate();
    }

    inline function entityFixedUpdate(e: Entity) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.fixedUpdate();
    }

    public function onResize() {}

    public inline function dispose() {
        destroyed = true;
    }

    public inline function pause() {
        paused = true;
    }

    public inline function resume() {
        paused = false;
    }

    final public inline function togglePause() {
        if(paused)
            resume()
        else
            pause();
    }

    public inline function add(entity: Entity) {
        entity.scene = this;
        entities.append(entity);
        if(!entity.isCreated) {
            entity.created();
            entity.isCreated = true;
        }
        entity.added();
    }

    public inline function adds(es: Iterable<Entity>) {
        for(e in es)
            add(e);
    }

    public inline function remove(entity: Entity) {
        entity.removed();
        entity.isStarted = false;

        entities.remove(entity);
    }

    public inline function removes(es: Iterable<Entity>) {
        for(e in es)
            remove(e);
    }

    public function clear() {
        entities.clear(true);
        worldGrid.clear();
    }

    public inline function findEntities<T: Entity>(type: Class<T>): Array<T>
        return entities.filter(e -> Std.isOfType(e, type)).map(e -> cast e).toArray();

    public function resetWorldGrid() {
        worldGrid.clear();

        for(e in entities) {
            final l = Math.floor(e.collider.bounds.left / gridSize);
            final t = Math.floor(e.collider.bounds.top / gridSize);
            final r = Math.floor(e.collider.bounds.right / gridSize);
            final b = Math.floor(e.collider.bounds.bottom / gridSize);
            for(x in l...r + 1) {
                for(y in t...b + 1) {
                    final es = worldGrid.getAltSet('$x,$y', []);
                    es.push(e);
                }
            }
        }
    }

    public function getWorldGridEntitiesInBounds(bounds: Bounds): Array<Entity> {
        final l = Math.floor(bounds.left / gridSize);
        final t = Math.floor(bounds.top / gridSize);
        final r = Math.floor(bounds.right / gridSize);
        final b = Math.floor(bounds.bottom / gridSize);
        var ret = [];
        for(ix in l...r + 1) {
            for(iy in t...b + 1) {
                final es = worldGrid.get('$ix,$iy');
                if(es != null)
                    ret = ret.concat(es);
            }
        }
        return ret;
    }

    public function getWorldGridEntitiesInTag(tag: String, bounds: Bounds): Array<Entity> {
        final l = Math.floor(bounds.left / gridSize);
        final t = Math.floor(bounds.top / gridSize);
        final r = Math.floor(bounds.right / gridSize);
        final b = Math.floor(bounds.bottom / gridSize);
        var ret = [];
        for(ix in l...r + 1) {
            for(iy in t...b + 1) {
                final es = worldGrid.get('$ix,$iy');
                if(es != null)
                    ret = ret.concat(es.filter(e -> e.existTag(tag)));
            }
        }
        return ret;
    }

    static inline function canRun(scene: GameScene)
        return !(scene.paused || scene.destroyed);

    static inline function doUpdate(scene: GameScene, dt: Float) {
        if(!canRun(scene))
            return;

        scene.utmod = dt;
        scene.ftime += scene.tmod;
        scene.uftime += scene.utmod;

        // Before Update
        if(canRun(scene))
            scene.tw.update();

        if(canRun(scene)) {
            if(!scene.initDone) {
                scene.initOnceBeforeUpdate();
                scene.initDone = true;
            }
            scene.beforeUpdate();
        }

        // Update
        if(canRun(scene))
            scene.update();

        // FixedUpdate
        if(canRun(scene)) {
            scene.fixedUpdateAccum += scene.tmod;
            while(scene.fixedUpdateAccum >= scene.getDefaultFrameRate() / FIXED_UPDATE_FPS) {
                scene.fixedUpdateAccum -= scene.getDefaultFrameRate() / FIXED_UPDATE_FPS;

                scene.fixedUpdate();
            }
        }

        // AfterUpdate
        if(canRun(scene))
            scene.afterUpdate();
    }
}
