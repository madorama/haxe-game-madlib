package tests;

import madlib.Property;
import utest.Assert;

@:noCompletion
class TestProperty extends utest.Test {
    final property = new Property(0);
    var mul2 = 0;

    function setupClass() {
        property.onValueChange.add(n -> {
            mul2 = n * 2;
        });
    }

    function setup() {
        mul2 = 0;
    }

    function testValueChange() {
        Assert.equals(0, mul2);
        property.value = 42;
        Assert.equals(84, mul2);
    }

    function testSilently() {
        Assert.equals(0, mul2);
        property.setSilently(42);
        Assert.equals(0, mul2);
    }
}
