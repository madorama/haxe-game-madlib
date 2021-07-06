package madlib.extensions;

import madlib.collider.Collider;
import madlib.collider.ColliderList;
import madlib.collider.Hitbox;
import madlib.geom.Bounds;

class ColExt {
    public inline static function createHitbox(self: Bounds): Collider
        return new Hitbox(self.width, self.height, self.left, self.top);

    public inline static function createHitboxes(self: Array<Bounds>): Collider {
        final hitboxes = self.map(b -> createHitbox(b));
        return new ColliderList(hitboxes);
    }
}
