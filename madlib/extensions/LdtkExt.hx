package madlib.extensions;

import ldtk.Layer_AutoLayer;
import ldtk.Layer_IntGrid;
import ldtk.Layer_Tiles;

using madlib.extensions.ArrayExt;
using madlib.extensions.LdtkExt;
using madlib.extensions.NullExt;

class LdtkExt {
    public inline static function getEnumValue<T>(self: Layer_IntGrid, cx: Int, cy: Int, t: Enum<T>): Option<T>
        return self.safeGetName(cx, cy).map(name -> Type.createEnum(t, name, []));

    public inline static function safeGetName(self: Layer_IntGrid, cx: Int, cy: Int): Option<String>
        return @:nullSafety(Off) self.getName(cx, cy).toOption();

    public inline static function safeGetInt(self: Layer_IntGrid, cx: Int, cy: Int): Option<Int>
        return @:nullSafety(Off) self.getInt(cx, cy).toOption();

    public inline static function getAutotile(self: Layer_AutoLayer, cx: Int, cy: Int): Option<AutoTile> {
        final gridSize = self.gridSize;
        return self.autoTiles.findOption(tile -> {
            final tcx = Math.floor(tile.renderX / gridSize);
            final tcy = Math.floor(tile.renderY / gridSize);
            return cx == tcx && cy == tcy;
        });
    }

    public inline static function isFlip(self: AutoTile): Bool
        return self.flips > 0;

    public inline static function isFlipX(self: AutoTile): Bool
        return (self.flips ^ 1) == 0;

    public inline static function isFlipY(self: AutoTile): Bool
        return (self.flips ^ 2) == 0;

    public inline static function isFlipXY(self: AutoTile): Bool
        return self.flips == 3;

    public inline static function getAutotileFromTiles(self: Layer_Tiles, x: Int, y: Int, stackId: Int): Option<AutoTile> {
        final tile = @:nullSafety(Off) self.getTileStackAt(x, y)[stackId];
        return if(tile == null) {
            None;
        } else {
            final gridSize = self.gridSize;
            Some({
                renderX: x * gridSize,
                renderY: y * gridSize,
                flips: tile.flipBits,
                tileId: tile.tileId,
                coordId: 0,
                ruleId: 0,
                alpha: self.opacity,
            });
        }
    }

    public inline static function eachiWithName(self: Layer_IntGrid, f: Int -> Int -> String -> Void) {
        for(g in new GridIterator(self.cWid, self.cHei)) {
            self.safeGetName(g.x, g.y).each(s -> f(g.x, g.y, s));
        }
    }

    public inline static function eachi(self: Layer_IntGrid, f: Int -> Int -> Int -> Void) {
        for(g in new GridIterator(self.cWid, self.cHei)) {
            self.safeGetInt(g.x, g.y).each(n -> f(g.x, g.y, n));
        }
    }
}
