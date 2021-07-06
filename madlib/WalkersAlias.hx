package madlib;

import haxe.ds.Option;
import haxe.exceptions.ArgumentException;

using madlib.extensions.ArrayExt;
using thx.Maps;

typedef WalkersAliasItem<T> = {
    final item: T;
    final weight: Float;
}

class WalkersAlias<T> {
    var normalized: Array<Float> = [];
    var aliases: Array<Int> = [];
    var items: Array<T> = [];
    var weights: Array<Float> = [];

    public function new(items: Array<WalkersAliasItem<T>>) {
        if(items.length == 0)
            throw new ArgumentException("items must be an array with at least one element.");
        for(x in items) {
            this.items.push(x.item);
            weights.push(if(x.weight > 0.0) x.weight else 0);
        }
        refresh();
    }

    inline function getWeight(index: Int): Option<Float>
        return weights.getOption(index);

    public function refresh() {
        final length = weights.length;
        normalized = [];
        aliases = [];
        final indexes = [];

        var totalWeight = 0.0;
        for(i in 0...length) {
            switch getWeight(i) {
                case Some(weight):
                    if(weight > 0.0)
                        totalWeight += weight;
                case None:
            }
        }

        final normalizeRatio = length / totalWeight;
        var left = -1;
        var right = length;
        for(i in 0...length) {
            aliases[i] = i;
            switch getWeight(i) {
                case None:
                case Some(weight):
                    var weight = weight;
                    weight *= if(weight > 0.0) normalizeRatio else 0;
                    normalized[i] = weight;

                    if(weight < 1.0)
                        indexes[++left] = i;
                    else
                        indexes[--right] = i;
            }
        }

        if(left >= 0 && right < length) {
            left = 0;
            while(left < length && right < length) {
                final leftIndex = indexes[left];
                final rightIndex = indexes[right];
                aliases[leftIndex] = rightIndex;
                final leftWeight = normalized[leftIndex];
                final rightWeight = normalized[rightIndex] + leftWeight - 1.0;
                normalized[rightIndex] = rightWeight;
                if(rightWeight < 1.0)
                    right += 1;
                left += 1;
            }
        }
    }

    public function randomIndex(?randomGenerator: Random): Int {
        var length = weights.length;

        if(length == 0)
            return -1;

        final gen = if(randomGenerator == null) Random.gen else randomGenerator;
        final random = gen.random() * length;
        var index = Math.floor(random);
        final isOutbounds = index >= length;
        final weight = if(isOutbounds) 1.0 else random - index;
        if(isOutbounds)
            index = length - 1;

        if(normalized[index] <= weight)
            index = aliases[index];

        return index;
    }

    @:nullSafety(Off)
    public inline function random(?randomGenerator: Random): T {
        final index = randomIndex(randomGenerator);
        return items[index];
    }
}
