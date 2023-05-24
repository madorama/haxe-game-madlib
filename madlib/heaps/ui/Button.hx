package madlib.heaps.ui;

import h2d.Drawable;
import h2d.Flow;
import h2d.Interactive;
import h2d.RenderContext;
import h2d.ScaleGrid;
import h2d.Tile;
import hxd.Event;

@:tink class Button extends h2d.Drawable {
    final wrapFlow = new Flow();
    final scaleGrid: ScaleGrid;

    public final content = new Flow();

    public var interactive(get, never): Interactive;

    inline function get_interactive(): Interactive
        return wrapFlow.interactive;

    @:signal public var onClick: Event;

    @:signal public var onOver: Event;

    @:signal public var onOut: Event;

    public var autoResize = true;

    public function new(inContent: h2d.Object, ?tile: Tile, ?parent: h2d.Object) {
        super(parent);

        final gridTile = tile ?? Tile.fromColor(0x404040);
        scaleGrid = new ScaleGrid(gridTile, 0, 0);
        wrapFlow.layout = Stack;
        wrapFlow.addChild(scaleGrid);

        content.padding = 8;
        content.addChild(inContent);

        wrapFlow.addChild(content);
        addChild(wrapFlow);

        wrapFlow.enableInteractive = true;
        wrapFlow.interactive.onClick = _onClick.trigger;
        wrapFlow.interactive.onOver = _onOver.trigger;
        wrapFlow.interactive.onOut = _onOut.trigger;
    }

    public function changeTile(tile: Tile) {
        scaleGrid.tile = tile;
    }

    override function sync(ctx: RenderContext) {
        if(autoResize) {
            scaleGrid.width = wrapFlow.outerWidth;
            scaleGrid.height = wrapFlow.outerHeight;
        }
        super.sync(ctx);
    }
}
