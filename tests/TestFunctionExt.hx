package tests;

import utest.Assert;

using madlib.extensions.ArrayExt;
using madlib.extensions.FunctionExt;

@:noCompletion
class TestFunctionExt extends utest.Test {
    function testIdentity() {
        Assert.same([0, 1, 2], [0, 1, 2].map(FunctionExt.identity));
    }

    function testToEffect0() {
        var x = 0;
        final effect = (() -> x = 42).toEffect();
        Assert.same(0, x);
        effect();
        Assert.same(42, x);
    }

    function testLazy() {
        var a = 0;
        function heavyCalc(x: Int) {
            a += x;
            return x;
        }
        final f = heavyCalc.lazy(42);
        Assert.equals(0, a);
        Assert.same(42, f());
        Assert.equals(42, a);
        Assert.same(42, f());
        Assert.equals(42, a);
    }

    function testToEffect1() {
        var sum = 0;
        final effect = ((x) -> sum += x).toEffect();
        Assert.same(0, sum);
        effect(42);
        Assert.same(42, sum);
        effect(9);
        Assert.same(51, sum);
    }

    function testCurry() {
        final sum = ((x, y) -> x + y).curry();
        final add42 = sum(42);
        Assert.same(51, add42(9));
    }

    function testUncurry() {
        final sum = ((x, y) -> x + y).curry();
        Assert.same(51, sum.uncurry()(42, 9));
    }

    function testFlip() {
        final div = (x, y) -> x / y;

        Assert.same(2, div(4, 2));
        Assert.same(2, div.flip()(2, 4));
    }
}
