package tests;

import utest.Assert;

using madlib.extensions.StringExt;

class TestStringExt extends utest.Test {
    function testToArray() {
        Assert.same(["H", "e", "l", "l", "o"], "Hello".toArray());
    }

    function testMap() {
        Assert.same("bcdef", "abcde".map(x -> x + 1));
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
        Assert.same(["Lorem ipsum", "dolor"], "Lorem ipsum\ndolor".lines());
    }

    function testWords() {
        Assert.same(["Lorem", "ipsum", "dolor"], "Lorem ipsum\ndolor".words());
    }

    function testUnwords() {
        Assert.same("Lorem ipsum dolor", ["Lorem", "ipsum", "dolor"].unwords());
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
        Assert.same("The quick brown fox jumps over the lazy dog", "The qUicK BRoWn fOx jumps OVeR THE lAZy dOG".capitalize());
    }

    function testContains() {
        Assert.isTrue("Hello, World!".contains("World"));
    }

    function testRepeat() {
        Assert.same("xxxxxxxxxx", "x".repeat(10));
    }

    function testLpad() {
        Assert.same("00001101", "1101".lpad("0", 8));
        Assert.same("10101101", "10101101".lpad("0", 8));
        Assert.same("1110101101", "1110101101".lpad("0", 8));
    }

    function testRpad() {
        Assert.same("01001111", "0100".rpad("1", 8));
        Assert.same("01001101", "01001101".rpad("1", 8));
        Assert.same("0100110101", "0100110101".rpad("1", 8));
    }

    function testReverse() {
        Assert.same("", "".reverse());
        Assert.same("a", "a".reverse());
        Assert.same("!dlroW ,olleH", "Hello, World!".reverse());
    }
}
