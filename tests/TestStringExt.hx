package tests;

import utest.Assert;

using madlib.extensions.StringExt;

class TestStringExt extends utest.Test {
    function testToArray() {
        Assert.same("Hello".toArray(), ["H", "e", "l", "l", "o"]);
    }

    function testMap() {
        Assert.same("abcde".map(x -> x + 1), "bcdef");
    }

    function specIsLower() {
        "a".isLower() == true;
        "z".isLower() == true;
    }

    function specIsUpper() {
        "A".isUpper() == true;
        "Z".isUpper() == true;
    }

    function specIsLetter() {
        "a".isLetter() == true;
        "z".isLetter() == true;
        "A".isLetter() == true;
        "Z".isLetter() == true;
    }

    function specIsSpace() {
        " ".isSpace() == true;
        "\t".isSpace() == true;
        "\n".isSpace() == true;
        "\r".isSpace() == true;
    }

    function specIsNum() {
        "0".isNum() == true;
        "9".isNum() == true;
    }

    function testLines() {
        Assert.same("Lorem ipsum\ndolor".lines(), ["Lorem ipsum", "dolor"]);
    }

    function testWords() {
        Assert.same("Lorem ipsum\ndolor".words(), ["Lorem", "ipsum", "dolor"]);
    }

    function testUnwords() {
        Assert.same(["Lorem", "ipsum", "dolor"].unwords(), "Lorem ipsum dolor");
    }

    function testAny() {
        final s = "Hello";
        Assert.isTrue(s.any(x -> x == "l"));
        Assert.isFalse(s.any(x -> x == "x"));
    }

    function testAll() {
        final s = "aaaaa";
        Assert.isTrue(s.all(x -> x == "a"));
        Assert.isFalse(s.all(x -> x == "x"));
    }

    function testCapitalize() {
        Assert.same("The qUicK BRoWn fOx jumps OVeR THE lAZy dOG".capitalize(), "The quick brown fox jumps over the lazy dog");
    }

    function testContains() {
        Assert.isTrue("Hello, World!".contains("World"));
    }

    function testRepeat() {
        Assert.same("x".repeat(10), "xxxxxxxxxx");
    }

    function testLpad() {
        Assert.same("1101".lpad("0", 8), "00001101");
        Assert.same("10101101".lpad("0", 8), "10101101");
        Assert.same("1110101101".lpad("0", 8), "1110101101");
    }

    function testRpad() {
        Assert.same("0100".rpad("1", 8), "01001111");
        Assert.same("01001101".rpad("1", 8), "01001101");
        Assert.same("0100110101".rpad("1", 8), "0100110101");
    }

    function testReverse() {
        Assert.same("Hello, World!".reverse(), "!dlroW ,olleH");
        Assert.same("".reverse(), "");
        Assert.same("a".reverse(), "a");
        Assert.same("ab".reverse(), "ba");
    }
}
