package madlib;

import polygonal.ds.Dll;
import polygonal.ds.DllNode;

@:structInit
class Event<T> {
    var disposed(default, null): Bool;
    var onDisposeAction: Null<() -> Void> = null;
    final action: T -> Void;

    public inline function new(action: T -> Void) {
        this.action = action;
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

    final events = new Dll<Event<T>>();

    public function new(?events: Array<Event<T>>) {}

    public inline function add(action: T -> Void): DllNode<Event<T>> {
        final e = new Event(action);
        return events.append(e);
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

    extern overload public inline function remove(node: DllNode<Event<T>>) {
        node.val.dispose();
        node.unlink();
        node.free();
    }

    extern overload public inline function remove(e: Event<T>) {
        e.dispose();
        events.remove(e);
    }

    public inline function clear() {
        var node = events.head;
        while(node != null) {
            final next = node.next;
            remove(node);
            node = next;
        }
    }
}
