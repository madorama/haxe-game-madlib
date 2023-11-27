package madlib.heaps;

import aseprite.AseAnim;
import aseprite.Aseprite;
import h2d.Object;
import h2d.RenderContext;
import h2d.col.Bounds;
import madlib.Option;

using madlib.extensions.AsepriteExt;
using thx.Maps;

@:tink class Sprite extends h2d.Drawable {
    public var currentAnimationName(default, null) = "";

    var anim: Option<AseAnim> = None;
    var animations: Map<String, AseAnim> = [];

    public var width(get, never): Float;
    public var height(get, never): Float;

    inline function get_width()
        return anim.map(anim -> anim.getFrame().tile.width).withDefault(0.);

    inline function get_height()
        return anim.map(anim -> anim.getFrame().tile.height).withDefault(0.);

    public var currentAnimationFrame(get, never): Int;

    inline function get_currentAnimationFrame()
        return anim.map(anim -> anim.currentFrame).withDefault(0);

    @:isVar public var timeScale(default, set): Float = 1.;

    inline function set_timeScale(v: Float): Float {
        isDirty = true;
        return timeScale = v;
    }

    public var pixelPerfect = false;

    var isDirty = true;

    public var pivotX = 0.;
    public var pivotY = 0.;

    public inline function setPivot(x: Float, y: Float) {
        pivotX = x;
        pivotY = y;
        isDirty = true;
    }

    public var pivotedX(get, never): Float;
    public var pivotedY(get, never): Float;

    function get_pivotedX(): Float
        return x - (width * pivotX);

    function get_pivotedY(): Float
        return y - (height * pivotY);

    public var xFlip = false;
    public var yFlip = false;

    public inline function setFlip(xFlip: Bool, yFlip: Bool) {
        this.xFlip = xFlip;
        this.yFlip = yFlip;
        isDirty = true;
    }

    public var pause(get, set): Bool;

    inline function get_pause()
        return switch anim {
            default:
                false;
            case Some(anim):
                anim.pause;
        }

    inline function set_pause(v: Bool)
        return switch anim {
            default:
                v;
            case Some(anim):
                anim.pause = v;
        }

    public function new(?parent: h2d.Object) {
        super(parent);
    }

    public inline function addAnim(name: String, newAnim: AseAnim) {
        newAnim.parent = this;
        animations.set(name, newAnim);
    }

    public inline function addAnimWithAseprite(ase: Aseprite, name: String, loop = false) {
        addAnim(name, ase.getAnimationFromTag(name, loop));
    }

    public function changeAnim(name: String, ?loop: Bool, ?startFrame = 0) {
        if(name == currentAnimationName)
            return;

        switch animations.getOption(name) {
            case None:
                trace('Animation "$name" is not exists');
            case Some(v):
                anim.each(anim -> anim.remove());
                addChild(v);
                anim = Some(v);
                v.loop = loop ?? v.loop;
                v.currentFrame = startFrame ?? 0;
                currentAnimationName = name;
                isDirty = true;
        }
    }

    override function getBoundsRec(relativeTo: Object, out: Bounds, forSize: Bool) {
        super.getBoundsRec(relativeTo, out, forSize);
        anim.each(anim -> anim.getBoundsRec(relativeTo, out, forSize));
    }

    inline function syncAnimation() {
        anim.each(anim -> {
            anim.timeScale = timeScale;
            for(frame in anim.frames) {
                frame.tile.xFlip = xFlip;
                frame.tile.yFlip = yFlip;
                frame.tile.setCenterRatio(pivotX, pivotY);
            }
        });
    }

    override function sync(ctx: RenderContext) {
        super.sync(ctx);

        if(pixelPerfect) {
            setPosition(Math.round(x), Math.round(y));
        } else {
            setPosition(x, y);
        }

        if(isDirty) {
            syncAnimation();
            isDirty = false;
        }
    }

    public function onAnimEnd(?f: () -> Void) {
        anim.each(anim -> anim.onAnimEnd = f ?? () -> {});
    }
}
