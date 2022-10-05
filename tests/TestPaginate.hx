package tests;

import madlib.Paginate;
import madlib.Util;
import madlib.extensions.AssertExt;
import utest.Assert;

@:noCompletion
class TestPaginate extends utest.Test {
    function specLoop() {
        final p = new Paginate(Util.range(0, 8), 3);
        p.currentPage == 0;

        p.nextPage();
        p.currentPage == 1;

        p.nextPage();
        p.currentPage == 2;

        p.nextPage();
        p.currentPage == 0;

        p.prevPage();
        p.currentPage == 2;
    }

    function specNonLoop() {
        final p = new Paginate(Util.range(0, 5), 3);
        p.pageLoop = false;

        p.currentPage == 0;

        p.prevPage();
        p.currentPage == 0;

        p.nextPage();
        p.currentPage == 1;

        p.nextPage();
        p.currentPage == 1;
    }

    function testGetPageItems() {
        final p = new Paginate(Util.range(0, 10), 3);

        Assert.same([3, 4, 5], p.getPageItems(1));
        AssertExt.isEmpty(p.getPageItems(4));
        AssertExt.isEmpty(p.getPageItems(-1));
    }

    function specChangeOnePageItemCount() {
        final p = new Paginate(Util.range(0, 10), 3);

        p.maxPage == 3;

        p.onePageItemCount = 5;
        p.maxPage == 2;
    }

    function testChangeOnePageItemCount() {
        final p = new Paginate(Util.range(0, 10), 3);

        Assert.same([0, 1, 2], p.currentPageItems);

        p.onePageItemCount = 5;
        Assert.same([0, 1, 2, 3, 4], p.currentPageItems);
    }

    function specChangePage() {
        final p = new Paginate(Util.range(0, 10), 3);

        p.currentPage == 0;

        p.changePage(2);
        p.currentPage == 2;

        p.changePage(5);
        p.currentPage == 1;

        p.changePage(-2);
        p.currentPage == 2;
    }

    function testChangePage() {
        final p = new Paginate(Util.range(0, 10), 3);

        Assert.same([0, 1, 2], p.currentPageItems);

        p.changePage(2);
        Assert.same([6, 7, 8], p.currentPageItems);

        p.changePage(5);
        Assert.same([3, 4, 5], p.currentPageItems);

        p.changePage(-2);
        Assert.same([6, 7, 8], p.currentPageItems);
    }

    function specPageAt() {
        final p = new Paginate(Util.range(0, 10), 3);

        p.currentPage == 0;

        p.pageAt(2);
        p.currentPage == 2;

        p.pageAt(2);
        p.currentPage == 0;

        p.pageAt(-2);
        p.currentPage == 2;
    }

    function testPageAt() {
        final p = new Paginate(Util.range(0, 10), 3);

        Assert.same([0, 1, 2], p.currentPageItems);

        p.pageAt(2);
        Assert.same([6, 7, 8], p.currentPageItems);

        p.pageAt(2);
        Assert.same([0, 1, 2], p.currentPageItems);

        p.pageAt(-2);
        Assert.same([6, 7, 8], p.currentPageItems);
    }

    function testSetItems() {
        final p = new Paginate(Util.range(0, 5), 2);
        Assert.same([0, 1], p.currentPageItems);

        p.items = Util.range(5, 5);
        Assert.same([5], p.currentPageItems);
    }
}
