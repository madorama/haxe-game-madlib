package tests;

import haxe.ds.Option;
import utest.Assert;

using madlib.extensions.OptionExt;

@:noCompletion
class TestOptionExt extends utest.Test {
    function testWithDefault() {
        Assert.equals(Some(42).withDefault(0), 42);
        Assert.equals(None.withDefault(0), 0);
    }

    function testWithDefaultLazy() {
        Assert.equals(Some(42).withDefaultLazy(() -> 0), 42);
        Assert.equals(None.withDefaultLazy(() -> 0), 0);
    }

    function testMap() {
        Assert.same(Some(42).map(x -> x * 2), Some(84));
        Assert.same(None.map(x -> x * 2), None);
    }

    function testFlatten() {
        Assert.same(Some(Some(42)).flatten(), Some(42));
        Assert.same(Some(Some(Some(42))).flatten().flatten(), Some(42));
        Assert.same(Some(None).flatten(), None);
        Assert.same(None.flatten(), None);
    }

    function testFlatMap() {
        function action(x: String): Option<String>
            return if(x == "") None else Some(x);
        final username = Some("test");
        final password = Some("");
        Assert.same(username.flatMap(action), Some("test"));
        Assert.same(password.flatMap(action), None);
        Assert.same(None.flatMap(x -> x), None);
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
        Assert.same(arr, [0, 2, 4]);

        arr.resize(0);
        None.each(action);
        Assert.same(arr, []);
    }

    function testOfValue() {
        Assert.same(Std.parseInt("foobar").ofValue(), None);
        Assert.same(Std.parseInt("42").ofValue(), Some(42));
    }

    function testToArray() {
        Assert.same(Some(42).toArray(), [42]);
        Assert.same(None.toArray(), []);
    }
}
