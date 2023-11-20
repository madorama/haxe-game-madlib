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

    public var timeScale = 1.;

    public var pixelPerfect = false;

    var oldAnim: Option<AseAnim> = None;
    var oldPivotX = Math.NaN;
    var oldPivotY = Math.NaN;
    var oldTimeScale = Math.NaN;
    var oldXFlip = false;
    var oldYFlip = false;

    inline function isChange()
        return posChanged || pivotX != oldPivotX || pivotY != oldPivotY || timeScale != oldTimeScale || xFlip != oldXFlip || yFlip != oldYFlip;

    public var pivotX = 0.;
    public var pivotY = 0.;

    public inline function setPivot(x: Float, y: Float) {
        pivotX = x;
        pivotY = y;
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
                anim = Some(v);
                v.loop = loop ?? v.loop;
                v.currentFrame = startFrame ?? 0;
                currentAnimationName = name;
        }
    }

    override function getBoundsRec(relativeTo: Object, out: Bounds, forSize: Bool) {
        super.getBoundsRec(relativeTo, out, forSize);
        anim.each(anim -> anim.getBoundsRec(relativeTo, out, forSize));
    }

    function syncAnimations(ctx: RenderContext) {
        for(anim in animations) {
            if(posChanged)
                anim.calcAbsPos();

            anim.timeScale = timeScale;
            for(frame in anim.frames) {
                frame.tile.xFlip = xFlip;
                frame.tile.yFlip = yFlip;
                frame.tile.setCenterRatio(pivotX, pivotY);
            }
            anim.sync(ctx);
        }

        oldPivotX = pivotX;
        oldPivotY = pivotY;
        oldTimeScale = timeScale;
        oldXFlip = xFlip;
        oldYFlip = yFlip;
    }

    override function sync(ctx: RenderContext) {
        super.sync(ctx);

        if(pixelPerfect) {
            setPosition(Math.round(x), Math.round(y));
        } else {
            setPosition(x, y);
        }

        if(isChange())
            syncAnimations(ctx);
        else
            anim.each(anim -> anim.sync(ctx));
    }

    override function draw(ctx: RenderContext) {
        anim.each(anim -> anim.draw(ctx));
    }

    public function onAnimEnd(?f: () -> Void) {
        anim.each(anim -> anim.onAnimEnd = f ?? () -> {});
    }
}
