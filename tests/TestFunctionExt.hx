package tests;

import utest.Assert;

using madlib.extensions.ArrayExt;
using madlib.extensions.FunctionExt;

@:noCompletion
class TestFunctionExt extends utest.Test {
    function testIdentity() {
        Assert.same([0, 1, 2].map(FunctionExt.identity), [0, 1, 2]);
    }

    function testToEffect0() {
        var x = 0;
        final effect = (() -> x = 42).toEffect();
        Assert.same(x, 0);
        effect();
        Assert.same(x, 42);
    }

    function testLazy() {
        var a = 0;
        function heavyCalc(x: Int) {
            a += x;
            return x;
        }
        final f = heavyCalc.lazy(42);
        Assert.equals(a, 0);
        Assert.same(f(), 42);
        Assert.equals(a, 42);
        Assert.same(f(), 42);
        Assert.equals(a, 42);
    }

    function testToEffect1() {
        var sum = 0;
        final effect = ((x) -> sum += x).toEffect();
        Assert.same(sum, 0);
        effect(42);
        Assert.same(sum, 42);
        effect(9);
        Assert.same(sum, 51);
    }

    function testCurry() {
        final sum = ((x, y) -> x + y).curry();
        final add42 = sum(42);
        Assert.same(add42(9), 51);
    }

    function testUncurry() {
        final sum = ((x, y) -> x + y).curry();
        Assert.same(sum.uncurry()(42, 9), 51);
    }

    function testFlip() {
        final div = (x, y) -> x / y;

        Assert.same(div(4, 2), 2);
        Assert.same(div.flip()(2, 4), 2);
    }
}
