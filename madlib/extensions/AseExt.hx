package madlib.extensions;

import aseprite.AseAnim;
import aseprite.Aseprite;
import h2d.Bitmap;
import haxe.ds.Option;
import madlib.geom.Bounds;

using madlib.extensions.ArrayExt;
using madlib.extensions.IteratorExt;

class AseExt {
    #if heaps
    public inline static function toBitmap(aseprite: Aseprite): Bitmap
        return new Bitmap(aseprite.getFrame(0).tile);
    #end

    public inline static function toAseAnim(aseprite: Aseprite): AseAnim
        return new AseAnim(aseprite.getFrames());

    public inline static function toAseAnimWithSlice(aseprite: Aseprite, sliceName: String, loop: Bool = false): AseAnim {
        final anim = new AseAnim(aseprite.getSlices(sliceName));
        anim.loop = loop;
        return anim;
    }

    public static function getCollisions(ase: Aseprite, sliceName: String, postfixCollision = "_Col", flipX: Bool = false,
            flipY: Bool = false): Array<Bounds> {
        if(!ase.slices.exists(sliceName))
            return [];

        final baseSlice = ase.getSlice(sliceName);
        final baseTile = baseSlice.tile;
        final colName = sliceName + postfixCollision;
        final colNames = ase.slices.keys().filter(k -> k.indexOf(colName) == 0);
        return if(colNames.length == 0) {
            [new Bounds(baseTile.dx, baseTile.dy, baseTile.width, baseTile.height)];
        } else {
            colNames.map(colName -> {
                final colSlice = ase.getSlice(colName);
                final col = colSlice.tile;
                final padLeft = col.x - baseTile.x;
                final padTop = col.y - baseTile.y;
                final padRight = baseTile.width - (padLeft + col.width);
                final padBottom = baseTile.height - (padTop + col.height);

                var x = if(flipX) padRight else padLeft;
                var y = if(flipY) padBottom else padTop;

                new Bounds(x, y, col.width, col.height);
            });
        }
    }

    public static function getCollision(ase: Aseprite, sliceName: String, flipX: Bool = false, flipY: Bool = false): Option<Bounds> {
        if(!ase.slices.exists(sliceName))
            return None;

        final baseSlice = ase.getSlice(sliceName);
        final baseTile = baseSlice.tile;
        final colName = sliceName + "_Col";
        return if(ase.slices.exists(colName)) {
            final colSlice = ase.getSlice(colName);
            final col = colSlice.tile;
            final padLeft = col.x - baseTile.x;
            final padTop = col.y - baseTile.y;
            final padRight = baseTile.width - (padLeft + col.width);
            final padBottom = baseTile.height - (padTop + col.height);

            var x = if(flipX) padRight else padLeft;
            var y = if(flipY) padBottom else padTop;

            Some(new Bounds(x, y, col.width, col.height));
        } else {
            Some(new Bounds(baseTile.dx, baseTile.dy, baseTile.width, baseTile.height));
        }
    }
}
