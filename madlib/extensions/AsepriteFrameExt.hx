package madlib.extensions;

import aseprite.AseAnim;
import aseprite.Aseprite.AsepriteFrame;

using madlib.heaps.extensions.TileExt;

class AsepriteFrameExt {
    public inline static function frameToAseAnim(frame: AsepriteFrame): AseAnim
        return new AseAnim([{
            tile: frame.tile.clone(),
            duration: frame.duration,
            index: frame.index,
        }]);

    public inline static function toAseAnim(frames: Array<AsepriteFrame>, loop: Bool = false): AseAnim {
        final frames = frames.map(frame -> {
            tile: frame.tile.clone(),
            duration: frame.duration,
            index: frame.index,
        });
        final anim = new AseAnim(frames);
        anim.loop = loop;
        return anim;
    }
}
