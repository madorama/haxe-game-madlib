package tests;

import madlib.Option;
import madlib.extensions.AssertExt;
import utest.Assert;

using madlib.extensions.NullExt;

@:noCompletion
class TestNullExt extends utest.Test {
    function testWithDefault() {
        Assert.equals(42, Std.parseInt("42").withDefault(0));
        Assert.equals(0, Std.parseInt("foobar").withDefault(0));
    }

    function testWithDefaultLazy() {
        Assert.equals(42, Std.parseInt("42").withDefaultLazy(() -> 0));
        Assert.equals(0, Std.parseInt("foobar").withDefaultLazy(() -> 0));
    }

    function testToOption() {
        AssertExt.isNone(Std.parseInt("foobar").toOption());
        Assert.same(Some(42), Std.parseInt("42").toOption());
    }

    function testIsNull() {
        Assert.isTrue(Std.parseInt("foobar").isNull());
        Assert.isFalse(Std.parseInt("42").isNull());
    }

    function testEach() {
        var x = 0;
        Std.parseInt("42").each(a -> x = a);
        Assert.equals(42, x);

        x = 0;
        Std.parseInt("foobar").each(a -> x = a);
        Assert.equals(0, x);
    }

    function testMap() {
        var x = Std.parseInt("42").map(x -> x);
        Assert.equals(42, x);

        x = Std.parseInt("foobar").map(x -> x);
        Assert.isNull(x);
    }
}
