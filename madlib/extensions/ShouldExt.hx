package madlib.extensions;

#if test
import buddy.Should;
import haxe.PosInfos;
import madlib.Option;
import utest.Assert;

class ShouldExt {}

@:nullSafety(Off)
@:keep class ShouldBool extends Should<Null<Bool>> {
    public inline static function should(b: Bool)
        return new ShouldBool(b);

    public function new(value: Bool, inverse = false) {
        super(value, inverse);
    }

    public var not(get, never): ShouldBool;

    inline function get_not()
        return new ShouldBool(value, !inverse);

    public function isTrue(?p: PosInfos) {
        test(value, p, 'Expected true, was ${quote(value)}', 'Expected false, was ${quote(value)}');
    }

    public function isFalse(?p: PosInfos) {
        test(!value, p, 'Expected false, was ${quote(value)}', 'Expected true, was ${quote(value)}');
    }
}

@:nullSafety(Off)
@:keep class ShouldOption<T> extends Should<Option<T>> {
    public inline static function should<T>(v: Option<T>)
        return new ShouldOption(v);

    public function new(value: Option<T>, inverse = false) {
        super(value, inverse);
    }

    public var not(get, never): ShouldOption<T>;

    inline function get_not()
        return new ShouldOption(value, !inverse);

    public function contains(expected: T, ?p: PosInfos) {
        switch(value) {
            case Some(value):
                if(!inverse)
                    Assert.same(expected, value, true, 'Expected Some(${quote(expected)}), was Some(${quote(value)})');
                else
                    AssertExt.notSame(expected, value, true, 'Expected not Some(${quote(expected)}), was Some(${quote(value)})');
            case None:
                fail('Expected None, was ${quote(value)}', 'Expected None, was ${quote(value)}', p);
        }
    }

    public function isNone() {
        be(None);
    }
}

class ShouldEnumExt {
    public inline static function same(self: ShouldEnum, expected: EnumValue) {
        if(@:privateAccess !self.inverse)
            @:privateAccess Assert.same(expected, self.value, true, 'Expected ${self.quote(expected)}, was ${self.quote(self.value)}');
        else
            @:privateAccess AssertExt.notSame(expected, self.value, true, 'Expected not ${self.quote(expected)}, was ${self.quote(self.value)}');
    }
}

class ShouldIterableExt {
    public inline static function same<T>(self: ShouldIterable<T>, expected: Iterable<T>) {
        if(@:privateAccess !self.inverse)
            @:privateAccess Assert.same(expected, self.value, true, 'Expected ${self.quote(expected)}, was ${self.quote(self.value)}');
        else
            @:privateAccess AssertExt.notSame(expected, self.value, true, 'Expected not ${self.quote(expected)}, was ${self.quote(self.value)}');
    }
}

class ShouldDynamicExt {
    public inline static function same(self: ShouldDynamic, expected: Dynamic) {
        if(@:privateAccess !self.inverse)
            @:privateAccess Assert.same(expected, self.value, true, 'Expected ${self.quote(expected)}, was ${self.quote(self.value)}');
        else
            @:privateAccess AssertExt.notSame(expected, self.value, true, 'Expected not ${self.quote(expected)}, was ${self.quote(self.value)}');
    }
}
#end
