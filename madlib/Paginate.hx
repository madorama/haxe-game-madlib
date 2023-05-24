package madlib;

import haxe.ds.Option;

using madlib.extensions.OptionExt;

@:structInit
class Paginate<T> {
    @:isVar public var items(default, set): Array<T> = [];

    inline function set_items(v: Array<T>): Array<T> {
        items = v;
        refresh();
        return v;
    }

    @:isVar public var onePageItemCount(default, set): Int = 0;

    inline function set_onePageItemCount(v: Int): Int {
        onePageItemCount = v;
        refresh();
        return onePageItemCount;
    }

    public var currentPageItems(default, null): Array<T> = [];

    public var currentPage(default, null): Int = 0;

    public var maxPage(default, null) = 0;

    public var pageLoop = true;

    public function new(items: Array<T>, onePageItemCount: Int = 10) {
        this.items = items;
        this.onePageItemCount = onePageItemCount;
        refresh();
    }

    inline function refresh() {
        currentPageItems = getPageItems(currentPage);
        maxPage = if(onePageItemCount == 0) 0 else Math.max(0, Math.floor((items.length - 1) / onePageItemCount));
    }

    public inline function changePage(n: Int) {
        currentPage = if(pageLoop) Math.posMod(n, maxPage + 1) else Math.clamp(n, 0, maxPage);
        refresh();
    }

    public inline function pageAt(n: Int) {
        changePage(currentPage + n);
    }

    public inline function nextPage() {
        pageAt(1);
    }

    public inline function prevPage() {
        pageAt(-1);
    }

    public inline function getPageItems(page: Int): Array<T> {
        final start = onePageItemCount * page;
        return items.slice(start, start + onePageItemCount);
    }

    public inline function calcInPageIndex(index: Int)
        return index % onePageItemCount + currentPage * onePageItemCount;

    public inline function getItemInPage(index: Int): Option<T> {
        final item = currentPageItems[index];
        return item.ofValue();
    }
}
