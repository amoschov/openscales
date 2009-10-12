package org.openscales.core.layer
{
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Size;
	import org.openscales.core.tile.ImageTile;
	

	public class ImageLayer extends Layer
	{
    
    private var _url:String = "";
    private var _bounds:Bounds;
    private var _size:Size = null;
    private var _tile:ImageTile;
    private var _aspectRatio:Number = 0;
    private var _options:Object;
    private var _tileSize:Size;

    /**
     * Constructor: OpenLayers.Layer.Image
     * Create a new image layer
     *
     * Parameters:
     * name - {String} A name for the layer.
     * _url - {String} Relative or absolute path to the image
     * bounds - {<OpenLayers.Bounds>} The bounds represented by the image
     * size - {<OpenLayers.Size>} The size (in pixels) of the image
     * options - {Object} Hashtable of extra options to tag onto the layer
     */
    public function ImageLayer(name:String, _url:String, bounds:Bounds, size:Size, options:Object) {
        this._url = _url;
        this._bounds = bounds;
        this.maxExtent = bounds;
        this._size = size;
        this._options = options;
        super(name,true,true,null,null,null);

        this._aspectRatio = (this._bounds.height / this._size.h) /
                           (this._bounds.width / this._size.w);
    }

    /**
     * Method: destroy
     * Destroy this layer
     */
     override public function destroy(setNewBaseLayer:Boolean = true):void {
        if (this._tile) {
           /*  this.removeTileMonitoringHooks(this.tile); */
            this._tile.destroy();
            this._tile = null;
        }
        super.destroy(setNewBaseLayer);
    } 
    
    /**
     * Method: clone
     * Create a clone of this layer
     *
     * Paramters:
     * obj - {Object} An optional layer (is this ever used?)
     *
     * Returns:
     * {<OpenLayers.Layer.Image>} An exact copy of this layer
     */
     public function clone(obj):ImageLayer {
        
        if(obj == null) {
            obj = new ImageLayer(this.name,
                                               this._url,
                                               this._bounds,
                                               this._size,
                                               this._options);
        }   

        // copy/set any non-init, non-simple values here

         return obj;
    }    
    
    /**
     * APIMethod: setMap
     * 
     * Parameters:
     * map - {<OpenLayers.Map>}
     */
    override public function set map(value:Map):void {
        /**
         * If nothing to do with resolutions has been set, assume a single
         * resolution determined by ratio*bounds/size - if an image has a
         * pixel aspect ratio different than one (as calculated above), the
         * image will be stretched in one dimension only.
         */
         if(value !=null)
         {
         	super.map = value;
	        if( this._options.maxResolution == null ) {
	            this._options.maxResolution = this._aspectRatio *
	                                         this._bounds.width /
	                                         this._size.w;
	                                         
	        }
         }
    } 

    /** 
     * Method: moveTo
     * Create the tile for the image or resize it for the new resolution
     * 
     * Parameters:
     * bounds - {<OpenLayers.Bounds>}
     * zoomChanged - {Boolean}
     * dragging - {Boolean}
     */
    override public function moveTo(bounds:Bounds, zoomChanged:Boolean, dragging:Boolean = false,resizing:Boolean=false):void {
         super.moveTo(bounds,zoomChanged,dragging,resizing); 

        var firstRendering = (this._tile == null);

        if(zoomChanged || firstRendering) {

            //determine new tile size
            this.setTileSize();

            //determine new position (upper left corner of new bounds)
            var ul = new LonLat(this._bounds.left, this._bounds.top);
            var ulPx = this.map.getLayerPxFromLonLat(ul);

            if(firstRendering) {
                //create the new tile
                this._tile = new ImageTile(this, ulPx, this._bounds, 
                                                      null, this._tileSize);
            } else {
                //just resize the tile and set it's new position
                this._tile.size = this._tileSize.clone();
                this._tile.position = ulPx.clone();
            }
        	this.map.zoomToMaxExtent();
            this._tile.draw();
        }
    }

    /**
     * Set the tile size based on the map size.
     */
    public function setTileSize():void {
        var tileWidth = this._bounds.width / this.map.resolution;
        var tileHeight = this._bounds.height / this.map.resolution;
        this._tileSize = new Size(tileWidth, tileHeight);
    } 
    
    /**
     * APIMethod: set_url
     * 
     * Parameters:
     * new_url - {String}
     */
    public function set url(newUrl):void {
        this._url = newUrl;
        this._tile.draw();
    }

    /** 
     * APIMethod: get_url
     * The _url we return is always the same (the image itself never changes)
     *     so we can ignore the bounds parameter (it will always be the same, 
     *     anyways) 
     * 
     * Parameters:
     * bounds - {<OpenLayers.Bounds>}
     */
    override public function getURL(bounds:Bounds):String {
        return this._url;
    }
	}
}