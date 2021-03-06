package madlib;

import haxe.ds.Either;
import parsihax.Parser.*;

using StringTools;
using madlib.extensions.ArrayExt;
using parsihax.Parser;

private enum VersionData {
    VersionData(major: Int, minor: Int, patch: Int, tags: Array<String>);
}

enum VersionError {
    Invalid(str: String);
}

abstract Version(VersionData) from VersionData to VersionData {
    public var major(get, never): Int;

    inline function get_major(): Int
        return switch this {
            case VersionData(major, _, _, _):
                major;
        }

    public var minor(get, never): Int;

    inline function get_minor(): Int
        return switch this {
            case VersionData(_, minor, _, _):
                minor;
        }

    public var patch(get, never): Int;

    inline function get_patch(): Int
        return switch this {
            case VersionData(_, _, patch, _):
                patch;
        }

    public var tags(get, never): Array<String>;

    inline function get_tags(): Array<String>
        return switch this {
            case VersionData(_, _, _, tags):
                tags;
        }

    static final dot = ".".string();
    static final hyphen = "-".string();
    static final number = ~/0|[1-9]\d*/.regexp().map(n -> {
        final n = Std.parseInt(n);
        if(n == null) {
            0;
        } else {
            (n: Int);
        }
    });

    static final numsParser = [
        number.skip(dot),
        number.skip(dot),
        number,
    ].seq().map(data -> {
        major: data[0],
        minor: data[1],
        patch: data[2]
    });

    static final tagsParser = hyphen.then(~/[a-zA-Z0-9]+/.regexp()).many1();

    static final versionParser = Parser.alt([
        numsParser.flatMap(nums -> tagsParser.skip(eof()).map(tags -> VersionData(nums.major, nums.minor, nums.patch, tags))),
        numsParser.skip(eof()).map(nums -> VersionData(nums.major, nums.minor, nums.patch, [])),
    ]);

    public function new(major: Int = 0, minor: Int = 0, patch: Int = 0, ?tags: Array<String>) {
        if(major < 0)
            throw('$major is an invalid major level');
        if(minor < 0)
            throw('$minor is an invalid minor level');
        if(patch < 0)
            throw('$patch is an invalid patch level');

        this = VersionData(major, minor, patch, if(tags == null) [] else tags);
    }

    public inline static function of(str: String): Either<VersionError, Version> {
        final result = versionParser.apply(str.trim());
        return if(!result.status) Left(Invalid(str)) else Right(result.value);
    }

    public inline static function isValid(str: String): Bool
        return versionParser.apply(str.trim()).status;

    public function compare(other: Version): Int {
        if((other: VersionData) == this)
            return 0;
        if(major > other.major)
            return 1000;
        if(major < other.major)
            return -1000;
        if(minor > other.minor)
            return 100;
        if(minor < other.minor)
            return -100;
        if(patch > other.patch)
            return 10;
        if(patch < other.patch)
            return -10;

        final tags1 = tags.sorted(thx.Strings.compare);
        final tags2 = other.tags.sorted(thx.Strings.compare);

        return tags1.compare(tags2);
    }

    public inline function equals(other: Version): Bool
        return compare(other) == 0;

    public inline function isCompatible(other: Version): Bool
        return major == other.major;

    @:op(A > B) inline function gt(other: Version): Bool
        return compare(other) > 0;

    @:op(A < B) inline function lt(other: Version): Bool
        return compare(other) < 0;

    @:op(A >= B) inline function gteq(other: Version): Bool
        return compare(other) <= 0;

    @:op(A <= B) inline function lteq(other: Version): Bool
        return compare(other) <= 0;

    @:op(A == B) inline function eq(other: Version): Bool
        return compare(other) == 0;

    @:op(A != B) inline function neq(other: Version): Bool
        return compare(other) != 0;

    public inline function nextMajor(keepTags = false): Version
        return VersionData(major + 1, 0, 0, if(keepTags) tags else []);

    public inline function nextMinor(keepTags = false): Version
        return VersionData(major, minor + 1, 0, if(keepTags) tags else []);

    public inline function nextPatch(keepTags = false): Version
        return VersionData(major, minor, patch + 1, if(keepTags) tags else []);

    public inline function toString(): String {
        final tagString = if(tags.length == 0) "" else "-" + tags.join("-");
        return '$major.$minor.$patch$tagString';
    }
}
