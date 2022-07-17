package tests;

import madlib.Tuple;
import utest.Assert;

@:noCompletion
class TestTuple1 extends utest.Test {
    final x = Tuple1.of(42);

    function testMap() {
        Assert.same(Tuple1.of(84), x.map(x -> x * 2));
    }

    function testApply() {
        Assert.same(84, x.apply(x -> x * 2));
    }
}

@:noCompletion
class TestTuple2 extends utest.Test {
    final x = Tuple.of("Hello", 42);

    function specDrops() {
        x.dropLeft() == Tuple1.of(42);
        x.dropRight() == Tuple1.of("Hello");
    }

    function testMaps() {
        Assert.same(Tuple.of("Hello, World!", 42), x.mapFirst(x -> x + ", World!"));
        Assert.same(Tuple.of("Hello", 84), x.mapSecond(x -> x * 2));
    }

    function testApply() {
        Assert.same("Hello,42", x.apply((x, y) -> '${x},${y}'));
    }
}

@:noCompletion
class TestTuple3 extends utest.Test {
    final x = Tuple3.of("Hello", 42, 3.14);

    function specFlip() {
        x.flip() == Tuple3.of(3.14, 42, "Hello");
        x == Tuple3.of("Hello", 42, 3.14);
    }

    function specDrops() {
        x.dropLeft() == Tuple2.of(42, 3.14);
        x.dropRight() == Tuple2.of("Hello", 42);
    }

    function testMaps() {
        Assert.same(Tuple3.of("Hello, World!", 42, 3.14), x.mapFirst(x -> x + ", World!"));
        Assert.same(Tuple3.of("Hello", 84, 3.14), x.mapSecond(x -> x * 2));
        Assert.same(Tuple3.of("Hello", 42, 1.57), x.mapThird(x -> x * 0.5));
        Assert.same(Tuple3.of("Hello, World!", 84, 1.57), x.mapAll(x -> x + ", World!", x -> x * 2, x -> x * 0.5));
    }

    function testApply() {
        Assert.same("Hello,45.14", x.apply((x, y, z) -> '${x},${y + z}'));
    }
}
