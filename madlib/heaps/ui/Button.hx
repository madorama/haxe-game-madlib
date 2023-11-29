package madlib.heaps.ui;

import h2d.Drawable;
import h2d.Flow;
import h2d.RenderContext;
import h2d.ScaleGrid;
import h2d.Tile;

class Button extends Entity {
    final wrapFlow = new Flow();
    final scaleGrid: ScaleGrid;

    public final interactive: Interactive;

    public final content = new Flow();

    public var autoResize = true;

    public function new(inContent: h2d.Object, ?tile: Tile) {
        super();

        final gridTile = tile ?? Tile.fromColor(0x404040);
        scaleGrid = new ScaleGrid(gridTile, 0, 0);
        wrapFlow.layout = Stack;
        wrapFlow.addChild(scaleGrid);

        content.padding = 8;
        content.addChild(inContent);

        wrapFlow.addChild(content);
        addChild(wrapFlow);

        wrapFlow.enableInteractive = true;
        interactive = new Interactive(wrapFlow.interactive);
    }

    public function changeTile(tile: Tile) {
        scaleGrid.tile = tile;
    }

    override function sync(ctx: RenderContext) {
        super.sync(ctx);
        width = wrapFlow.outerWidth;
        height = wrapFlow.outerHeight;
        if(autoResize) {
            scaleGrid.width = wrapFlow.outerWidth;
            scaleGrid.height = wrapFlow.outerHeight;
        }
    }
}
