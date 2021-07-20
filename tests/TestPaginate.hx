package tests;

import madlib.Paginate;
import madlib.Util;
import madlib.extensions.AssertExt;
import utest.Assert;

@:noCompletion
class TestPaginate extends utest.Test {
    function testPageAt() {
        final p = new Paginate(Util.range(0, 20), 8);
        Assert.same(p.currentPage, 0);
        Assert.same(p.currentPageItems, [0, 1, 2, 3, 4, 5, 6, 7]);

        p.nextPage();
        Assert.same(p.currentPage, 1);
        Assert.same(p.currentPageItems, [8, 9, 10, 11, 12, 13, 14, 15]);

        p.nextPage();
        Assert.same(p.currentPage, 2);
        Assert.same(p.currentPageItems, [16, 17, 18, 19, 20]);
    }

    function testLoop() {
        final p = new Paginate(Util.range(0, 8), 5);
        Assert.same(p.currentPage, 0);
        Assert.same(p.currentPageItems, [0, 1, 2, 3, 4]);

        p.nextPage();
        Assert.same(p.currentPage, 1);
        Assert.same(p.currentPageItems, [5, 6, 7, 8]);

        p.nextPage();
        Assert.same(p.currentPage, 0);
        Assert.same(p.currentPageItems, [0, 1, 2, 3, 4]);

        p.prevPage();
        Assert.same(p.currentPage, 1);
        Assert.same(p.currentPageItems, [5, 6, 7, 8]);
    }

    function testNonLoop() {
        final p = new Paginate(Util.range(0, 5), 3);
        p.pageLoop = false;

        Assert.same(p.currentPage, 0);
        Assert.same(p.currentPageItems, [0, 1, 2]);

        p.prevPage();
        Assert.same(p.currentPage, 0);
        Assert.same(p.currentPageItems, [0, 1, 2]);

        p.nextPage();
        Assert.same(p.currentPage, 1);
        Assert.same(p.currentPageItems, [3, 4, 5]);

        p.nextPage();
        Assert.same(p.currentPage, 1);
        Assert.same(p.currentPageItems, [3, 4, 5]);
    }

    function testGetPageItems() {
        final p = new Paginate(Util.range(0, 10), 3);

        Assert.same(p.getPageItems(1), [3, 4, 5]);
        Assert.same(p.getPageItems(4), []);
        Assert.same(p.getPageItems(-1), []);
    }

    function testChangeOnePageItemCount() {
        final p = new Paginate(Util.range(0, 10), 3);

        Assert.same(p.currentPageItems, [0, 1, 2]);

        p.onePageItemCount = 5;
        Assert.same(p.currentPageItems, [0, 1, 2, 3, 4]);
    }

    function testGetMaxPage() {
        final p = new Paginate(Util.range(0, 10), 3);
        Assert.same(p.maxPage, 3);

        p.onePageItemCount = 5;
        Assert.same(p.maxPage, 2);
    }
}
