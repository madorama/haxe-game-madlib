package madlib;

import polygonal.ds.Dll;
import madlib.geom.Bounds;

using madlib.extensions.IterableExt;
using madlib.extensions.MapExt;
using madlib.extensions.NullExt;

class GameScene {
    public var ftime(default, null): Float = 0;

    public var elapsedFrames(get, never): Int;

    inline function get_elapsedFrames(): Int
        return Std.int(ftime);

    public var elapsedSeconds(get, never): Float;

    inline function get_elapsedSeconds(): Float
        return ftime / getDefaultFrameRate();

    public var paused(default, null): Bool = false;
    public var destroyed(default, null): Bool = false;

    final tw = new Tween();

    final entities = new Dll<Entity>(256);

    public inline function getDefaultFrameRate(): Float
        return #if heaps hxd.Timer.wantedFPS #else 60 #end;

    public function new(s2d: h2d.Scene) {
        init(s2d);
    }

    var initDone = false;

    public function init(s2d: h2d.Scene) {}

    public function update(dt: Float) {}

    public function fixedUpdate(dt: Float) {}

    public function afterUpdate(dt: Float) {}

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

    public function destroy() {
        destroyed = true;
        for(entity in entities) {
            entity.destroy();
            gc();
        }
    }

    public function pause() {
        paused = true;
    }

    public function resume() {
        paused = false;
    }

    final public inline function togglePause() {
        if(paused)
            resume()
        else
            pause();
    }

    public function add(entity: Entity) {
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
        entity.active = false;
        entities.remove(entity);
    }

    public inline function destroyEntity(entity: Entity) {
        entity.destroy();
    }

    public inline function removes(es: Iterable<Entity>) {
        for(e in es)
            remove(e);
    }

    public function clear() {
        entities.clear(true);
    }

    public inline function findEntity<T: Entity>(type: Class<T>): Null<T>
        return entities.find(e -> Std.isOfType(e, type)).map(x -> cast x);

    public inline function findEntities<T: Entity>(type: Class<T>): Array<T>
        return entities.filter(e -> Std.isOfType(e, type)).map(x -> cast x).toArray();

    public inline function findEntityWithTag(tags: Array<String>): Null<Entity>
        return entities.find(e -> e.existTags(tags));

    public inline function findEntitiesWithTag(tags: Array<String>): Array<Entity>
        return entities.filter(e -> e.existTags(tags)).toArray();

    public inline function findEntityWithAnyTag(tags: Array<String>): Null<Entity>
        return entities.find(e -> e.existAnyTag(tags));

    public inline function findEntitiesWithAnyTag(tags: Array<String>): Array<Entity>
        return entities.filter(e -> e.existAnyTag(tags)).toArray();

    public function getEntitiesInBounds(bounds: Bounds): Array<Entity> {
        final ret = [];
        for(e in entities) {
            if(e.collider.collideBounds(bounds))
                ret.push(e);
        }
        return ret;
    }

    public function getEntitiesWithTag(tags: Array<String>, ?bounds: Bounds): Array<Entity> {
        final ret = [];
        for(e in entities) {
            if(bounds == null) {
                if(e.existTags(tags)) ret.push(e);
            } else {
                if(e.collider.collideBounds(bounds))
                    if(e.existTags(tags)) ret.push(e);
            }
        }
        return ret;
    }

    public function getEntitiesWithAnyTag(tags: Array<String>, ?bounds: Bounds): Array<Entity> {
        final ret = [];
        for(e in entities) {
            if(bounds == null) {
                if(e.existAnyTag(tags)) ret.push(e);
            } else {
                if(e.collider.collideBounds(bounds))
                    if(e.existAnyTag(tags)) ret.push(e);
            }
        }
        return ret;
    }

    inline function gc() {
        var next = entities.head;
        while(next != null) {
            final n = next.next;
            final e = next.val;
            if(e.destroyed) {
                if(!e.onDestroyed) e.onDestroy();
                next.unlink();
                next.free();
            }
            next = n;
        }
    }

    static inline function canRun(scene: GameScene)
        return !(scene.paused || scene.destroyed);

    static inline function doUpdate(scene: GameScene, dt: Float) {
        if(!canRun(scene)) return;
        scene.gc();
        scene.ftime += dt;
        if(!canRun(scene)) return;
        scene.tw.update(dt);

        if(!canRun(scene)) return;
        scene.update(dt);
    }

    static inline function doFixedUpdate(scene: GameScene, dt: Float) {
        if(!canRun(scene)) return;
        scene.fixedUpdate(dt);
    }

    static inline function doAfterUpdate(scene: GameScene, dt: Float) {
        if(!canRun(scene)) return;
        scene.afterUpdate(dt);
    }
}
