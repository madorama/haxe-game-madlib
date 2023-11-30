package madlib;

import madlib.Event.Events;
import madlib.extensions.DynamicExt;
import polygonal.ds.DllNode;

class Property<T> {
    var internalValue: T;

    public var value(get, set): T;

    public final onValueChange = new Events<T>();

    var equalityComparer: T -> T -> Int = DynamicExt.compare;

    public inline function setEqualityComparer(comparer: T -> T -> Int) {
        equalityComparer = comparer;
    }

    function get_value(): T
        return internalValue;

    function set_value(value: T): T {
        return if(equalityComparer(internalValue, value) != 0) {
            events.invoke(value);
            internalValue = value;
        } else {
            value;
        }
    }

    public inline function new(value: T) {
        internalValue = value;
    }

    public inline function setSilently(value: T) {
        internalValue = value;
    }

    public inline function forceNotify() {
        onValueChange.invoke(value);
    }
}
