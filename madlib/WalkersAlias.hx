package madlib;

import haxe.exceptions.ArgumentException;

using madlib.extensions.ArrayExt;
using madlib.extensions.MapExt;

@:structInit
@:allow(madlib.WalkersAlias)
class WalkersAliasItem<T> {
    final item: T;
    final weight: Float;

    public inline function new(item: T, weight: Float) {
        this.item = item;
        this.weight = weight;
    }
}

class WalkersAlias<T> {
    var normalized: Array<Float> = [];
    var aliases: Array<Int> = [];
    var items: Array<WalkersAliasItem<T>>;

    public function new(items: Array<WalkersAliasItem<T>>) {
        if(items.length == 0)
            throw new ArgumentException("items must be an array with at least one element.");
        this.items = items.copy();
        refresh();
    }

    public function refresh() {
        final length = items.length;

        normalized = [];
        normalized.resize(length);
        aliases.resize(length);
        final indexes: Array<Int> = aliases.copy();

        var totalWeight = 0.0;
        for(i => item in items) {
            final w = item.weight;
            if(w > 0.0) totalWeight += w;
        }

        final normalizeRatio = length / totalWeight;
        var left = 0;
        var right = length - 1;
        for(i => item in items) {
            aliases[i] = i;
            final w = item.weight;
            normalized[i] = if(item.weight > 0.0) item.weight * normalizeRatio else 0;
            if(normalized[i] < 1.0)
                indexes[left++] = i;
            else
                indexes[right--] = i;
        }

        while(left > 0 && right < length - 1) {
            final leftIndex = indexes[left - 1];
            final rightIndex = indexes[right + 1];
            aliases[leftIndex] = rightIndex;
            normalized[rightIndex] -= 1 - normalized[leftIndex];
            if(normalized[rightIndex] < 1) {
                indexes[left - 1] = rightIndex;
                right += 1;
            } else {
                left -= 1;
            }
        }
    }

    inline function randomIndex(?randomGenerator: Random): Int {
        final gen = randomGenerator ?? Random.gen;
        final random = gen.uniform(0, items.length);
        final index = Std.int(random);
        return if(normalized[index] <= random - index) {
            aliases[index];
        } else {
            index;
        }
    }

    @:nullSafety(Off)
    public inline function random(?randomGenerator: Random): T {
        final index = randomIndex(randomGenerator);
        return items[index].item;
    }
}
