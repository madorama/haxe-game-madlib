package madlib;

import haxe.EnumFlags;
import haxe.PosInfos;
import madlib.Ansi;

class Debug {
    public inline static function log<T>(value: T, ?pos: PosInfos): T {
        #if debug
        trace('${Ansi.fg(White)}[Log] ${value}${Ansi.fg(Default)}', pos);
        #end
        return value;
    }

    public inline static function warn<T>(value: T, ?pos: PosInfos): T {
        #if debug
        trace('${Ansi.fg(Yellow)}[Warn] ${value}${Ansi.fg(Default)}', pos);
        #end
        return value;
    }

    public inline static function error<T>(value: T, ?pos: PosInfos): T {
        trace('${Ansi.fg(Red)}[Error] ${value}${Ansi.fg(Default)}', pos);
        return value;
    }

    public inline static function errorLog<T>(value: T, ?pos: PosInfos): T {
        #if hl
        hl.UI.dialog("Error log", '${value}\n${pos.fileName}:${pos.lineNumber}', EnumFlags.ofInt(2));
        #else
        error(value, pos);
        #end
        return value;
    }
}
