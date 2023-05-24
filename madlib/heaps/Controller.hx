package madlib.heaps;

import hxd.Key;
import madlib.heaps.GamePad.PadKey;

using madlib.extensions.ArrayExt;

@:structInit
@:access(madlib.heaps.Controller)
class GameKey {
    public final keys: Array<Int> = [];
    public final pads: Array<PadKey> = [];

    public function new() {}

    public inline function resetKey(): GameKey {
        keys.resize(0);
        return this;
    }

    public inline function resetPad(): GameKey {
        pads.resize(0);
        return this;
    }

    public inline function reset(): GameKey {
        resetKey();
        return resetPad();
    }

    public inline function setKey(key: Int): GameKey {
        if(!keys.contains(key)) keys.push(key);
        return this;
    }

    public inline function setKeys(keys: Array<Int>): GameKey {
        keys.each(this.keys.push);
        return this;
    }

    public inline function setPad(pad: PadKey): GameKey {
        if(!pads.contains(pad)) pads.push(pad);
        return this;
    }

    public inline function removeKey(key: Int): GameKey {
        keys.remove(key);
        return this;
    }

    public inline function removeKeys(keys: Array<Int>): GameKey {
        keys.each(removeKey);
        return this;
    }

    public inline function removePad(pad: PadKey): GameKey {
        pads.remove(pad);
        return this;
    }

    public inline function isPressed(): Bool
        return Input.isAnyPressed(keys) || pads.any(Controller.pad.isPressed);

    public inline function isDown(): Bool
        return Input.isAnyDown(keys) || pads.any(Controller.pad.isDown);

    public inline function isReleased(): Bool
        return Input.isAnyReleased(keys) || pads.any(Controller.pad.isReleased);

    var repeatTimer = 0.;
    var repeatCount = 0;

    public inline function isRepeat(?firstRepeatInterval: Float, ?repeatInterval: Float): Bool {
        firstRepeatInterval = firstRepeatInterval ?? Controller.firstRepeatInterval;
        repeatInterval = repeatInterval ?? Controller.repeatInterval;
        return if(isDown()) {
            final result = if(repeatTimer > 0.) false else true;
            final interval = if(repeatCount == 0) firstRepeatInterval else repeatInterval;
            if(repeatTimer >= interval) {
                repeatTimer = 0;
                repeatCount++;
            } else
                repeatTimer += App.tmod;
            result;
        } else {
            repeatTimer = 0.;
            repeatCount = 0;
            false;
        }
    }

    var holdTimer = 0.;
    var completeHold = false;

    public inline function indicateHoldProgress(?decisionFrame: Float): Float {
        decisionFrame = decisionFrame ?? 30;
        if(isDown())
            holdTimer = Math.clamp(holdTimer + App.tmod, 0, decisionFrame);
        else
            holdTimer = 0;
        return holdTimer / decisionFrame;
    }

    public inline function isHold(?decisionFrame: Float): Bool {
        return if(holdTimer > 0.)
            if(!completeHold)
                completeHold = indicateHoldProgress(decisionFrame) >= 1;
            else
                false;
        else
            completeHold = false;
    }
}

class Controller {
    @:nullSafety(Off) public static var pad: GamePad;

    public static var repeatInterval(default, default) = 4.;
    public static var firstRepeatInterval(default, default) = 16.;

    public static final a = new GameKey();
    public static final b = new GameKey();
    public static final x = new GameKey();
    public static final y = new GameKey();
    public static final start = new GameKey();
    public static final select = new GameKey();
    public static final lt = new GameKey();
    public static final rt = new GameKey();
    public static final lb = new GameKey();
    public static final rb = new GameKey();
    public static final left = new GameKey();
    public static final right = new GameKey();
    public static final up = new GameKey();
    public static final down = new GameKey();

    public static function init() {
        pad = new GamePad();

        allReset();

        a.setPad(A);
        b.setPad(B);
        x.setPad(X);
        y.setPad(Y);
        lt.setPad(LT);
        rt.setPad(RT);
        lb.setPad(LB);
        rb.setPad(RB);
        left.setPad(DPAD_LEFT).setPad(AXIS_LEFT_X_NEG).setKeys([Key.LEFT, Key.A]);
        right.setPad(DPAD_RIGHT).setPad(AXIS_LEFT_X_POS).setKeys([Key.RIGHT, Key.D]);
        up.setPad(DPAD_UP).setPad(AXIS_LEFT_Y_POS).setKeys([Key.UP, Key.W]);
        down.setPad(DPAD_DOWN).setPad(AXIS_LEFT_Y_NEG).setKeys([Key.DOWN, Key.S]);
        start.setPad(START);
        select.setPad(SELECT);
    }

    public static function allReset() {
        a.reset();
        b.reset();
        x.reset();
        y.reset();
        lt.reset();
        rt.reset();
        lb.reset();
        rb.reset();
        left.reset();
        right.reset();
        up.reset();
        down.reset();
        start.reset();
        select.reset();
    }
}
