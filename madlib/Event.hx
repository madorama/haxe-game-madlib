package madlib;

import polygonal.ds.Sll;

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

class Events<T> {
    public var disposed(default, null): Bool;

    final events: Sll<Event<T>>;

    public function new(?events: Array<Event<T>>) {
        this.events = new Sll(events);
    }

    public function add(event: Event<T>) {
        events.append(event);
    }

    public function invoke(value: T) {
        if(disposed) return;
        for(e in events)
            e.invoke(value);
    }

    public function dispose() {
        if(disposed) return;
        var node = events.head;
        while(node != null) {
            final nextNode = node.next;
            node.val.dispose();
            node.free();
            node = nextNode;
        }
        disposed = true;
    }

    public function remove(e: Event<T>) {
        events.remove(e);
    }
}
