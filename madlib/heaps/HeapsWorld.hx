package madlib.heaps;

import aseprite.Aseprite;
import h2d.Layers;
import h2d.TileGroup;
import haxe.ds.Option;
import ldtk.Layer_AutoLayer;
import madlib.GameScene;
import madlib.geom.Bounds;

using madlib.extensions.ArrayExt;
using madlib.extensions.LdtkExt;

private typedef RenderableLayer = {
    function render(?target: h2d.TileGroup): Null<h2d.Object>;

    public var identifier(default, never): String;
    public var opacity(default, never): Float;
}

typedef WorldData<LevelType : ldtk.Level> = {
    var levels: Array<LevelType>;
    public function getLevel(?uid: Int, ?id: String): Null<LevelType>;
}

@:structInit
class TileGroupData {
    public final name: String;
    public final tileGroup: TileGroup;

    public function new(name: String, tileGroup: TileGroup) {
        this.name = name;
        this.tileGroup = tileGroup;
    }
}

@:structInit
class NeighbourData<LevelType : ldtk.Level> {
    public final bounds: Bounds;
    public final level: LevelType;
    public final dir: ldtk.Level.NeighbourDir;

    public function new(bounds: Bounds, level: LevelType, dir: ldtk.Level.NeighbourDir) {
        this.bounds = bounds;
        this.level = level;
        this.dir = dir;
    }
}

@:generic
class HeapsWorld<LevelType : ldtk.Level, T : haxe.Constraints.Constructible<Null<String> -> Void> & WorldData<LevelType>> {
    public var scene(default, null): Option<GameScene> = None;

    public var levels(default, null) = new T(null);

    public var currentLevel(default, null): LevelType;
    public var bounds(default, null) = new Bounds(0, 0, 0, 0);

    final neighbours: Array<NeighbourData<LevelType>> = [];

    public final entityLayers = new Layers();
    public final layer: Array<Array<TileGroupData>> = [];

    var animFrame = 0;
    var animFrameCount = 0.0;
    var animDuration = 6.;

    public function new(?scene: GameScene) {
        layer = [];
        currentLevel = levels.levels[0];
        if(scene != null)
            attachScene(scene);
    }

    public inline function attachScene(scene: GameScene) {
        this.scene = Some(scene);
    }

    public function load(uid: Int) {
        final level = levels.getLevel(uid);
        if(level == null)
            throw new thx.Error('undefined level: ${uid}');

        currentLevel = level;
        bounds.set(0, 0, currentLevel.pxWid, currentLevel.pxHei);
        makeNeighbours();
    }

    function makeNeighbours() {
        neighbours.resize(0);
        for(n in currentLevel.neighbours) {
            switch levels.getLevel(n.levelIid) {
                case final l if(l != null):
                    neighbours.push({
                        bounds: new Bounds(l.worldX - currentLevel.worldX, l.worldY - currentLevel.worldY, l.pxWid, l.pxHei),
                        dir: n.dir,
                        level: l
                    });
            }
        }
    }

    public inline function findNeighbourWithBounds(bounds: Bounds): Option<NeighbourData<LevelType>>
        return neighbours.findOption(n -> n.bounds.overlaps(bounds));

    public inline function findNeighboursWithDirection(dir: ldtk.Level.NeighbourDir): Array<NeighbourData<LevelType>>
        return neighbours.filter(n -> n.dir == dir);

    public inline function findNeighbour(x: Float, y: Float): Option<NeighbourData<LevelType>>
        return neighbours.findOption(n -> n.bounds.contains(new h2d.col.Point(x, y)));

    public inline function isValid(x: Float, y: Float)
        return x >= 0 && y >= 0 && x < currentLevel.pxWid && y < currentLevel.pxHei;

    public inline function getTileGroup(name: String, layerId: Int): TileGroup {
        var data = layer[layerId];
        if(data == null) {
            data = [];
            layer[layerId] = data;
        }

        return switch data.find(d -> d.name == name) {
            case null:
                final tg = new TileGroup();
                data.push({ name: name, tileGroup: tg });
                tg;
            case final d: d.tileGroup;
        }
    }

    public function render(layer: RenderableLayer, x: Float, y: Float, isClear: Bool = false, layerId: Int) {
        final tg = getTileGroup(layer.identifier, layerId);
        if(isClear)
            tg.clear();

        layer.render(tg);
        tg.alpha = layer.opacity;
        tg.setPosition(x, y);
    }

    public function renderAnim(frames: Array<AsepriteFrame>, layer: Layer_AutoLayer, x: Float, y: Float, isClear: Bool = false, layerId: Int) {
        final tg = getTileGroup(layer.identifier, layerId);
        if(isClear)
            tg.clear();

        for(autoTile in layer.autoTiles) {
            final rx = autoTile.renderX + layer.pxTotalOffsetX;
            final ry = autoTile.renderY + layer.pxTotalOffsetY;
            final renderTile = frames[animFrame % frames.length].tile;
            if(autoTile.isFlipX())
                renderTile.flipX();
            if(autoTile.isFlipY())
                renderTile.flipY();
            if(autoTile.isFlipXY())
                renderTile.setCenterRatio(0, 0);
            tg.add(rx, ry, renderTile);
        }
        tg.alpha = layer.opacity;
        tg.setPosition(x, y);
    }

    public function renderStatics() {}

    public function clearLayers() {
        layer.resize(0);
    }

    public function update(dt: Float) {
        animFrameCount += 1 * dt;
        if(animFrameCount > animDuration) {
            animFrame++;
            animFrameCount -= animDuration;
        }
    }

    public function draw(drawLayers: Layers) {
        for(i in 0...layer.length) {
            final data = layer[i];
            if(data == null)
                continue;
            for(x in data)
                drawLayers.add(x.tileGroup, i);
        }
    }

    public function collisionGridSize(): Int
        return 1;

    function getCollider(cx: Int, cy: Int): Option<Entity>
        return None;
}
