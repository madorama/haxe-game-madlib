package madlib.extensions;

enum WeekDay {
    Sunday;
    Monday;
    Tuesday;
    Wednesday;
    Thursday;
    Fridy;
    Saturday;
}

class DateExt {
    public inline static function getUTCWeekDay(date: Date): WeekDay
        return Type.createEnumIndex(WeekDay, date.getUTCDay());

    public inline static function getWeekDay(date: Date): WeekDay
        return Type.createEnumIndex(WeekDay, date.getDay());
}
