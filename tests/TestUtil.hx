package tests;

import hxmath.math.IntVector2;
import madlib.Util;
import utest.Assert;

@:noCompletion
class TestUtil extends utest.Test {
    function testCoordId() {
        Assert.equals(Util.coordId(4, 0, 5), 4);
        Assert.equals(Util.coordId(0, 1, 5), 5);
        Assert.equals(Util.coordId(1, 2, 3), 7);
    }

    function testIdCoord() {
        Assert.same(Util.idCoord(4, 5), new IntVector2(4, 0));
        Assert.same(Util.idCoord(5, 5), new IntVector2(0, 1));
        Assert.same(Util.idCoord(7, 3), new IntVector2(1, 2));
    }

    function testTileCoord() {
        Assert.same(Util.tileCoord(24, 31, 8, 8), new IntVector2(3, 3));
    }

    function testSnapGrid() {
        Assert.same(Util.snapGrid(31, 32, 8, 8), new IntVector2(24, 32));
    }

    function testRange() {
        Assert.same(Util.range(-2, 2), [-2, -1, 0, 1, 2]);
        Assert.same(Util.range(2, -2), [2, 1, 0, -1, -2]);
        Assert.same(Util.range(5, 5), [5]);
    }
}
