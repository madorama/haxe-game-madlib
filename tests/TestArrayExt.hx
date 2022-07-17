package tests;

import haxe.Int64;
import haxe.ds.Option;
import madlib.Math;
import madlib.Random;
import madlib.Tuple.Tuple2;
import madlib.extensions.AssertExt;
import utest.Assert;

using madlib.extensions.ArrayExt;

@:noCompletion
class TestArrayExt extends utest.Test {
    function testPushIf() {
        Assert.same([0, 1, 2, 3], [0, 1, 2].pushIf(true, 3));
        Assert.same([0, 1, 2], [0, 1, 2].pushIf(false, 3));
    }

    function testGetOption() {
        final xs = [0, 1, 2];
        Assert.same(Some(0), xs.getOption(0));
        Assert.same(Some(2), xs.getOption(2));
        AssertExt.isNone(xs.getOption(-1));
        AssertExt.isNone(xs.getOption(3));
        AssertExt.isNone([].getOption(0));
    }

    function testEach() {
        var sum = 0;

        [1, 2, 3].each(x -> sum += x);
        Assert.equals(6, sum);

        sum = 0;
        [].each(x -> sum += x);
        Assert.equals(0, sum);
    }

    function testEachi() {
        var sum = 0;
        [1, 2, 3].eachi((i, x) -> sum += x * i);
        Assert.equals(8, sum);

        sum = 0;
        [].eachi((i, x) -> sum += x * i);
        Assert.equals(0, sum);
    }

    function testMapi() {
        final expected = [
            { index: 0, value: "foo" },
            { index: 1, value: "bar" }
        ];
        Assert.same(expected, ["foo", "bar"].mapi((i, x) -> {index: i, value: x }));
    }

    function testFlatten() {
        Assert.same([0, 1, 2, 3, 4, 5], [[0, 1], [2, 3], [4, 5]].flatten());
        Assert.same([[0], [1], [2, 3]], [[[0], [1]], [], [[2, 3]]].flatten());
    }

    function testFlatMap() {
        Assert.same([0, 1, 2, 3], [[0, 1], [2, 3]].flatMap(x -> x));
    }

    function testAny() {
        Assert.isTrue([1, 2, 3].any(x -> x == 2));
        Assert.isTrue([1, 1, 1].any(x -> x == 1));
        Assert.isFalse([1, 2, 3].any(x -> x == 42));
        Assert.isFalse([].any(x -> x == 42));
    }

    function testAll() {
        Assert.isTrue([42, 42, 42].all(x -> x == 42));
        Assert.isFalse([42, 42, 0].all(x -> x == 42));
        Assert.isFalse([1, 2, 3].all(x -> x == 42));
        Assert.isTrue([].all(x -> x == 42));
    }

    function testReduce() {
        Assert.same(15, [1, 2, 3, 4, 5].reduce(0, (acc, x) -> acc + x));
        Assert.same([0, 1, 2, 3], [[0, 1], [2, 3]].reduce([], (acc, xs) -> acc.concat(xs)));
        Assert.same(0, [].reduce(0, (acc, x) -> acc + x));
    }

    function testReducei() {
        final expected = [
            { index: 0, value: 5 },
            { index: 1, value: 4 },
            { index: 2, value: 3 }
        ];
        Assert.same(expected, [5, 4, 3].reducei([], (acc, i, x) -> acc.concat([{ index: i, value: x }])));
    }

    function testIsEmpty() {
        Assert.isTrue([].isEmpty());
        Assert.isFalse([0, 1, 2].isEmpty());
    }

    function testFind() {
        Assert.equals(2, [1, 2, 3].find(x -> x == 2));
        Assert.isNull([1, 2, 3].find(x -> x == 0));
    }

    function testFindOption() {
        Assert.same(Some(2), [1, 2, 3].findOption(x -> x == 2));
        AssertExt.isNone([1, 2, 3].findOption(x -> x == 0));
    }

    function testFindIndex() {
        Assert.equals(1, [1, 2, 3].findIndex(x -> x == 2));
        Assert.equals(-1, [1, 2, 3].findIndex(x -> x == 0));
    }

    function testFilterNull() {
        Assert.same([0, 1, 2, 3], [0, null, 1, 2, null, null, 3].filterNull());
    }

    function testFilterNone() {
        Assert.same([0, 1, 2], [Some(0), None, Some(1), Some(2), None, None].filterNone());
    }

    function specCompare() {
        [0, 1, 2].compare([]) > 0;
        [0, 1, 2].compare([0, 1, 2]) == 0;
        ["a"].compare([]) > 0;
        ["a"].compare(["b"]) < 0;
    }

    function testCross() {
        Assert.same([[1, 3], [1, 4], [2, 3], [2, 4]], [1, 2].cross([3, 4]));
    }

    function testFirst() {
        Assert.same(Some(1), [1, 2, 3].first());
        Assert.same(Some(1), [1, 2, 3].first(Math.isOdd));
        AssertExt.isNone([42].first(Math.isOdd));
        AssertExt.isNone([].first());
    }

    function testLast() {
        Assert.same(Some(4), [1, 2, 3, 4].last());
        Assert.same(Some(3), [1, 2, 3, 4].last(Math.isOdd));
        AssertExt.isNone([42].last(Math.isOdd));
        AssertExt.isNone([].last());
    }

    function testIntersperse() {
        AssertExt.isEmpty([].intersperse(-1));
        Assert.same([0], [0].intersperse(-1));
        Assert.same([0, -1, 1, -1, 2], [0, 1, 2].intersperse(-1));
    }

    function testIntersperseLazy() {
        AssertExt.isEmpty([].intersperseLazy(() -> -1));
        Assert.same([0], [0].intersperseLazy(() -> -1));
        Assert.same([0, -1, 1, -1, 2], [0, 1, 2].intersperseLazy(() -> -1));
    }

    function testReversed() {
        final xs = [0, 1, 2];
        Assert.same([2, 1, 0], xs.reversed());
        Assert.same([0, 1, 2], xs);
    }

    function testSample() {
        Assert.same(0, [0, 1, 2].sample(new Random(Int64.ofInt(42))));
    }

    function testString() {
        Assert.equals("[0, 1, 2]", [0, 1, 2].string());
        Assert.equals("[]", [].string());
    }

    function testShuffle() {
        Assert.same([1, 2, 0], [0, 1, 2].shuffle(new Random(Int64.ofInt(42))));
    }

    function testTake() {
        Assert.same([0, 1, 2], [0, 1, 2, 3, 4, 5].take(3));
        AssertExt.isEmpty([].take(3));
    }

    function testTakeUntil() {
        Assert.same([0, 1, 2], [0, 1, 2, 3, 4, 5].takeUntil(x -> x < 3));
    }

    function testDrop() {
        Assert.same([3, 4, 5], [0, 1, 2, 3, 4, 5].drop(3));
        AssertExt.isEmpty([].drop(3));
    }

    function testDropUntil() {
        Assert.same([3, 4, 5], [0, 1, 2, 3, 4, 5].dropUntil(x -> x < 3));
    }

    function testSorted() {
        final objects = [
            { name: "木の棒", price: 5 },
            { name: "銅の剣", price: 20 },
            { name: "なべのふた", price: 5 },
            { name: "青銅の盾", price: 100 },
            { name: "薬草", price: 8 },
            { name: "解毒剤", price: 16 },
        ];
        final sortedObjects = [
            objects[0], objects[2], objects[4], objects[5], objects[1], objects[3],
        ];
        Assert.same(sortedObjects, objects.sorted((x, y) -> thx.Ints.compare(x.price, y.price)));
        AssertExt.notSame(sortedObjects, objects);
    }

    function testFindBestValue() {
        final xs = [0, 1, 2, 3];
        Assert.same(Some(3), xs.findBestValue(x -> x));
        Assert.same(Some(0), xs.findBestValue(x -> -x));
        AssertExt.isNone([].findBestValue(x -> x));

        final objects = [
            { name: "勇者", mp: 20 },
            { name: "戦士", mp: 0 },
            { name: "魔法使い", mp: 20 },
            { name: "僧侶", mp: 15 },
            { name: "狂戦士", mp: 0 },
        ];
        Assert.same(Some({ name: "魔法使い", mp: 20 }), objects.findBestValue(x -> x.mp));
    }

    function testFindNearestValue() {
        final xs = [1, 3, 4.5, 5.5, 7];
        Assert.same(Some(7), xs.findNearestValue(6.6, x -> x));
        Assert.same(Some(1), xs.findNearestValue(-100, x -> x));
        Assert.same(Some(4.5), xs.findNearestValue(5, x -> x));
        Assert.same(Some(1), xs.findNearestValue(2, x -> x));
        AssertExt.isNone([].findNearestValue(0, x -> x));
    }

    function testFindNearestValues() {
        final xs = [1, 3, 4.5, 5.5, 7];
        Assert.same([4.5, 5.5], xs.findNearestValues(5, x -> x));
        Assert.same([7], xs.findNearestValues(6.6, x -> x));
        AssertExt.isEmpty([].findNearestValues(50, x -> x));
    }

    function testCreate() {
        Assert.same([0, 0, 0, 0, 0], ArrayExt.create(5, () -> 0));
        AssertExt.isEmpty(ArrayExt.create(-1, () -> 0));
    }

    function testCreatei() {
        Assert.same([0, 1, 2, 3, 4], ArrayExt.createi(5, i -> i));
        AssertExt.isEmpty(ArrayExt.createi(-1, i -> i));
    }

    function testMaxBy() {
        Assert.same(Some(4), [0, 1, 2, 3, 4].maxBy(thx.Ints.order));
    }

    function testMinBy() {
        Assert.same(Some(0), [0, 1, 2, 3, 4].minBy(thx.Ints.order));
    }

    function testUnzip() {
        Assert.same(Tuple2.of([0, 1, 2], [3, 4, 5]), [Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)].unzip());
    }

    function testZip() {
        Assert.same([Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)], [0, 1, 2].zip([3, 4, 5]));
        Assert.same([Tuple2.of(0, 3)], [0].zip([3, 4, 5]));
        Assert.same([Tuple2.of(0, 3)], [0, 1, 2].zip([3]));
    }

    function testIntArraySum() {
        Assert.equals(6, [1, 2, 3].sum());
        Assert.equals(0, [].sum());
    }

    function testIntArrayAverage() {
        Assert.floatEquals(2.5, [1, 2, 3, 4].average());
        Assert.floatEquals(0, [].average());
    }

    function testIntArrayMax() {
        Assert.same(Some(3), [0, 1, 2, 3].max());
        AssertExt.isNone([].max());
    }

    function testIntArrayMin() {
        Assert.same(Some(0), [0, 1, 2, 3].min());
        AssertExt.isNone([].min());
    }

    function testFloatArraySum() {
        Assert.equals(6.9, [1.2, 2.3, 3.4].sum());
        Assert.equals(0, [].sum());
    }

    function testFloatArrayAverage() {
        Assert.floatEquals(2.85, [1.2, 2.3, 3.4, 4.5].average());
        Assert.floatEquals(0, [].average());
    }

    function testFloatArrayMax() {
        Assert.same(Some(3.4), [0.1, 1.2, 2.3, 3.4].max());
        AssertExt.isNone([].max());
    }

    function testFloatArrayMin() {
        Assert.same(Some(0.1), [0.1, 1.2, 2.3, 3.4].min());
        AssertExt.isNone([].min());
    }
}
