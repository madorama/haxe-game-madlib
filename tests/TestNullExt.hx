package tests;

import haxe.ds.Option;
import utest.Assert;

using madlib.extensions.NullExt;

@:noCompletion
class TestNullExt extends utest.Test {
    function testWithDefault() {
        Assert.equals(Std.parseInt("42").withDefault(0), 42);
        Assert.equals(Std.parseInt("foobar").withDefault(0), 0);
    }

    function testWithDefaultLazy() {
        Assert.equals(Std.parseInt("42").withDefaultLazy(() -> 0), 42);
        Assert.equals(Std.parseInt("foobar").withDefaultLazy(() -> 0), 0);
    }

    function testToOption() {
        Assert.same(Std.parseInt("foobar").toOption(), None);
        Assert.same(Std.parseInt("42").toOption(), Some(42));
    }

    function testIsNull() {
        Assert.isTrue(Std.parseInt("foobar").isNull());
        Assert.isFalse(Std.parseInt("42").isNull());
    }

    function testEach() {
        var x = 0;
        Std.parseInt("42").each(a -> x = a);
        Assert.equals(x, 42);

        x = 0;
        Std.parseInt("foobar").each(a -> x = a);
        Assert.equals(x, 0);
    }

    function testMap() {
        var x = Std.parseInt("42").map(x -> x);
        Assert.equals(x, 42);

        x = Std.parseInt("foobar").map(x -> x);
        Assert.isNull(x);
    }
}
