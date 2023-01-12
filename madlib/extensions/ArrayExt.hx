package madlib.extensions;

import haxe.ds.Option;
import madlib.Tuple.Tuple2;
import thx.Ord;
import thx.Set;

using madlib.extensions.ArrayExt;

class ArrayExt {
    public inline static function pushIf<T>(self: Array<T>, condition: Bool, item: T): Array<T> {
        if(condition)
            self.push(item);
        return self;
    }

    public inline static function getOption<T>(self: Array<T>, index: Int): Option<T>
        return if(index >= 0 && index < self.length) Some(self[index]) else None;

    public inline static function each<T>(self: Array<T>, action: T -> Void) {
        for(x in self)
            action(x);
    }

    public inline static function eachi<T>(self: Array<T>, action: Int -> T -> Void) {
        for(i in 0...self.length)
            action(i, self[i]);
    }

    public inline static function mapi<T, R>(self: Array<T>, f: Int -> T -> R): Array<R>
        return [for(i in 0...self.length) f(i, self[i])];

    public inline static function flatten<T>(self: Array<Array<T>>): Array<T> {
        #if js
        return untyped __js__('Array.prototype.concat.apply')([], self);
        #else
        return reduce(self, [], (acc, elem) -> acc.concat(elem));
        #end
    }

    public inline static function flatMap<T, R>(self: Array<T>, f: T -> Array<R>): Array<R>
        return flatten(self.map(f));

    public inline static function any<T>(self: Array<T>, predicate: T -> Bool): Bool {
        var result = false;
        for(x in self) {
            if(predicate(x)) {
                result = true;
                break;
            }
        }
        return result;
    }

    public inline static function all<T>(self: Array<T>, predicate: T -> Bool): Bool {
        var result = true;
        for(x in self) {
            if(!predicate(x)) {
                result = false;
                break;
            }
        }
        return result;
    }

    public inline static function reduce<T, Acc>(self: Array<T>, init: Acc, f: Acc -> T -> Acc) {
        for(x in self)
            init = f(init, x);
        return init;
    }

    public inline static function reducei<T, Acc>(self: Array<T>, init: Acc, f: Acc -> Int -> T -> Acc): Acc {
        for(i in 0...self.length)
            init = f(init, i, self[i]);
        return init;
    }

    public inline static function isEmpty<T>(self: Array<T>): Bool
        return self.length == 0;

    public static function find<T>(self: Array<T>, f: T -> Bool): Null<T> {
        var result: Null<T> = null;
        for(x in self) {
            if(f(x)) {
                result = x;
                break;
            }
        }
        return result;
    }

    public inline static function findOption<T>(self: Array<T>, f: T -> Bool): Option<T>
        return NullExt.toOption(self.find(f));

    public inline static function findIndex<T>(self: Array<T>, f: T -> Bool): Int {
        var result = -1;
        for(i in 0...self.length) {
            if(f(self[i])) {
                result = i;
                break;
            }
        }
        return result;
    }

    public inline static function filterNull<T>(self: Array<Null<T>>): Array<T>
        return [for(x in self) if(x != null) x];

    public inline static function filterNone<T>(self: Array<Option<T>>): Array<T> {
        final result = [];
        for(x in self) {
            switch x {
                case None:
                case Some(x):
                    result.push(x);
            }
        }
        return result;
    }

    public inline static function compare<T>(self: Array<T>, other: Array<T>): Int {
        var v = 0;
        if((v = inline thx.Ints.compare(self.length, other.length)) == 0) {
            for(i in 0...self.length) {
                if((v = inline thx.Dynamics.compare(self[i], other[i])) != 0)
                    break;
            }
        }
        return v;
    }

    public inline static function cross<T>(self: Array<T>, other: Array<T>): Array<Array<T>> {
        final result = [];
        for(x in self)
            for(y in other)
                result.push([x, y]);
        return result;
    }

    public inline static function first<T>(self: Array<T>, ?predicate: T -> Bool): Option<T>
        return if(self.length == 0)
            None;
        else if(predicate == null)
            Some(self[0]);
        else {
            var result = None;
            for(x in self) {
                if(predicate(x)) {
                    result = Some(x);
                    break;
                }
            }
            return result;
        }

    public inline static function last<T>(self: Array<T>, ?predicate: T -> Bool): Option<T>
        return if(self.length == 0)
            None;
        else if(predicate == null)
            Some(self[self.length - 1]);
        else {
            var result = None;
            var i = self.length;
            while(--i >= 0) {
                if(predicate(self[i])) {
                    result = Some(self[i]);
                    break;
                }
            }
            return result;
        }

    public inline static function intersperse<T>(self: Array<T>, value: T): Array<T> {
        return if(self.isEmpty()) {
            [];
        } else {
            final result = [self[0]];
            for(i in 1...self.length) {
                result.push(value);
                result.push(self[i]);
            }
            return result;
        }
    }

    public inline static function intersperseLazy<T>(self: Array<T>, f: Void -> T): Array<T> {
        return if(self.isEmpty()) {
            [];
        } else {
            final result = [self[0]];
            for(i in 1...self.length) {
                result.push(f());
                result.push(self[i]);
            }
            return result;
        }
    }

    public inline static function reversed<T>(self: Array<T>): Array<T> {
        final result = self.copy();
        result.reverse();
        return result;
    }

    public inline static function sample<T>(self: Array<T>, ?random: Random): T
        return if(random != null)
            random.choice(self);
        else
            Random.gen.choice(self);

    public inline static function string<T>(self: Array<T>): String
        return '[${self.map(thx.Dynamics.string).join(", ")}]';

    public inline static function shuffle<T>(self: Array<T>, ?random: Random): Array<T>
        return if(random != null)
            random.shuffle(self);
        else
            Random.gen.shuffle(self);

    public inline static function take<T>(self: Array<T>, n: Int): Array<T>
        return self.slice(0, n);

    public inline static function takeUntil<T>(self: Array<T>, f: T -> Bool): Array<T> {
        final result = [];
        for(v in self) {
            if(!f(v))
                break;
            result.push(v);
        }
        return result;
    }

    public inline static function drop<T>(self: Array<T>, n: Int): Array<T>
        return if(n >= self.length) [] else self.slice(n, self.length);

    public inline static function dropUntil<T>(self: Array<T>, f: T -> Bool): Array<T> {
        var done = false;
        final result = [];
        for(v in self) {
            if(done) {
                result.push(v);
                continue;
            }
            if(f(v))
                continue;
            done = true;
            result.push(v);
        }
        return result;
    }

    public inline static function sorted<T>(self: Array<T>, cmp: T -> T -> Int): Array<T> {
        final result = self.copy();
        haxe.ds.ArraySort.sort(result, cmp);
        return result;
    }

    inline static function scoreSort<T: {score: Float}>(self: Array<T>, isAscend: Bool = true): Array<T>
        return self.sorted((x, y) -> if(isAscend) thx.Floats.compare(x.score, y.score) else thx.Floats.compare(y.score, x.score));

    inline static function toScoredArray<T>(self: Array<T>, scoreElement: T -> Float): Array<{item: T, score: Float}>
        return self.map(x -> {
            item: x,
            score: scoreElement(x),
        });

    public inline static function findBestValue<T>(self: Array<T>, scoreElement: T -> Float): Option<T>
        return if(self.length == 0) None; else Some(self.toScoredArray(scoreElement).scoreSort()[self.length - 1].item);

    public inline static function findNearestValue<T>(self: Array<T>, targetScore: Float, scoreElement: T -> Float): Option<T>
        return if(self.length == 0) None else Some(self.toScoredArray(x -> Math.abs(scoreElement(x) - targetScore)).scoreSort()[0].item);

    public inline static function findNearestValues<T>(self: Array<T>, targetScore: Float, scoreElement: T -> Float): Array<T>
        return if(self.length == 0) {
            [];
        } else {
            final arr = self.toScoredArray(x -> Math.abs(scoreElement(x) - targetScore)).scoreSort();
            final minScore = arr[0].score;
            return [for(x in arr) {
                if(x.score > minScore)
                    break;
                x.item;
            }];
        }

    public inline static function create<T>(length: Int, cons: () -> T): Array<T>
        return [for(_ in 0...length) cons()];

    public inline static function createi<T>(length: Int, cons: Int -> T): Array<T>
        return [for(i in 0...length) cons(i)];

    public inline static function maxBy<T>(self: Array<T>, ord: Ord<T>): Option<T>
        return if(self.length == 0) None else Some(reduce(self, self[0], ord.max));

    public inline static function minBy<T>(self: Array<T>, ord: Ord<T>): Option<T>
        return if(self.length == 0) None else Some(reduce(self, self[0], ord.min));

    public inline static function unzip<T1, T2>(self: Array<Tuple2<T1, T2>>): Tuple2<Array<T1>, Array<T2>> {
        final r1 = [];
        final r2 = [];
        for(t in self) {
            r1.push(t._0);
            r2.push(t._1);
        };
        return Tuple2.of(r1, r2);
    }

    public inline static function zip<T1, T2>(array1: Array<T1>, array2: Array<T2>): Array<Tuple2<T1, T2>> {
        final length = Math.min(array1.length, array2.length);
        return [for(i in 0...length) Tuple2.of(array1[i], array2[i])];
    }
}

class IntArrayExt {
    public inline static function sum(self: Array<Int>): Int
        return self.reduce(0, (acc, n) -> acc + n);

    public inline static function average(self: Array<Int>): Float
        return if(self.length == 0)
            0.;
        else
            sum(self) / self.length;

    public inline static function max(self: Array<Int>): Option<Int>
        return self.maxBy(thx.Ints.order);

    public inline static function min(self: Array<Int>): Option<Int>
        return self.minBy(thx.Ints.order);

    public inline static function unique<T>(self: Array<T>): Array<T> {
        final result = [];
        for(x in self) {
            if(result.find((y) -> thx.Dynamics.compare(x, y) == 0) == null)
                result.push(x);
        }
        return result;
    }
}

class FloatArrayExt {
    public inline static function sum(self: Array<Float>): Float
        return self.reduce(0., (n, acc) -> acc + n);

    public inline static function average(self: Array<Float>): Float
        return if(self.length == 0)
            0.;
        else
            sum(self) / self.length;

    public inline static function max(self: Array<Float>): Option<Float>
        return self.maxBy(thx.Floats.order);

    public inline static function min(self: Array<Float>): Option<Float>
        return self.minBy(thx.Floats.order);
}

class GroupByExt {
    public inline static function groupBy<K: {}, V>(self: Array<V>, f: V -> K): Map<K, Array<V>> {
        final map = new Map<K, Array<V>>();
        for(x in self) {
            final key = f(x);
            final value = map.get(key);
            if(value != null) {
                value.push(x);
            } else {
                map.set(key, [x]);
            }
        }
        return map;
    }
}

class GroupByIntExt {
    public inline static function groupBy<V>(self: Array<V>, f: V -> Int): Map<Int, Array<V>> {
        final map = new Map<Int, Array<V>>();
        for(x in self) {
            final key = f(x);
            final value = map.get(key);
            if(value != null) {
                value.push(x);
            } else {
                map.set(key, [x]);
            }
        }
        return map;
    }
}
