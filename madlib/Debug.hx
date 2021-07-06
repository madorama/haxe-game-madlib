package madlib;

import haxe.EnumFlags;
import haxe.PosInfos;
import hx.strings.ansi.Ansi;

class Debug {
    @:nullSafety(Off)
    public inline static function log(value: Dynamic, ?pos: PosInfos) {
        #if debug
        trace('${Ansi.fg(WHITE)}[Log] ${value}${Ansi.fg(DEFAULT)}');
        #end
    }

    @:nullSafety(Off)
    public inline static function warn(value: Dynamic, ?pos: PosInfos) {
        #if debug
        trace('${Ansi.fg(YELLOW)}[Warn] ${value}${Ansi.fg(DEFAULT)}');
        #end
    }

    @:nullSafety(Off)
    public inline static function error(value: Dynamic, ?pos: PosInfos) {
        trace('${Ansi.fg(RED)}[Error] ${value}${Ansi.fg(DEFAULT)}');
    }

    @:nullSafety(Off)
    public inline static function errorLog(value: Dynamic, ?pos: PosInfos) {
        #if hl
        hl.UI.dialog("Error log", '${value}\n${pos.fileName}:${pos.lineNumber}', EnumFlags.ofInt(2));
        #else
        error(value, pos);
        #end
    }
}
