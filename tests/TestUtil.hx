package tests;

import hxmath.math.IntVector2;
import madlib.Util;
import utest.Assert;

@:noCompletion
class TestUtil extends utest.Test {
    function testCoordId() {
        Assert.equals(4, Util.coordId(4, 0, 5));
        Assert.equals(5, Util.coordId(0, 1, 5));
        Assert.equals(7, Util.coordId(1, 2, 3));
    }

    function testIdCoord() {
        Assert.same(new IntVector2(4, 0), Util.idCoord(4, 5));
        Assert.same(new IntVector2(0, 1), Util.idCoord(5, 5));
        Assert.same(new IntVector2(1, 2), Util.idCoord(7, 3));
    }

    function testTileCoord() {
        Assert.same(new IntVector2(3, 3), Util.tileCoord(24, 31, 8, 8));
    }

    function testSnapGrid() {
        Assert.same(new IntVector2(24, 32), Util.snapGrid(31, 32, 8, 8));
    }

    function testRange() {
        Assert.same([-2, -1, 0, 1, 2], Util.range(-2, 2));
        Assert.same([2, 1, 0, -1, -2], Util.range(2, -2));
        Assert.same([5], Util.range(5, 5));
    }
}
