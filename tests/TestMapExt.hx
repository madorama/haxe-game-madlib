package tests;

import madlib.Option;
import madlib.extensions.AssertExt;
import utest.Assert;

using madlib.extensions.MapExt;
using madlib.extensions.StringExt;

class TestMapExt extends utest.Test {
    function testMapWithKey() {
        Assert.same(["x" => 2, "y" => 4, "z" => 6], ["x" => 1, "y" => 2, "z" => 3].mapWithKey((_, v) -> v * 2));
        Assert.same([1 => 1, 2 => 4, 3 => 9], [1 => 1, 2 => 2, 3 => 3].mapWithKey((k, v) -> k * v));
    }

    function testMapValues() {
        Assert.same([1 => 2, 2 => 4, 3 => 6], [1 => 1, 2 => 2, 3 => 3].mapValues(v -> v * 2));
    }

    function testValues() {
        Assert.same([1, 2, 3], ["x" => 1, "y" => 2, "z" => 3].values());
        Assert.same([1, 2, 3], ["z" => 3, "y" => 2, "x" => 1].values());
    }

    function testGetOption() {
        final m = ["x" => 42];

        Assert.same(Some(42), m.getOption("x"));
        AssertExt.isNone(m.getOption("y"));
    }

    function testWithDefault() {
        final m = ["x" => 42];

        Assert.equals(42, m.withDefault("x", 9));
        Assert.equals(9, m.withDefault("y", 9));
    }

    function testWithDefaultLazy() {
        final m = ["x" => 42];

        Assert.equals(42, m.withDefaultLazy("x", () -> 9));
        Assert.equals(9, m.withDefaultLazy("y", () -> 9));
    }

    function testWithDefaultOrSet() {
        final m: Map<String, Int> = MapExt.empty();
        Assert.equals(42, m.withDefaultOrSet("x", 42));
        Assert.equals(42, m.get("x"));
    }

    function testWithDefaultLazyOrSet() {
        final m: Map<String, Int> = MapExt.empty();
        Assert.equals(42, m.withDefaultLazyOrSet("x", () -> 42));
        Assert.equals(42, m.get("x"));
    }

    function testIsEmpty() {
        final m: Map<String, Int> = MapExt.empty();
        Assert.isTrue(m.isEmpty());
        Assert.isFalse(MapExt.isEmpty(["x" => 42]));
    }

    function testMerge() {
        {
            Assert.same(["x" => 42, "y" => 9, "z" => 1], ["x" => 42, "z" => 1].merge(["y" => 9]));
        }

        {
            Assert.same(["x" => 9, "y" => 9, "z" => 1], ["x" => 42, "z" => 1].merge(["x" => 9, "y" => 9]));
        }

        {
            final m = ["x" => 42];
            final m2 = ["y" => 9];
            final m3 = m.merge(m2);
            m3.set("x", 1);
            Assert.same(["x" => 42], m);
        }
    }

    function testReduce() {
        Assert.same("x:1,y:2,z:3", ["x" => 1, "y" => 2, "z" => 3].reduce("", (acc, k, v) -> '${acc}${k}:${v},').reverse().substring(1).reverse());
    }
}
