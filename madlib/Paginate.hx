package madlib;

@:structInit
class Paginate<T> {
    var items: Array<T>;

    @:isVar public var onePageItemCount(default, set): Int;

    inline function set_onePageItemCount(v: Int): Int {
        onePageItemCount = v;
        reflesh();
        return onePageItemCount;
    }

    public var currentPageItems(default, null): Array<T> = [];

    public var currentPage(default, null): Int = 0;

    public var maxPage(default, null) = 0;

    public var pageLoop = true;

    public function new(items: Array<T>, onePageItemCount: Int = 10) {
        this.items = items;
        this.onePageItemCount = onePageItemCount;
        reflesh();
    }

    inline function reflesh() {
        currentPageItems = getPageItems(currentPage);
        maxPage = if(onePageItemCount == 0) 0 else Math.max(0, Math.floor((items.length - 1) / onePageItemCount));
    }

    inline function pageAt(n: Int) {
        final nextPage = currentPage + n;
        currentPage = if(pageLoop) Math.posMod(nextPage, maxPage + 1) else Math.clamp(nextPage, 0, maxPage);
        reflesh();
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
}
