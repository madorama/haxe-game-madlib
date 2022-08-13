package madlib;

import tink.core.Noise;
import tink.core.Signal;

using tweenxcore.Tools;

enum TweenEvent {
    Delayed;
    Running;
    Complete;
}

@:structInit
@:allow(madlib.Tween)
@:tink private class Tw {
    var done = false;
    var name = "";
    var factor = 0.;
    var easeFunction = tweenxcore.Tools.Easing.linear;

    @:signal public var onStart: Noise;
    @:signal public var onUpdate: Float;
    @:signal public var onComplete: Noise;
    public var from: Float;
    public var to: Float;
    public var speed: Float;
    public var delay = 0;

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

    public inline function setDelay(delay: Int): Tw {
        this.delay = delay;
        return this;
    }

    public inline function start(cb: Void -> Void): Tw {
        this.onStart.handle(cb);
        return this;
    }

    public inline function update(cb: Float -> Void): Tw {
        this.onUpdate.handle(cb);
        return this;
    }

    public inline function complete(cb: Void -> Void): Tw {
        this.onComplete.handle(cb);
        return this;
    }

    inline function run(dt: Float): TweenEvent {
        if(delay > 0) {
            delay -= 1;
            return Delayed;
        }
        if(_onStart.disposed) {
            _onStart.trigger(Noise);
            _onStart.dispose();
        }

        factor += speed * dt;
        if(factor >= 1) {
            factor = 1;
            done = true;
        }

        final rate = easeFunction(factor).lerp(from, to);
        _onUpdate.trigger(rate);

        if(done) {
            _onComplete.trigger(Noise);
            return Complete;
        }
        return Running;
    }
}

class Tween {
    final tweens: Array<Tw> = [];

    public static final inst = new Tween();

    public function new() {}

    public function update(dt: Float) {
        for(t in tweens) {
            if(t.run(dt) == Complete)
                tweens.remove(t);
        }
    }

    public function timer(frames: Float, ?onComplete: Void -> Void): Tw {
        final tween = new Tw(0, 1, 1 / frames);
        if(onComplete != null)
            tween.onComplete.handle(onComplete);

        tweens.push(tween);
        return tween;
    }

    public function tween(start: Float, end: Float, frames: Float, delay: Int = 0, ?onUpdate: Float -> Void): Tw {
        final tween = new Tw(start, end, 1 / frames);

        if(onUpdate != null)
            tween.onUpdate.handle(onUpdate);

        tween.setDelay(delay);
        tweens.push(tween);
        return tween;
    }

    public function stop(name: String, withComplete: Bool = false) {
        for(t in tweens) {
            if(t.name != name)
                continue;

            if(withComplete)
                t._onComplete.trigger(Noise);
            tweens.remove(t);
        }
    }
}
