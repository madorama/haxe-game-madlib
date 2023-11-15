package madlib;

enum abstract AnsiTextAttribute(Int) {
    final Reset = 0;
    final Bold = 1;
    final IntensityFaint = 2;
    final Italic = 3;
    final Underline = 4;
    final BlinkSlow = 5;
    final BlinkFast = 6;
    final Negative = 7;
    final Hidden = 8;
    final Strikethrough = 9;
}

enum AnsiColor {
    Black;
    Red;
    Green;
    Yellow;
    Blue;
    Magenta;
    Cyan;
    White;
    Default;
    Rgb(r: Int, g: Int, b: Int);
}

enum AnsiCursor {
    Home;
    MoveTo(line: Int, column: Int);
    Up(n: Int);
    Down(n: Int);
    Left(n: Int);
    Right(n: Int);
    SavePos;
    RestorePos;
}

class Ansi {
    public inline static final ESC = "\x1B[";

    public inline static function attr(attr: AnsiTextAttribute): String
        return '${ESC}${attr}m';

    inline static function ansiColorToAttr(color: AnsiColor)
        return switch color {
            case Black: "0";
            case Red: "1";
            case Green: "2";
            case Yellow: "3";
            case Blue: "4";
            case Magenta: "5";
            case Cyan: "6";
            case White: "7";
            case Default: "9";
            case Rgb(r, g, b): '8;2;${r};${g};${b}';
        }

    public inline static function fg(color: AnsiColor): String
        return '${ESC}3${ansiColorToAttr(color)}m';

    public inline static function bg(color: AnsiColor): String
        return '${ESC}4${ansiColorToAttr(color)}m';

    public inline static function cursor(cmd: AnsiCursor): String
        return switch cmd {
            case Home: '${ESC}H';
            case MoveTo(line, column): '${ESC}${line};${column}H';
            case Up(n): '${ESC}${n}A';
            case Down(n): '${ESC}${n}B';
            case Left(n): '${ESC}${n}D';
            case Right(n): '${ESC}${n}C';
            case SavePos: '${ESC}s';
            case RestorePos: '${ESC}u';
        }

    public inline static function clear(): String
        return '${ESC}2J';

    public inline static function clearLine(): String
        return '${ESC}K';
}
