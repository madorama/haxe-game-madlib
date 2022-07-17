package tests;

import haxe.ds.Option;
import madlib.Math;
import madlib.Tuple;
import madlib.extensions.AssertExt;
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
        Assert.same(Some(1), [1, 2, 3].iterator().findOption(Math.isOdd));
        Assert.same(Some(2), [1, 2, 3].iterator().findOption(Math.isEven));
        AssertExt.isNone([1, 2, 3].iterator().findOption(x -> x == 42));
        AssertExt.isNone([].iterator().findOption(x -> x == 42));
    }

    function testGetOption() {
        Assert.same(Some(1), [1, 2, 3].iterator().getOption(0));
        Assert.same(Some(3), [1, 2, 3].iterator().getOption(2));
        AssertExt.isNone([1, 2, 3].iterator().getOption(-1));
        AssertExt.isNone([1, 2, 3].iterator().getOption(3));
        AssertExt.isNone([].iterator().getOption(0));
    }

    function testFilter() {
        Assert.same([1, 3], [1, 2, 3].iterator().filter(Math.isOdd));
        Assert.same([], [].iterator().filter(Math.isOdd));
    }

    function testFilterNull() {
        Assert.same([0, 2, 3, 6], [0, null, 2, 3, null, null, 6].iterator().filterNull());
    }

    function testFilterOption() {
        Assert.same([0, 2, 5], [Some(0), None, Some(2), None, None, Some(5)].iterator().filterOption());
    }

    function testEach() {
        var result = 0;
        [9, 42].iterator().each(x -> result += x * 2);
        Assert.equals(102, result);

        result = 0;
        [].iterator().each(x -> result += x * 2);
        Assert.equals(0, result);
    }

    function testEachi() {
        var result = 0;
        [9, 42].iterator().eachi((i, x) -> result += (i + 1) * x);
        Assert.equals(93, result);

        result = 0;
        [].iterator().eachi((i, x) -> result += i * x);
        Assert.equals(0, result);
    }

    function testMap() {
        Assert.same([2, 4, 6], [1, 2, 3].iterator().map(x -> x * 2));
        Assert.same([], [].iterator().map(x -> x * 2));
    }

    function testMapi() {
        Assert.same([0, 2, 6], [1, 2, 3].iterator().mapi((i, x) -> i * x));
        Assert.same([], [].iterator().mapi((i, x) -> i * x));
    }

    function testReduce() {
        Assert.same(15, [1, 2, 3, 4, 5].iterator().reduce(0, (acc, x) -> acc + x));
        Assert.same([0, 1, 2, 3], [[0, 1], [2, 3]].iterator().reduce([], (acc, xs) -> acc.concat(xs)));
        Assert.same(0, [].iterator().reduce(0, (acc, x) -> acc + x));
    }

    function testReducei() {
        final expected = [{ index: 0, value: 5 }, { index: 1, value: 4 }, { index: 2, value: 3 }];
        final value = [5, 4, 3].iterator().reducei([], (acc, i, x) -> acc.concat([{ index: i, value: x }]));
        Assert.same(expected, value);
    }

    function testFirst() {
        Assert.same(Some(1), [1, 2, 3].iterator().first());
        Assert.same(Some(1), [1, 2, 3].iterator().first(Math.isOdd));
        AssertExt.isNone([42].iterator().first(Math.isOdd));
        AssertExt.isNone([].iterator().first());
    }

    function testLast() {
        Assert.same(Some(4), [1, 2, 3, 4].iterator().last());
        Assert.same(Some(3), [1, 2, 3, 4].iterator().last(Math.isOdd));
        AssertExt.isNone([42].iterator().last(Math.isOdd));
        AssertExt.isNone([].iterator().last());
    }

    function testIndexOf() {
        Assert.equals(1, [0, 1, 2].iterator().indexOf(1));
        Assert.equals(-1, [].iterator().indexOf(42));
    }

    function testReversed() {
        Assert.same([2, 1, 0], [0, 1, 2].iterator().reversed());
    }

    function testTakeUntil() {
        Assert.same([0, 1, 2], [0, 1, 2, 3, 4, 5].iterator().takeUntil(x -> x < 3));
    }

    function testDropUntil() {
        Assert.same([3, 4, 5], [0, 1, 2, 3, 4, 5].iterator().dropUntil(x -> x < 3));
    }

    function testUnzip() {
        Assert.same(Tuple2.of([0, 1, 2], [3, 4, 5]), [Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)].iterator().unzip());
    }

    function testZip() {
        Assert.same([Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)], [0, 1, 2].iterator().zip([3, 4, 5].iterator()));
        Assert.same([Tuple2.of(0, 3)], [0].iterator().zip([3, 4, 5].iterator()));
        Assert.same([Tuple2.of(0, 3)], [0, 1, 2].iterator().zip([3].iterator()));
    }

    function testToArray() {
        Assert.same([0, 1, 2], [0, 1, 2].iterator().toArray());
    }
}
