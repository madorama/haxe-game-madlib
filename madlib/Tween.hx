package madlib;

import madlib.Event.Events;

using madlib.extensions.ArrayExt;
using tweenxcore.Tools;

@:structInit
@:allow(madlib.Tween)
final class Tw {
    var done = false;
    var name = "";
    var factor = 0.;
    var easeFunction = tweenxcore.Tools.Easing.linear;

    final onStart: Events<Unit> = new Events();
    final onUpdate: Events<Float> = new Events();
    final onComplete: Events<Unit> = new Events();

    public var from: Float;
    public var to: Float;
    public var speed: Float;
    public var delay = 0.;

    public function new(from: Float, to: Float, speed: Float) {
        this.from = from;
        this.to = to;
        this.speed = speed;
    }

    public inline function ease(func: Float -> Float): Tw {
        easeFunction = func;
        return this;
    }

    public inline function setName(name: String): Tw {
        this.name = name;
        return this;
    }

    public inline function setDelay(delay: Float): Tw {
        this.delay = delay;
        return this;
    }

    public inline function addOnStart(cb: Unit -> Void): () -> Void {
        final e = new Event(cb);
        onStart.add(e);
        return () -> e.dispose();
    }

    public inline function addOnUpdate(cb: Float -> Void): () -> Void {
        final e = new Event(cb);
        onUpdate.add(e);
        return () -> e.dispose();
    }

    public inline function addOnComplete(cb: Unit -> Void): () -> Void {
        final e = new Event(cb);
        onComplete.add(e);
        return () -> e.dispose();
    }

    inline function complete() {
        if(onComplete.disposed) return;
        onComplete.invoke(Unit);

        onStart.dispose();
        onUpdate.dispose();
        onComplete.dispose();
    }

    inline function run(dt: Float): Bool {
        if(delay > 0) {
            delay -= dt;
            return false;
        }
        if(!onStart.disposed) {
            onStart.invoke(Unit);
            onStart.dispose();
        }

        factor += speed * dt;
        if(factor >= 1) {
            factor = 1;
            done = true;
        }

        final rate = easeFunction(factor).lerp(from, to);
        onUpdate.invoke(rate);

        if(done) {
            complete();
            return true;
        }
        return false;
    }
}

class Tween {
    final tweens: Array<Tw> = [];

    public static final inst = new Tween();

    public function new() {}

    public function update(dt: Float) {
        var i = 0;
        while(i < tweens.length) {
            final tween = tweens[i];
            if(tween.run(dt)) {
                tweens.splice(i, 1);
                continue;
            }
            i += 1;
        }
    }

    public function timer(frames: Float, delay = 0., ?onComplete: Void -> Void): Tw {
        final tween = new Tw(0, 1, 1 / frames);
        if(onComplete != null) {
            tween.addOnComplete(_ -> onComplete());
        }
        tween.setDelay(delay);
        tweens.push(tween);
        return tween;
    }

    public function tween(start: Float, end: Float, frames: Float, delay = 0., ?onUpdate: Float -> Void): Tw {
        final tween = new Tw(start, end, 1 / frames);

        if(onUpdate != null) {
            tween.addOnUpdate(onUpdate);
        }

        tween.setDelay(delay);
        tweens.push(tween);
        return tween;
    }

    public inline function kill(tw: Tw) {
        tweens.remove(tw);
    }

    public function stop(name: String, withComplete: Bool = false) {
        tweens.removeBy(t -> {
            final r = t.name == name;
            if(r && withComplete) t.complete();
            return r;
        });
    }
}
