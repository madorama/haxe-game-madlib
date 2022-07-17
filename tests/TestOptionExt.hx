package tests;

import haxe.ds.Option;
import madlib.extensions.AssertExt;
import utest.Assert;

using madlib.extensions.OptionExt;

@:noCompletion
class TestOptionExt extends utest.Test {
    function testWithDefault() {
        Assert.equals(42, Some(42).withDefault(0));
        Assert.equals(0, None.withDefault(0));
    }

    function testWithDefaultLazy() {
        Assert.equals(42, Some(42).withDefaultLazy(() -> 0));
        Assert.equals(0, None.withDefaultLazy(() -> 0));
    }

    function testMap() {
        Assert.same(Some(84), Some(42).map(x -> x * 2));
        AssertExt.isNone(None.map(x -> x * 2));
    }

    function testFlatten() {
        Assert.same(Some(42), Some(Some(42)).flatten());
        Assert.same(Some(42), Some(Some(Some(42))).flatten().flatten());
        AssertExt.isNone(Some(None).flatten());
        AssertExt.isNone(None.flatten());
    }

    function testFlatMap() {
        function action(x: String): Option<String>
            return if(x == "") None else Some(x);
        final username = Some("test");
        final password = Some("");
        Assert.same(Some("test"), username.flatMap(action));
        AssertExt.isNone(password.flatMap(action));
        AssertExt.isNone(None.flatMap(x -> x));
    }

    function specIsNone() {
        None.isNone();
        !Some(42).isNone();
    }

    function testExists() {
        Assert.isTrue(Some(42).exists(x -> x == 42));
        Assert.isTrue(Some([1, 2, 3]).exists(x -> x.contains(2)));
        Assert.isFalse(Some(42).exists(x -> x != 42));
        Assert.isFalse(None.exists(x -> x == 42));
    }

    function testContains() {
        Assert.isTrue(Some(42).contains(42));
        Assert.isFalse(Some(42).contains(0));
        Assert.isFalse(None.contains(42));
    }

    function testEach() {
        final arr = [];
        function action(xs: Array<Int>) {
            for(x in xs)
                arr.push(x * 2);
        }

        Some([0, 1, 2]).each(action);
        Assert.same([0, 2, 4], arr);

        arr.resize(0);
        None.each(action);
        Assert.same([], arr);
    }

    function testOfValue() {
        Assert.same(None, Std.parseInt("foobar").ofValue());
        Assert.same(Some(42), Std.parseInt("42").ofValue());
    }

    function testToArray() {
        Assert.same([42], Some(42).toArray());
        Assert.same([], None.toArray());
    }
}
