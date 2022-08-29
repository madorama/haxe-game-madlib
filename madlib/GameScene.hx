package madlib;

import madlib.geom.Bounds;
import polygonal.ds.Dll;

using madlib.extensions.IterableExt;
using thx.Maps;

@:allow(madlib.heaps.App)
class GameScene {
    public static var FIXED_UPDATE_FPS = 30;

    public var paused(default, null): Bool = false;
    public var destroyed(default, null): Bool = false;
    public final gridSize = 16;
    public final worldGrid: Map<String, Array<Entity>> = [];

    final tw = new Tween();

    final entities = new Dll<Entity>(16);

    public inline function getDefaultFrameRate(): Float
        return #if heaps hxd.Timer.wantedFPS #else 60 #end;

    public function new() {}

    var initDone = false;

    public function initOnceBeforeUpdate() {}

    public function beforeUpdate(dt: Float) {
        resetWorldGrid();
    }

    public function update(dt: Float) {}

    public function fixedUpdate(dt: Float) {}

    public function afterUpdate(dt: Float) {}

    inline function entityBeforeUpdate(e: Entity, dt: Float) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.beforeUpdate(dt);
    }

    inline function entityUpdate(e: Entity, dt: Float) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.update(dt);
    }

    inline function entityAfterUpdate(e: Entity, dt: Float) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.afterUpdate(dt);
    }

    inline function entityFixedUpdate(e: Entity, dt: Float) {
        if(!e.isStarted) {
            e.started();
            e.isStarted = true;
        }
        if(e.active && e.isStarted)
            e.fixedUpdate(dt);
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

    var fixedUpdateAccum = 0.;

    static inline function doUpdate(scene: GameScene, dt: Float) {
        if(!canRun(scene))
            return;

        // Remove destroyed entities
        if(canRun(scene)) {
            var next = scene.entities.head;
            while(next.hasNext()) {
                final n = next.next;
                if(next.val.destroyed) {
                    next.unlink();
                    next.free();
                }
                next = n;
            }
        }

        // Before Update
        if(canRun(scene))
            scene.tw.update(dt);

        if(canRun(scene)) {
            if(!scene.initDone) {
                scene.initOnceBeforeUpdate();
                scene.initDone = true;
            }
            scene.beforeUpdate(dt);
        }

        // Update
        if(canRun(scene))
            scene.update(dt);

        // FixedUpdate
        if(canRun(scene)) {
            scene.fixedUpdateAccum += dt;
            while(scene.fixedUpdateAccum >= scene.getDefaultFrameRate() / FIXED_UPDATE_FPS) {
                scene.fixedUpdateAccum -= scene.getDefaultFrameRate() / FIXED_UPDATE_FPS;

                scene.fixedUpdate(dt);
            }
        }

        // AfterUpdate
        if(canRun(scene))
            scene.afterUpdate(dt);
    }
}
