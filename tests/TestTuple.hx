package tests;

import madlib.Tuple;
import utest.Assert;

@:noCompletion
class TestTuple1 extends utest.Test {
    final x = Tuple1.of(42);

    function testMap() {
        Assert.same(x.map(x -> x * 2), Tuple1.of(84));
    }

    function testApply() {
        Assert.same(x.apply(x -> x * 2), 84);
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
        Assert.same(x.mapFirst(x -> x + ", World!"), Tuple.of("Hello, World!", 42));
        Assert.same(x.mapSecond(x -> x * 2), Tuple.of("Hello", 84));
        x.flip() == Tuple.of(42, "Hello");
        x == Tuple.of("Hello", 42);
    }

    function testApply() {
        Assert.same(x.apply((x, y) -> '${x},${y}'), "Hello,42");
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
        Assert.same(x.mapFirst(x -> x + ", World!"), Tuple3.of("Hello, World!", 42, 3.14));
        Assert.same(x.mapSecond(x -> x * 2), Tuple3.of("Hello", 84, 3.14));
        Assert.same(x.mapThird(x -> x * 0.5), Tuple3.of("Hello", 42, 1.57));
        Assert.same(x.mapAll(x -> x + ", World!", x -> x * 2, x -> x * 0.5), Tuple3.of("Hello, World!", 84, 1.57));
    }

    function testApply() {
        Assert.same(x.apply((x, y, z) -> '${x},${y + z}'), "Hello,45.14");
    }
}
