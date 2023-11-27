package tests;

import madlib.extensions.IntExt;
import utest.Assert;

class TestIntExt extends utest.Test {
    function testCompare() {
        Assert.equals(0, IntExt.compare(0, 0));
        Assert.equals(-1, IntExt.compare(0, 1));
        Assert.equals(1, IntExt.compare(0, -1));
    }
}
