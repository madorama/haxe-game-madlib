package madlib.extensions;

using StringTools;

class StringExt {
    public inline static function toArray(self: String): Array<String>
        return self.split('');

    public inline static function map(self: String, f: Int -> Int): String {
        var result = "";
        for(i in 0...self.length) {
            final c = self.charCodeAt(i);
            if(c == null) continue;
            result += String.fromCharCode(f(c));
        }
        return result;
    }

    public inline static function isLower(self: String): Bool
        return ~/[a-z]/.match(self.substr(0, 1));

    public inline static function isUpper(self: String): Bool
        return ~/[A-Z]/.match(self.substr(0, 1));

    public inline static function isLetter(self: String): Bool
        return ~/[a-zA-Z]/.match(self.substr(0, 1));

    public inline static function isSpace(self: String): Bool
        return ~/[ \t\r\n]/.match(self.substr(0, 1));

    public inline static function isNum(self: String): Bool
        return ~/[0-9]/.match(self.substr(0, 1));

    public inline static function lines(self: String): Array<String>
        return (~/\r\n|\n\r|\n|\r/g).split(self);

    public inline static function words(self: String): Array<String> {
        final result = [];
        var start = 0;
        var length = 0;
        var i = 0;
        while(i < self.length) {
            if(isSpace(self.charAt(i))) {
                length = i - start;
                result.push(self.substr(start, length));
                start = i + 1;
            }
            i++;
        }
        result.push(self.substr(start, self.length));
        return result;
    }

    public inline static function unwords(self: Array<String>): String
        return self.join(" ");

    public inline static function any(self: String, f: String -> Bool): Bool {
        var result = false;
        for(i in 0...self.length) {
            if(f(self.charAt(i))) {
                result = true;
                break;
            }
        }
        return result;
    }

    public inline static function all(self: String, f: String -> Bool): Bool {
        var result = true;
        for(i in 0...self.length) {
            if(!f(self.charAt(i))) {
                result = false;
                break;
            }
        }
        return result;
    }

    public inline static function capitalize(self: String): String
        return self.substr(0, 1).toUpperCase() + self.substr(1).toLowerCase();

    public inline static function contains(self: String, other: String): Bool
        return self.indexOf(other) >= 0;

    public inline static function repeat(self: String, times: Int): String {
        var result = "";
        for(_ in 0...times)
            result += self;
        return result;
    }

    public inline static function lpad(self: String, char: String, length: Int): String {
        final diff = length - self.length;
        return if(diff > 0) repeat(char, diff) + self else self;
    }

    public inline static function rpad(self: String, char: String, length: Int): String {
        final diff = length - self.length;
        return if(diff > 0) self + repeat(char, diff) else self;
    }

    public static function reverse(self: String): String {
        return if(self == "") "" else {
            var result = "";
            for(i in 0...self.length + 1)
                result += self.charAt(self.length - i);
            result;
        }
    }

    public inline static function compare(x: String, y: String): Int
        return if(x < y) -1 else if(x > y) 1 else 0;

    public inline static function quote(s: String)
        return if(s.indexOf('"') < 0) {
            '"${s}"';
        } else if(s.indexOf("'") < 0) {
            '\'${s}\'';
        } else {
            '"${StringTools.replace(s, '"', '\\"')}"';
        }
}
