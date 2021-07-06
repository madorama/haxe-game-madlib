package tests;

import haxe.ds.Option;
import madlib.Math;
import madlib.Tuple;
import utest.Assert;

using madlib.extensions.IteratorExt;

@:noCompletion
class TestIteratorExt extends utest.Test {
    function specIsEmpty() {
        [].iterator().isEmpty();
        ![1].iterator().isEmpty();
    }

    function testAny() {
        Assert.isTrue([1, 2, 3].iterator().any(x -> x == 2));
        Assert.isTrue([1, 1, 1].iterator().any(x -> x == 1));

        Assert.isFalse([1, 2, 3].iterator().any(x -> x == 42));
        Assert.isFalse([].iterator().any(x -> x == 42));
    }

    function testAll() {
        Assert.isTrue([42, 42, 42].iterator().all(x -> x == 42));
        Assert.isFalse([42, 42, 0].iterator().all(x -> x == 42));
        Assert.isFalse([1, 2, 3].iterator().all(x -> x == 42));
        Assert.isTrue([].iterator().all(x -> x == 42));
    }

    function testFindOption() {
        Assert.same([1, 2, 3].iterator().findOption(Math.isOdd), Some(1));
        Assert.same([1, 2, 3].iterator().findOption(Math.isEven), Some(2));
        Assert.same([1, 2, 3].iterator().findOption(x -> x == 42), None);
        Assert.same([].iterator().findOption(x -> x == 42), None);
    }

    function testGetOption() {
        Assert.same([1, 2, 3].iterator().getOption(0), Some(1));
        Assert.same([1, 2, 3].iterator().getOption(2), Some(3));
        Assert.same([1, 2, 3].iterator().getOption(-1), None);
        Assert.same([1, 2, 3].iterator().getOption(3), None);
        Assert.same([].iterator().getOption(0), None);
    }

    function testFilter() {
        Assert.same([1, 2, 3].iterator().filter(Math.isOdd), [1, 3]);
        Assert.same([].iterator().filter(Math.isOdd), []);
    }

    function testFilterNull() {
        Assert.same([0, null, 2, 3, null, null, 6].iterator().filterNull(), [0, 2, 3, 6]);
    }

    function testFilterOption() {
        Assert.same([Some(0), None, Some(2), None, None, Some(5)].iterator().filterOption(), [0, 2, 5]);
    }

    function testEach() {
        var result = 0;
        [9, 42].iterator().each(x -> result += x * 2);
        Assert.equals(result, 102);

        result = 0;
        [].iterator().each(x -> result += x * 2);
        Assert.equals(result, 0);
    }

    function testEachi() {
        var result = 0;
        [9, 42].iterator().eachi((i, x) -> result += (i + 1) * x);
        Assert.equals(result, 93);

        result = 0;
        [].iterator().eachi((i, x) -> result += i * x);
        Assert.equals(result, 0);
    }

    function testMap() {
        Assert.same([1, 2, 3].iterator().map(x -> x * 2), [2, 4, 6]);
        Assert.same([].iterator().map(x -> x * 2), []);
    }

    function testMapi() {
        Assert.same([1, 2, 3].iterator().mapi((i, x) -> i * x), [0, 2, 6]);
        Assert.same([].iterator().mapi((i, x) -> i * x), []);
    }

    function testReduce() {
        Assert.same([1, 2, 3, 4, 5].iterator().reduce(0, (acc, x) -> acc + x), 15);
        Assert.same([[0, 1], [2, 3]].iterator().reduce([], (acc, xs) -> acc.concat(xs)), [0, 1, 2, 3]);
        Assert.same([].iterator().reduce(0, (acc, x) -> acc + x), 0);
    }

    function testReducei() {
        Assert.same([5, 4, 3].iterator().reducei([], (acc, i, x) -> acc.concat([{ index: i, value: x }])), [
            { index: 0, value: 5 },
            { index: 1, value: 4 },
            { index: 2, value: 3 }
        ]);
    }

    function testFirst() {
        Assert.same([1, 2, 3].iterator().first(), Some(1));
        Assert.same([1, 2, 3].iterator().first(Math.isOdd), Some(1));
        Assert.same([42].iterator().first(Math.isOdd), None);
        Assert.same([].iterator().first(), None);
    }

    function testLast() {
        Assert.same([1, 2, 3, 4].iterator().last(), Some(4));
        Assert.same([1, 2, 3, 4].iterator().last(Math.isOdd), Some(3));
        Assert.same([42].iterator().last(Math.isOdd), None);
        Assert.same([].iterator().last(), None);
    }

    function testIndexOf() {
        Assert.equals([0, 1, 2].iterator().indexOf(1), 1);
        Assert.equals([].iterator().indexOf(42), -1);
    }

    function testReversed() {
        Assert.same([0, 1, 2].iterator().reversed(), [2, 1, 0]);
    }

    function testTakeUntil() {
        Assert.same([0, 1, 2, 3, 4, 5].iterator().takeUntil(x -> x < 3), [0, 1, 2]);
    }

    function testDropUntil() {
        Assert.same([0, 1, 2, 3, 4, 5].iterator().dropUntil(x -> x < 3), [3, 4, 5]);
    }

    function testUnzip() {
        Assert.same([Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)].iterator().unzip(), Tuple2.of([0, 1, 2], [3, 4, 5]));
    }

    function testZip() {
        Assert.same([0, 1, 2].iterator().zip([3, 4, 5].iterator()), [Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)]);
        Assert.same([0].iterator().zip([3, 4, 5].iterator()), [Tuple2.of(0, 3)]);
        Assert.same([0, 1, 2].iterator().zip([3].iterator()), [Tuple2.of(0, 3)]);
    }

    function testToArray() {
        Assert.same([0, 1, 2].iterator().toArray(), [0, 1, 2]);
    }
}
