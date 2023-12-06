package madlib.heaps;

import h2d.RenderContext;
import madlib.GameScene;
import madlib.Option;
import madlib.Set;
import madlib.collider.Collide;
import madlib.collider.Collider;

using madlib.extensions.IterableExt;

class Tags {
    var tags(default, null): Set<String> = Set.createString();

    public function new() {}

    public inline function existTag(name: String): Bool
        return tags.exists(name);

    public inline function existTags(names: Array<String>): Bool
        return names.all(existTag);

    public inline function existAnyTag(names: Array<String>): Bool
        return names.any(existTag);

    public inline function add(name: String) {
        tags.add(name);
    }

    public inline function adds(names: Array<String>) {
        for(name in names)
            tags.add(name);
    }

    public inline function remove(name: String) {
        tags.remove(name);
    }

    public inline function removes(names: Array<String>) {
        for(name in names)
            tags.remove(name);
    }

    public inline function clear() {
        tags = tags.empty();
    }

    public inline function iterator(): Iterator<String>
        return tags.iterator();
}

@:allow(madlib.GameScene)
class Entity extends h2d.Object {
    public static final empty = new Entity();

    public var pivotedX(get, never): Float;
    public var pivotedY(get, never): Float;

    function get_pivotedX()
        return x - pivotX * scaledWidth;

    function get_pivotedY()
        return y - pivotY * scaledHeight;

    public var centerX(get, never): Float;
    public var centerY(get, never): Float;

    function get_centerX()
        return pivotedX + scaledWidth * .5;

    function get_centerY()
        return pivotedY + scaledHeight * .5;

    public var scaledWidth(get, never): Float;

    public var scaledHeight(get, never): Float;

    function get_scaledWidth(): Float
        return width * scaleX;

    function get_scaledHeight(): Float
        return height * scaleY;

    public var tags(default, null): Tags = new Tags();

    public var active = true;
    public var isStarted = false;
    public var isCreated = false;
    public var destroyed(default, null) = false;

    var onDestroyed = false;

    public var collidable = true;
    public var pivotX: Float = 0;
    public var pivotY: Float = 0;
    public var width(default, null): Float = 0;
    public var height(default, null): Float = 0;
    public var gridSize: Int = 1;

    public var scene: Null<GameScene>;

    public function new(?scene: GameScene) {
        super();
        this.scene = scene;
    }

    public function attachScene(scene: GameScene) {
        this.scene = scene;
    }

    public function detachScene() {
        if(scene == null) return;
        scene.remove(this);
    }

    public inline function setPivot(px: Float, py: Float) {
        pivotX = px;
        pivotY = py;
    }

    public function created() {
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).created();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public function started() {
        if(isStarted) return;
        isStarted = true;
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).started();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public function added() {
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).added();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public function removed() {
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).removed();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public final function destroy() {
        if(destroyed) return;

        @:privateAccess App.destroyedEntities.push(this);
        destroyed = true;

        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).destroy();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public function onDestroy() {
        if(onDestroyed) return;

        onDestroyed = true;
        remove();

        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).onDestroy();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public function pause() {
        active = false;
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).pause();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    public function resume() {
        active = true;

        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity)
                    cast(child, Entity).resume();
                else
                    go(child.children);
            }
        }
        go(children);
    }

    final public inline function togglePause() {
        if(active)
            pause();
        else
            resume();
    }

    public function update(dt: Float) {
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity) {
                    final e = cast(child, Entity);
                    if(e.destroyed) {
                        e.onDestroy();
                        e.remove();
                        continue;
                    }
                    if(!e.isStarted) {
                        e.started();
                        e.isStarted = true;
                    }
                    if(e.active && e.isStarted)
                        e.update(dt);
                } else {
                    go(child.children);
                }
            }
        }
        go(children);
    }

    public function fixedUpdate(dt: Float) {
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity) {
                    final e = cast(child, Entity);
                    if(!e.isStarted) {
                        e.started();
                        e.isStarted = true;
                    }
                    if(e.active && e.isStarted)
                        e.fixedUpdate(dt);
                } else {
                    go(child.children);
                }
            }
        }

        go(children);
    }

    public function afterUpdate(dt: Float) {
        function go(cs: Array<h2d.Object>) {
            for(child in cs) {
                if(child is Entity) {
                    final e = cast(child, Entity);
                    if(!e.isStarted) {
                        e.started();
                        e.isStarted = true;
                    }
                    if(e.active && e.isStarted)
                        e.afterUpdate(dt);
                } else {
                    go(child.children);
                }
            }
        }
        go(children);
    }

    public inline function addTag(tag: String) {
        tags.add(tag);
    }

    public inline function addTags(names: Iterable<String>) {
        for(name in names)
            addTag(name);
    }

    public inline function removeTag(tag: String) {
        tags.remove(tag);
    }

    public inline function removeTags(names: Iterable<String>) {
        for(name in names)
            removeTag(name);
    }

    public inline function clearTags() {
        tags.clear();
    }

    public inline function existTag(name: String): Bool
        return tags.existTag(name);

    public inline function existTags(names: Array<String>): Bool
        return tags.existTags(names);

    public inline function existAnyTag(names: Array<String>): Bool
        return tags.existAnyTag(names);

    // Collider
    public var collider(default, null): Collider = Collider.empty;

    public inline function setCollider(collider: Collider) {
        this.collider = collider;
        collider.added(this);
    }

    public inline function checkEntity(other: Entity): Bool
        return Collide.check(this, other);

    public inline function checkEntityAt(other: Entity, dx: Float, dy: Float): Bool
        return Collide.checkAt(this, other, dx, dy);

    public inline function checks(es: Iterable<Entity>): Bool
        return Collide.checks(this, es);

    public inline function checksAt(es: Iterable<Entity>, dx: Float, dy: Float): Bool
        return Collide.checksAt(this, es, dx, dy);

    public function checkType<T: Entity>(type: Class<T>): Bool
        return scene?.findEntities(type)?.any(e -> Collide.check(this, e)) ?? false;

    public inline function checkTypeAt<T: Entity>(type: Class<T>, dx: Float, dy: Float): Bool {
        x += dx;
        y += dy;
        final ret = checkType(type);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function checkTag(tags: Array<String>): Bool
        return scene?.getEntitiesWithTag(tags, collider.bounds)?.any(e -> Collide.check(this, e)) ?? false;

    public inline function checkTagAt(tags: Array<String>, dx: Float, dy: Float): Bool {
        x += dx;
        y += dy;
        final ret = checkTag(tags);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function collides(es: Iterable<Entity>): Option<Entity>
        return if(scene == null) None else es.findOption(e -> Collide.check(this, e));

    public inline function collidesAt(es: Iterable<Entity>, dx: Float, dy: Float): Option<Entity> {
        x += dx;
        y += dy;
        final ret = collides(es);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function collideTag(tags: Array<String>): Option<Entity>
        return scene?.getEntitiesWithTag(tags, collider.bounds)?.findOption(e -> Collide.check(this, e)) ?? None;

    public inline function collideTagAt(tags: Array<String>, dx: Float, dy: Float): Option<Entity> {
        x += dx;
        y += dy;
        final ret = collideTag(tags);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function checkAnyTag(tags: Array<String>): Bool {
        return scene?.getEntitiesWithTag(tags, collider.bounds)?.any(e -> Collide.check(this, e)) ?? false;
    }

    public inline function checkAnyTagAt(tags: Array<String>, dx: Float, dy: Float): Bool {
        x += dx;
        y += dy;
        final ret = checkAnyTag(tags);
        x -= dx;
        y -= dy;
        return ret;
    }

    public inline function collideAnyTag(tags: Array<String>): Option<Entity> {
        return scene?.getEntitiesWithAnyTag(tags, collider.bounds)?.findOption(e -> Collide.check(this, e)) ?? None;
    }

    public inline function collideAnyTagAt(tags: Array<String>, dx: Float, dy: Float): Option<Entity> {
        x += dx;
        y += dy;
        final ret = collideAnyTag(tags);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function onCollideX(hit: Entity) {}

    public function onCollideY(hit: Entity) {}

    override function getBoundsRec(relativeTo: h2d.Object, out: h2d.col.Bounds, forSize: Bool) {
        final baseX = x;
        final baseY = y;
        x = pivotedX;
        y = pivotedY;
        super.getBoundsRec(relativeTo, out, forSize);
        x = baseX;
        y = baseY;
    }

    override function drawRec(ctx: RenderContext) {
        final baseX = x;
        final baseY = y;
        x = pivotedX;
        y = pivotedY;
        super.drawRec(ctx);
        x = baseX;
        y = baseY;
    }
}
