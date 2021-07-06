package tests;

import madlib.Property;
import utest.Assert;

@:noCompletion
class TestProperty extends utest.Test {
    final property = new Property(0);
    var mul2 = 0;

    function setupClass() {
        property.onValueChange(n -> {
            mul2 = n * 2;
        });
    }

    function setup() {
        mul2 = 0;
    }

    function testValueChange() {
        Assert.equals(mul2, 0);
        property.value = 42;
        Assert.equals(mul2, 84);
    }

    function testSilently() {
        Assert.equals(mul2, 0);
        property.setSilently(42);
        Assert.equals(mul2, 0);
    }
}
