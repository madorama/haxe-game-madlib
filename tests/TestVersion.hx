package tests;

import haxe.ds.Either;
import madlib.Version;
import utest.Assert;

using madlib.extensions.ArrayExt;

@:noCompletion
class TestVersion extends utest.Test {
    function specValidVersion() {
        Version.isValid("1.0.0");
        Version.isValid("1.0.0-foo");
        Version.isValid("1.0.0-foo-bar");
        !Version.isValid("1.0.0--");
        !Version.isValid("1.0");
        !Version.isValid("1.0.");
        !Version.isValid("1.");
        !Version.isValid("1");
        !Version.isValid("-1");
    }

    function testVersionOf() {
        Assert.same(Right(new Version(1, 0, 0)), Version.of("1.0.0"));
        Assert.same(Right(new Version(0, 0, 1, ["foo"])), Version.of("0.0.1-foo"));
        Assert.same(Right(new Version(0, 0, 1, ["foo", "bar"])), Version.of("0.0.1-foo-bar"));
        Assert.same(Left(Invalid("0.0.")), Version.of("0.0."));
        Assert.same(Left(Invalid("0.0.1--")), Version.of("0.0.1--"));
    }

    function specCompatible() {
        final v = new Version(1, 1, 1, ["foo"]);
        v.isCompatible(new Version(1, 1, 1));
        v.isCompatible(new Version(1, 0, 2));
        !v.isCompatible(new Version(2, 0, 0));
        !v.isCompatible(new Version(0, 1, 1, ["foo"]));
        !v.isCompatible(new Version(0, 1, 1));
    }

    function specNextVersion() {
        switch Version.of("1.10.2-foobar") {
            case Left(_):
            case Right(version):
                version.nextMajor() == new Version(2, 0, 0);
                version.nextMinor() == new Version(1, 11, 0);
                version.nextPatch() == new Version(1, 10, 3);
                version.nextPatch(true) == new Version(1, 10, 3, ["foobar"]);
        }
    }

    function specCompare() {
        final v = new Version(1, 1, 1, ["foo"]);
        v.compare(v) == 0;
        v.compare(new Version(1, 1, 1, ["foo", "bar"])) == -1;
        v.compare(new Version(1, 1, 2)) == -10;
        v.compare(new Version(1, 2, 1)) == -100;
        v.compare(new Version(2, 0, 0)) == -1000;
        v.compare(new Version(1, 1, 1, ["foo"])) == 0;
        v.compare(new Version(1, 1, 1)) == 1;
        v.compare(new Version(1, 1, 0)) == 10;
        v.compare(new Version(1, 0, 1)) == 100;
        v.compare(new Version(0, 0, 1)) == 1000;
    }

    function specToString() {
        new Version(1, 0, 0).toString() == "1.0.0";
        new Version(2, 1, 0, ["foo"]).toString() == "2.1.0-foo";
        new Version(0, 0, 0, ["foo", "bar"]).toString() == "0.0.0-foo-bar";
    }
}
