package madlib;

@:tink class Property<T> {
    var internalValue: T;

    public var value(get, set): T;

    @:signal private var trigger: T;
    var equalityComparer: T -> T -> Int = thx.Dynamics.compare;

    public inline function setEqualityComparer(comparer: T -> T -> Int) {
        equalityComparer = comparer;
    }

    function get_value(): T
        return internalValue;

    function set_value(value: T): T {
        return if(equalityComparer(internalValue, value) != 0) {
            _trigger.trigger(value);
            internalValue = value;
        } else {
            value;
        }
    }

    public inline function new(value: T) {
        internalValue = value;
    }

    public inline function onValueChange(action: T -> Void) {
        _trigger.clear();
        trigger.handle(action);
    }

    public inline function setSilently(value: T) {
        internalValue = value;
    }
}
