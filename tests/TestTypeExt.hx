package tests;

import madlib.extensions.TypeExt;
import utest.Assert;

class TestTypeExt extends utest.Test {
    function testValueTypeToString() {
        Assert.equals("Int", TypeExt.valueTypeToString(1));
        Assert.equals("Int", TypeExt.valueTypeToString(1.0));
        Assert.equals("Float", TypeExt.valueTypeToString(4.2));
        Assert.equals("{x:Int,y:String}", TypeExt.valueTypeToString({ x: 42, y: "str" }));
        Assert.equals("{x:Int,y:String}", TypeExt.valueTypeToString({ y: "str", x: 42 }));
        Assert.equals("{obj:{x:Int,y:String}}", TypeExt.valueTypeToString({ obj: { x: 42, y: "str" } }));
    }

    function testSameType() {
        Assert.isTrue(TypeExt.sameType(1, 1));
        Assert.isTrue(TypeExt.sameType({
            x: 42,
            y: "str",
        }, {
            y: "foo",
            x: 9
        }));
        Assert.isTrue(TypeExt.sameType(() -> {}, (x) -> x));

        Assert.isFalse(TypeExt.sameType(1, 4.2));
    }
}
