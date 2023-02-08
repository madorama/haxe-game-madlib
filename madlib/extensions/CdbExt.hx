package madlib.extensions;

import haxe.ds.Option;

using madlib.extensions.CdbExt;
using madlib.extensions.OptionExt;

class CdbExt {
    public static function safeGet<T, Kind>(indexId: cdb.Types.IndexId<T, Kind>, kind: Kind): Option<T> {
        final value = indexId.get(kind);
        return value.ofValue();
    }

    public static function coerceGet<T, Kind>(indexId: cdb.Types.IndexId<T, Kind>, kind: Kind): T {
        @:nullSafety(Off)
        return indexId.get(kind);
    }

    #if heaps
    public inline static function getTile(self: cdb.Types.TilePos, ?tile: h2d.Tile): h2d.Tile {
        if(tile == null)
            tile = hxd.Res.load(self.file).toTile();
        final size = self.size;
        final w = if(self.width != null) self.width else 1;
        final h = if(self.height != null) self.height else 1;
        return tile.sub(self.x * size, self.y * size, w * self.size, h * self.size);
    }

    public inline static function getTileId(self: cdb.Types.TilePos, tile: h2d.Tile): Int
        return Util.coordId(self.x, self.y, Math.floor(tile.width / self.size));

    public inline static function toBitmap(self: cdb.Types.TilePos): h2d.Bitmap
        return new h2d.Bitmap(self.getTile());
    #end
}
