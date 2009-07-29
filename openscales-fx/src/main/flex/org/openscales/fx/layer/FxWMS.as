package org.openscales.fx.layer
{
  import org.openscales.core.layer.ogc.WMS;
  import org.openscales.core.layer.params.ogc.WMSParams;
  import org.openscales.proj4as.ProjProjection;

  public class FxWMS extends FxGrid
  {
    public function FxWMS()
    {
      super();
    }

    override public function init():void {
      this._layer = new WMS("", "");
    }

    public function set layers(value:String):void {
        if(this.layer != null)
          ((this.layer as WMS).request.params as WMSParams).layers = value;
      }

    public function set styles(value:String):void {
        if(this.layer != null)
          ((this.layer as WMS).request.params as WMSParams).styles = value;
      }

      public function set format(value:String):void {
        if(this.layer != null)
          ((this.layer as WMS).request.params as WMSParams).format = value;
      }

      public function set srs(value:String):void {
        if(this.layer != null) {
          ((this.layer as WMS).request.params as WMSParams).srs = value;
		  this.layer.projection = new ProjProjection(value);
		}
      }

      public function set transparent(value:Boolean):void {
        if(this.layer != null)
          ((this.layer as WMS).request.params as WMSParams).transparent = value;
      }
      
      public function set bgcolor(value:String):void {
      	if(this.layer != null)
      	  ((this.layer as WMS).request.params as WMSParams).bgcolor = value;
      }

      public function set tiled(value:Boolean):void {
        if(this.layer != null)
          ((this.layer as WMS).request.params as WMSParams).tiled = value;
      }

  }
}
