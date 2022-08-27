package madlib.extensions;

import haxe.ds.Option;

using madlib.extensions.CdbExt;
using madlib.extensions.OptionExt;

class CdbExt {
    public static function safeGet<T, Kind>(indexId: cdb.Types.IndexId<T, Kind>, kind: Kind): Option<T> {
        final value = indexId.get(kind);
        return value.ofValue();
    }

    #if heaps
    public inline static function getTile(self: cdb.Types.TilePos, ?tile: h2d.Tile): h2d.Tile {
        if(tile == null)
            tile = hxd.Res.load(self.file).toTile();
        final size = self.size;
        return tile.sub(self.x * size, self.y * size, size, size);
    }

    public inline static function getTileId(self: cdb.Types.TilePos, tile: h2d.Tile): Int
        return Util.coordId(self.x, self.y, Math.floor(tile.width / self.size));

    public inline static function toBitmap(self: cdb.Types.TilePos): h2d.Bitmap
        return new h2d.Bitmap(self.getTile());
    #end
}
