package madlib;

import haxe.ds.Either;

using madlib.extensions.MapExt;

enum AchievementError<T> {
    NotExistingId(id: T);
}

@:structInit
typedef AchievementData = {
    name: String,
    achieved: Bool,
    description: String,
}

class Achievement<T> {
    var data: Map<T, AchievementData> = [];
    var callback: T -> Void = id -> {};

    public function new(data: Map<T, AchievementData>) {
        this.data = data;
    }

    public inline function onAchieved(f: T -> Void) {
        callback = f;
    }

    public inline function obtainAchievement(id: T) {
        if(!data.exists(id))
            return;
        data[id].achieved = true;
        callback(id);
    }

    public inline function retrieveName(id: T): Either<AchievementError<T>, String> {
        return if(!data.exists(id))
            Left(NotExistingId(id));
        else
            Right(data[id].name);
    }

    public inline function retrieveDescription(id: T): Either<AchievementError<T>, String>
        return if(!data.exists(id))
            Left(NotExistingId(id));
        else
            Right(data[id].description);
}
