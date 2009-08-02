package org.openscales.fx.control
{
	
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.events.ItemClickEvent;
	
	import org.openscales.component.control.Drawing;
	import org.openscales.core.Map;
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.control.MousePosition;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.handler.mouse.ClickHandler;
	import org.openscales.core.handler.mouse.DragHandler;
	import org.openscales.core.handler.mouse.WheelHandler;
	import org.openscales.core.layer.VectorLayer;
	import org.openscales.core.layer.ogc.WMSC;
	import org.openscales.core.layer.params.ogc.WMSParams;
	
	
	public class DrawTest extends TestCase
	{
		
		private var _map:Map = null;
		private var _draw:Drawing = null;
		
		private var nbPoints:Number = 0;
		private var nbPaths:Number = 0;
		private var nbPoly:Number = 0;
		private var nbLineString:Number = 0;
		private var nbOther:Number = 0;
		
		public function DrawTest(methodName:String=null)
		{
			super(methodName);
			
			var wmslayer1:WMSC = new WMSC( "OpenLayers WMS",
                    						"http://labs.metacarta.com/wms-c/Basic.py",
                    						new WMSParams("basic"),
                    						true);
			
			
			//Map init
			_map = new Map(1270,773);
			
			_map.proxy="http://openscales.org/proxy.php?url=";
			
			_map.addHandler(new DragHandler());
			_map.addHandler(new WheelHandler());
			_map.addHandler(new ClickHandler());
			_map.addControl(new MousePosition());
			
			_map.addLayer(wmslayer1);
			
			
			_map.zoomToExtent(new Bounds(-124.731422,24.955967,-66.969849,49.371735));
			
			
			_draw = new Drawing();
			_draw.initialize();
			_draw.map = _map;
			_map.addControl(_draw);
			
		}
		
		public function testDraw():void {
						
			// We added 2 controls
			assertEquals("Number of controls assert",2,_map.controls.length);
			
			//We added 3 handlers
			assertEquals("Number of handlers assert",3,_map.handlers.length);
			
			//The map has 3 layers : WMS-C base layer and Vector sketching layer
			assertEquals("Number of layers assert",2,_map.layers.length);
			
			//We check if the last layer is up
			var sketchLayer:VectorLayer = _map.layers[1];
			assertEquals("Sketch layer presence","Sketch",sketchLayer.name);
			
			//Before sketching, we check that we have none features on sketch layer
			assertEquals("Sketch layer has 0 features", 0, sketchLayer.features.length);
			
			//We simulate click on toggle bar to draw points
			_draw.tgBar.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEM_CLICK, false, false, null, 0, _draw.tgBar, _draw.btnPoint));
			
			//We check if DrawPointHandler is activated and Path & Polygon handlers deactivated
			assertTrue("DrawPointHandler activated", _draw.pointHandler.active);
			assertFalse("Path Handler deactivated", _draw.pathHandler.active);
			assertFalse("Polygon Handler deactivated", _draw.polygonHandler.active);
			
			//We draw 3 points on map
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 434, 306, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 400, 310, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 250, 136, null, false, false, false, false, 0));
			
			//We select the path tool
			_draw.tgBar.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEM_CLICK, false, false, null, 1, _draw.tgBar, _draw.btnPath));
			_map.addEventListener(MouseEvent.DOUBLE_CLICK, _draw.pathHandler.mouseDblClick);
			
			//We check if path handler is activated and point & polygon handlers deactivated
			assertTrue("Path handler activated", _draw.pathHandler.active);
			assertFalse("Point Handler deactivated", _draw.pointHandler.active);
			assertFalse("Polygon Handler deactivated", _draw.polygonHandler.active);
			
			//We draw 2 paths (we finalize the first but not the second)
			//1st one
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 434, 306, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 400, 310, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 250, 136, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, false, false, 240, 125, null, false, false, false, false, 0));
			
			//2nd one
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 256, 300, null, false, false, false, false, 0));
			countGeometries();			
			assertEquals("Check nb of points", 4, nbPoints);
			assertEquals("Check nb of paths", 1, nbPaths);
			assertEquals("Check nb of line string", 0, nbLineString);
			assertEquals("Check nb of other geometries", 0, nbOther);
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 136, 125, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 148, 222, null, false, false, false, false, 0));
			
			countGeometries();			
			assertEquals("Check nb of points", 3, nbPoints);
			assertEquals("Check nb of paths", 1, nbPaths);
			assertEquals("Check nb of poly", 2, nbLineString);
			assertEquals("Check nb of other geometries", 0, nbOther);
						
						
			_map.removeEventListener(MouseEvent.DOUBLE_CLICK, _draw.pathHandler.mouseDblClick);
			
			//We select the polygon tool
			_draw.tgBar.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEM_CLICK, false, false, null, 2, _draw.tgBar, _draw.btnPolygon));
			_map.addEventListener(MouseEvent.DOUBLE_CLICK, _draw.polygonHandler.mouseDblClick);
			
			//We check if polygon handler is activated and point & path handlers deactivated
			assertTrue("Polygon handler activated", _draw.polygonHandler.active);
			assertFalse("Point Handler deactivated", _draw.pointHandler.active);
			assertFalse("Path Handler deactivated", _draw.pathHandler.active);
			
			//We draw a polygon (we finalize it)
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 263, 255, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 248, 123, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 206, 198, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 314, 194, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, false, false, 203, 211, null, false, false, false, false, 0));
			
			_map.removeEventListener(MouseEvent.DOUBLE_CLICK, _draw.polygonHandler.mouseDblClick);
			
			//We check if the 3 points, 2 paths and polygon are correctly drawn in sketch layer
			assertEquals("Number of features after sketch",6, sketchLayer.features.length);
			
			
			countGeometries();		
			assertEquals("Check nb of points", 3, nbPoints);
			assertEquals("Check nb of paths", 2, nbPaths);
			assertEquals("Check nb of poly", 1, nbPoly);
			assertEquals("Check nb of other geometries", 0, nbOther);
			
			
			//We'll test now delete functions
			//We draw 2 points and delete one of them
			_draw.tgBar.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEM_CLICK, false, false, null, 0, _draw.tgBar, _draw.btnPoint));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 400, 310, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 250, 136, null, false, false, false, false, 0));
			_draw.btnDeleteLast.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false,false,1,1,_draw.btnDeleteLast));
			countGeometries();		
			assertEquals("Check nb of points", 4, nbPoints);
			assertEquals("Check nb of paths", 2, nbPaths);
			assertEquals("Check nb of poly", 1, nbPoly);
			assertEquals("Check nb of other geometries", 0, nbLineString);
			assertEquals("Check nb of other geometries", 0, nbOther);
			
			//We draw a 4 points path, delete last and finalize it
			_draw.tgBar.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEM_CLICK, false, false, null, 1, _draw.tgBar, _draw.btnPath));
			_map.addEventListener(MouseEvent.DOUBLE_CLICK, _draw.pathHandler.mouseDblClick);
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 263, 255, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 248, 123, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 206, 198, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 314, 194, null, false, false, false, false, 0));
			_draw.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false,false,1,1,_draw.btnDeleteLast));
			countGeometries();		
			assertEquals("Check nb of points", 4, nbPoints);
			assertEquals("Check nb of paths", 2, nbPaths);
			assertEquals("Check nb of poly", 1, nbPoly);
			assertEquals("Check nb of other geometries", 3, nbLineString);
			assertEquals("Check nb of other geometries", 0, nbOther);
			_map.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, false, false, 203, 211, null, false, false, false, false, 0));
			countGeometries();		
			assertEquals("Check nb of points", 4, nbPoints);
			assertEquals("Check nb of paths", 3, nbPaths);
			assertEquals("Check nb of poly", 1, nbPoly);
			assertEquals("Check nb of other geometries", 0, nbLineString);
			assertEquals("Check nb of other geometries", 0, nbOther);
			_map.removeEventListener(MouseEvent.DOUBLE_CLICK, _draw.pathHandler.mouseDblClick);


			//We draw a polygon and delete it as well as last path
			_draw.tgBar.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEM_CLICK, false, false, null, 2, _draw.tgBar, _draw.btnPolygon));
			_map.addEventListener(MouseEvent.DOUBLE_CLICK, _draw.polygonHandler.mouseDblClick);
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 263, 255, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 248, 123, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 206, 198, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, false, 314, 194, null, false, false, false, false, 0));
			_map.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, false, false, 203, 211, null, false, false, false, false, 0));
			_draw.btnDeleteLast.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false,false,1,1,_draw.btnDeleteLast));
			_draw.btnDeleteLast.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false,false,1,1,_draw.btnDeleteLast));

			countGeometries();		
			assertEquals("Check nb of points", 4, nbPoints);
			assertEquals("Check nb of paths", 2, nbPaths);
			assertEquals("Check nb of poly", 1, nbPoly);
			assertEquals("Check nb of other geometries", 0, nbLineString);
			assertEquals("Check nb of other geometries", 0, nbOther);
			
			//Finally, we delete all features
			_draw.btnDeleteAll.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false,false,1,1,_draw.btnDeleteAll));
			assertEquals("All features are deleted", 0, sketchLayer.features.length);
					
		}
		
		private function countGeometries():void {
			nbPoints = 0;
			nbPaths = 0;
			nbPoly = 0;
			nbLineString = 0;
			nbOther = 0;
			
			
			for each (var feature:Feature in _draw.drawLayer.features) {
				if (getQualifiedClassName(feature.geometry) == "org.openscales.core.geometry::Point") {
					nbPoints ++;
				}
				else if (getQualifiedClassName(feature.geometry) == "org.openscales.core.geometry::MultiLineString") {
					nbPaths ++;
				}
				else if (getQualifiedClassName(feature.geometry) == "org.openscales.core.geometry::Polygon") {
					nbPoly ++;
				}
				else if (getQualifiedClassName(feature.geometry) == "org.openscales.core.geometry::LineString") {
					nbLineString ++;
				}
				else {
					nbOther ++;
				}
			}
		}
		
	}
}
