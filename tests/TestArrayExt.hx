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
        Assert.same([0, 1, 2].pushIf(true, 3), [0, 1, 2, 3]);
        Assert.same([0, 1, 2].pushIf(false, 3), [0, 1, 2]);
    }

    function testGetOption() {
        final xs = [0, 1, 2];
        Assert.same(xs.getOption(0), Some(0));
        Assert.same(xs.getOption(2), Some(2));
        Assert.same(xs.getOption(-1), None);
        Assert.same(xs.getOption(3), None);
        Assert.same([].getOption(0), None);
    }

    function testEach() {
        var sum = 0;

        [1, 2, 3].each(x -> sum += x);
        Assert.equals(sum, 6);

        sum = 0;
        [].each(x -> sum += x);
        Assert.equals(sum, 0);
    }

    function testEachi() {
        var sum = 0;
        [1, 2, 3].eachi((i, x) -> sum += x * i);
        Assert.equals(sum, 8);

        sum = 0;
        [].eachi((i, x) -> sum += x * i);
        Assert.equals(sum, 0);
    }

    function testMapi() {
        Assert.same(["foo", "bar"].mapi((i, x) -> {index: i, value: x }), [
            { index: 0, value: "foo" },
            { index: 1, value: "bar" }
        ]);
    }

    function testFlatten() {
        Assert.same([[0, 1], [2, 3], [4, 5]].flatten(), [0, 1, 2, 3, 4, 5]);
        Assert.same([[[0], [1]], [], [[2, 3]]].flatten(), [[0], [1], [2, 3]]);
    }

    function testFlatMap() {
        Assert.same([[0, 1], [2, 3]].flatMap(x -> x), [0, 1, 2, 3]);
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
        Assert.same([1, 2, 3, 4, 5].reduce(0, (acc, x) -> acc + x), 15);
        Assert.same([[0, 1], [2, 3]].reduce([], (acc, xs) -> acc.concat(xs)), [0, 1, 2, 3]);
        Assert.same([].reduce(0, (acc, x) -> acc + x), 0);
    }

    function testReducei() {
        Assert.same([5, 4, 3].reducei([], (acc, i, x) -> acc.concat([{ index: i, value: x }])), [
            { index: 0, value: 5 },
            { index: 1, value: 4 },
            { index: 2, value: 3 }
        ]);
    }

    function testIsEmpty() {
        Assert.isTrue([].isEmpty());
        Assert.isFalse([0, 1, 2].isEmpty());
    }

    function testFind() {
        Assert.equals([1, 2, 3].find(x -> x == 2), 2);
        Assert.isNull([1, 2, 3].find(x -> x == 0));
    }

    function testFindOption() {
        Assert.same([1, 2, 3].findOption(x -> x == 2), Some(2));
        Assert.same([1, 2, 3].findOption(x -> x == 0), None);
    }

    function testFindIndex() {
        Assert.equals([1, 2, 3].findIndex(x -> x == 2), 1);
        Assert.equals([1, 2, 3].findIndex(x -> x == 0), -1);
    }

    function testFilterNull() {
        Assert.same([0, null, 1, 2, null, null, 3].filterNull(), [0, 1, 2, 3]);
    }

    function testFilterNone() {
        Assert.same([Some(0), None, Some(1), Some(2), None, None].filterNone(), [0, 1, 2]);
    }

    function specCompare() {
        [0, 1, 2].compare([]) > 0;
        [0, 1, 2].compare([0, 1, 2]) == 0;
        ["a"].compare([]) > 0;
        ["a"].compare(["b"]) < 0;
    }

    function testCross() {
        Assert.same([1, 2].cross([3, 4]), [[1, 3], [1, 4], [2, 3], [2, 4]]);
    }

    function testFirst() {
        Assert.same([1, 2, 3].first(), Some(1));
        Assert.same([1, 2, 3].first(Math.isOdd), Some(1));
        Assert.same([42].first(Math.isOdd), None);
        Assert.same([].first(), None);
    }

    function testLast() {
        Assert.same([1, 2, 3, 4].last(), Some(4));
        Assert.same([1, 2, 3, 4].last(Math.isOdd), Some(3));
        Assert.same([42].last(Math.isOdd), None);
        Assert.same([].last(), None);
    }

    function testIntersperse() {
        Assert.same([].intersperse(-1), []);
        Assert.same([0].intersperse(-1), [0]);
        Assert.same([0, 1, 2].intersperse(-1), [0, -1, 1, -1, 2]);
    }

    function testIntersperseLazy() {
        Assert.same([].intersperseLazy(() -> -1), []);
        Assert.same([0].intersperseLazy(() -> -1), [0]);
        Assert.same([0, 1, 2].intersperseLazy(() -> -1), [0, -1, 1, -1, 2]);
    }

    function testReversed() {
        final xs = [0, 1, 2];
        Assert.same(xs.reversed(), [2, 1, 0]);
        Assert.same(xs, [0, 1, 2]);
    }

    function testSample() {
        Assert.same([0, 1, 2].sample(new Random(Int64.ofInt(42))), 0);
    }

    function testString() {
        Assert.equals([0, 1, 2].string(), "[0, 1, 2]");
        Assert.equals([].string(), "[]");
    }

    function testShuffle() {
        Assert.same([0, 1, 2].shuffle(new Random(Int64.ofInt(42))), [1, 2, 0]);
    }

    function testTake() {
        Assert.same([0, 1, 2, 3, 4, 5].take(3), [0, 1, 2]);
        Assert.same([].take(3), []);
    }

    function testTakeUntil() {
        Assert.same([0, 1, 2, 3, 4, 5].takeUntil(x -> x < 3), [0, 1, 2]);
    }

    function testDrop() {
        Assert.same([0, 1, 2, 3, 4, 5].drop(3), [3, 4, 5]);
        Assert.same([].drop(3), []);
    }

    function testDropUntil() {
        Assert.same([0, 1, 2, 3, 4, 5].dropUntil(x -> x < 3), [3, 4, 5]);
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
        Assert.same(objects.sorted((x, y) -> thx.Ints.compare(x.price, y.price)), sortedObjects);
        AssertExt.notSame(objects, sortedObjects);
    }

    function testFindBestValue() {
        final xs = [0, 1, 2, 3];
        Assert.same(xs.findBestValue(x -> x), Some(3));
        Assert.same(xs.findBestValue(x -> -x), Some(0));
        Assert.same([].findBestValue(x -> x), None);

        final objects = [
            { name: "勇者", mp: 20 },
            { name: "戦士", mp: 0 },
            { name: "魔法使い", mp: 20 },
            { name: "僧侶", mp: 15 },
            { name: "狂戦士", mp: 0 },
        ];
        Assert.same(objects.findBestValue(x -> x.mp), Some({ name: "魔法使い", mp: 20 }));
    }

    function testFindNearestValue() {
        final xs = [1, 3, 4.5, 5.5, 7];
        Assert.same(xs.findNearestValue(6.6, x -> x), Some(7));
        Assert.same(xs.findNearestValue(-100, x -> x), Some(1));
        Assert.same(xs.findNearestValue(5, x -> x), Some(4.5));
        Assert.same(xs.findNearestValue(2, x -> x), Some(1));
        Assert.same([].findNearestValue(0, x -> x), None);
    }

    function testFindNearestValues() {
        final xs = [1, 3, 4.5, 5.5, 7];
        Assert.same(xs.findNearestValues(5, x -> x), [4.5, 5.5]);
        Assert.same(xs.findNearestValues(6.6, x -> x), [7]);
        Assert.same([].findNearestValues(50, x -> x), []);
    }

    function testCreate() {
        Assert.same(ArrayExt.create(5, () -> 0), [0, 0, 0, 0, 0]);
        Assert.same(ArrayExt.create(-1, () -> 0), []);
    }

    function testCreatei() {
        Assert.same(ArrayExt.createi(5, i -> i), [0, 1, 2, 3, 4]);
        Assert.same(ArrayExt.createi(-1, i -> i), []);
    }

    function testMaxBy() {
        Assert.same([0, 1, 2, 3, 4].maxBy(thx.Ints.order), Some(4));
    }

    function testMinBy() {
        Assert.same([0, 1, 2, 3, 4].minBy(thx.Ints.order), Some(0));
    }

    function testUnzip() {
        Assert.same([Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)].unzip(), Tuple2.of([0, 1, 2], [3, 4, 5]));
    }

    function testZip() {
        Assert.same([0, 1, 2].zip([3, 4, 5]), [Tuple2.of(0, 3), Tuple2.of(1, 4), Tuple2.of(2, 5)]);
        Assert.same([0].zip([3, 4, 5]), [Tuple2.of(0, 3)]);
        Assert.same([0, 1, 2].zip([3]), [Tuple2.of(0, 3)]);
    }

    function testIntArraySum() {
        Assert.equals([1, 2, 3].sum(), 6);
        Assert.equals([].sum(), 0);
    }

    function testIntArrayAverage() {
        Assert.floatEquals([1, 2, 3, 4].average(), 2.5);
        Assert.floatEquals([].average(), 0);
    }

    function testIntArrayMax() {
        Assert.same([0, 1, 2, 3].max(), Some(3));
        Assert.same([].max(), None);
    }

    function testIntArrayMin() {
        Assert.same([0, 1, 2, 3].min(), Some(0));
        Assert.same([].min(), None);
    }

    function testFloatArraySum() {
        Assert.equals([1.2, 2.3, 3.4].sum(), 6.9);
        Assert.equals([].sum(), 0);
    }

    function testFloatArrayAverage() {
        Assert.floatEquals([1.2, 2.3, 3.4, 4.5].average(), 2.85);
        Assert.floatEquals([].average(), 0);
    }

    function testFloatArrayMax() {
        Assert.same([0.1, 1.2, 2.3, 3.4].max(), Some(3.4));
        Assert.same([].max(), None);
    }

    function testFloatArrayMin() {
        Assert.same([0.1, 1.2, 2.3, 3.4].min(), Some(0.1));
        Assert.same([].min(), None);
    }
}
