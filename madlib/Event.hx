package madlib;

import polygonal.ds.Sll;

@:structInit
class Event<T> {
    var disposed(default, null): Bool;
    var onDisposeAction: Null<() -> Void> = null;
    final action: T -> Void;
    final id: Int;

    public inline function new(action: T -> Void, id: Int) {
        this.action = action;
        this.id = id;
    }

    public inline function invoke(value: T) {
        if(disposed) return;
        action(value);
    }

    public inline function dispose() {
        if(disposed) return;
        disposed = true;
        if(onDisposeAction != null) onDisposeAction();
    }

    public inline function onDispose(?callback: () -> Void) {
        onDisposeAction = callback;
    }
}

@:access(madlib.Event)
class Events<T> {
    public var disposed(default, null): Bool;

    final events: Map<Int, Event<T>> = [];

    var id = 0;

    public function new(?events: Array<Event<T>>) {}

    public inline function add(action: T -> Void): Event<T> {
        final e = new Event(action, id++);
        events.set(e.id, e);
        return e;
    }

    public inline function invoke(value: T) {
        if(disposed) return;
        for(e in events)
            e.invoke(value);
    }

    public function dispose() {
        if(disposed) return;
        for(e in events) {
            e.dispose();
        }
        disposed = true;
    }

    public inline function remove(e: Event<T>) {
        events.remove(e.id);
        e.dispose();
    }
}
