package madlib;

import haxe.EnumFlags;
import haxe.PosInfos;
import hx.strings.ansi.Ansi;

class Debug {
    @:nullSafety(Off)
    public inline static function log<T>(value: T, ?pos: PosInfos): T {
        #if debug
        trace('${Ansi.fg(WHITE)}[Log] ${value}${Ansi.fg(DEFAULT)}');
        #end
        return value;
    }

    @:nullSafety(Off)
    public inline static function warn<T>(value: T, ?pos: PosInfos): T {
        #if debug
        trace('${Ansi.fg(YELLOW)}[Warn] ${value}${Ansi.fg(DEFAULT)}');
        #end
        return value;
    }

    @:nullSafety(Off)
    public inline static function error<T>(value: T, ?pos: PosInfos): T {
        trace('${Ansi.fg(RED)}[Error] ${value}${Ansi.fg(DEFAULT)}');
        return value;
    }

    @:nullSafety(Off)
    public inline static function errorLog(value: T, ?pos: PosInfos): T {
        #if hl
        hl.UI.dialog("Error log", '${value}\n${pos.fileName}:${pos.lineNumber}', EnumFlags.ofInt(2));
        #else
        error(value, pos);
        #end
        return value;
    }
}
