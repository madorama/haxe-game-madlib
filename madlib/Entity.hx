package madlib;

import haxe.ds.Option;
import hxmath.math.Vector2;
import madlib.GameScene;
import madlib.collider.Collide;
import madlib.collider.Collider;
import madlib.collider.Hitbox;
import madlib.draw.Layers;
import madlib.geom.Bounds;
import thx.Set;

using madlib.extensions.IterableExt;

class Tags {
    var tags(default, null): Set<String> = Set.createString();

    public function new() {}

    public inline function existTag(name: String): Bool
        return tags.exists(name);

    public inline function existTags(names: Iterable<String>): Bool
        return names.all(existTag);

    public inline function add(name: String) {
        tags.add(name);
    }

    public inline function adds(names: Iterable<String>) {
        for(name in names)
            tags.add(name);
    }

    public inline function remove(name: String) {
        tags.remove(name);
    }

    public inline function removes(names: Iterable<String>) {
        for(name in names)
            tags.remove(name);
    }

    public inline function clear() {
        tags = tags.empty();
    }

    public inline function iterator(): Iterator<String>
        return tags.iterator();
}

class Entity {
    public var position(default, null) = Vector2.zero;
    public var x(get, set): Float;
    public var y(get, set): Float;

    inline function get_x()
        return position.x;

    function set_x(v: Float)
        return position.x = v;

    inline function get_y()
        return position.y;

    function set_y(v: Float)
        return position.y = v;

    public var pivotedX(get, never): Float;
    public var pivotedY(get, never): Float;

    inline function get_pivotedX()
        return Math.round(x - pivotX * width);

    inline function get_pivotedY()
        return Math.round(y - pivotY * height);

    public var centerX(get, never): Float;
    public var centerY(get, never): Float;

    function get_centerX()
        return pivotedX + width * .5;

    function get_centerY()
        return pivotedY + height * .5;

    public var tags(default, null): Tags = new Tags();

    public var visible = true;
    public var active = true;
    public var isStarted = false;
    public var isCreated = false;
    public var destroyed(default, null) = false;
    public var collidable = true;
    public var pivotX: Float = 0;
    public var pivotY: Float = 0;
    public var width(default, null): Float = 0;
    public var height(default, null): Float = 0;
    public var gridSize: Int = 1;

    public var scene: Null<GameScene>;

    public function new(?scene: GameScene) {
        if(scene != null)
            this.scene = scene;
    }

    public function attachScene(scene: GameScene) {
        this.scene = scene;
    }

    public function created() {}

    public function started() {}

    public function added() {}

    public function removed() {}

    public function destroy() {
        destroyed = true;
    }

    public function pause() {
        active = false;
    }

    public function resume() {
        active = true;
    }

    final public inline function togglePause() {
        if(active)
            pause();
        else
            resume();
    }

    public function beforeUpdate(dt: Float) {}

    public function update(dt: Float) {}

    public function fixedUpdate(dt: Float) {}

    public function afterUpdate(dt: Float) {}

    public function draw(layers: Layers) {}

    public inline function setPosition(x: Float, y: Float) {
        this.x = x;
        this.y = y;
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

    public inline function existTags(names: Iterable<String>): Bool
        return tags.existTags(names);

    // Collider
    public var collider(default, null) = new Collider();

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
        return if(scene == null) false else scene.findEntities(type).any(e -> Collide.check(this, e));

    public inline function checkTypeAt<T: Entity>(type: Class<T>, dx: Float, dy: Float): Bool {
        x += dx;
        y += dy;
        final ret = checkType(type);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function checkTag(tag: String): Bool
        return if(scene == null) false else scene.getEntitiesInTag(tag, collider.bounds).any(e -> Collide.check(this, e));

    public inline function checkTagAt(tag: String, dx: Float, dy: Float): Bool {
        x += dx;
        y += dy;
        final ret = checkTag(tag);
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

    public function collideTag(tag: String): Option<Entity>
        return if(scene == null) None else scene.getEntitiesInTag(tag, collider.bounds).findOption(e -> Collide.check(this, e));

    public inline function collideTagAt(tag: String, dx: Float, dy: Float): Option<Entity> {
        x += dx;
        y += dy;
        final ret = collideTag(tag);
        x -= dx;
        y -= dy;
        return ret;
    }

    public function onCollideX(hit: Entity) {}

    public function onCollideY(hit: Entity) {}
}
