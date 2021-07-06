package madlib.extensions;

using madlib.extensions.OptionExt;
using thx.Maps;

class CdbExt {
    public inline static function safeGet<T, Kind>(indexId: cdb.Types.IndexId<T, Kind>, kind: Kind): T {
        final value = @:nullSafety(Off) indexId.get(kind);
        return if(value == null) indexId.all[0] else value;
    }

    public inline static function getTile(self: cdb.Types.TilePos, ?tile: h2d.Tile): h2d.Tile {
        if(tile == null)
            tile = hxd.Res.load(self.file).toTile();
        final size = self.size;
        return tile.sub(self.x * size, self.y * size, size, size);
    }

    public inline static function getTileId(self: cdb.Types.TilePos, tile: h2d.Tile): Int
        return Util.coordId(self.x, self.y, Math.floor(tile.width / self.size));
}
