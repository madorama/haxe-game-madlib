package madlib;

using madlib.extensions.ArrayExt;

typedef DelayTask = {
    var id: String;
    var t: Float;
    var callback: () -> Void;
}

class Delay {
    final tasks: Array<DelayTask> = [];

    public function new() {}

    public inline function exists(id: String): Bool
        return tasks.any(task -> task.id == id);

    public inline function runAll() {
        for(task in tasks)
            task.callback();
        tasks.resize(0);
    }

    public inline function cancelAll() {
        tasks.resize(0);
    }

    public inline function cancel(id: String) {
        var i = 0;
        while(i < tasks.length) {
            if(tasks[i].id == id) {
                tasks.splice(i, 1);
                continue;
            }
            i += 1;
        }
    }

    public inline function add(id: String, frame: Float, callback: () -> Void) {
        tasks.push({ id: id, t: frame, callback: callback });
    }

    public function update(dt: Float) {
        var i = 0;
        while(i < tasks.length) {
            final task = tasks[i];
            task.t -= dt;
            if(task.t <= 0) {
                task.callback();
                if(tasks[i] == null) break;
                tasks.splice(i, 1);
                continue;
            }
            i += 1;
        }
    }
}
