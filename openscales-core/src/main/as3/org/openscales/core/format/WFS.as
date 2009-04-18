package org.openscales.core.format
{
	import flash.xml.XMLNode;
	
	import org.openscales.core.feature.State;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.layer.WFS;
	
	public class WFS extends GML
	{
		
		private var _layer:org.openscales.core.layer.WFS = null;
    	
    	public function WFS(options:Object, layer:org.openscales.core.layer.WFS):void {
    		super(options);
	        this.layer = layer;
	        if (this.layer.featureNS) {
	            this._featureNS = this.layer.featureNS;
	        }    
	        if (layer.geometryColumn) {
	            this._geometryName = layer.geometryColumn;
	        }
	        var wfsLayer:org.openscales.core.layer.WFS = this.layer as org.openscales.core.layer.WFS;
	        if (wfsLayer.typename) {
	            this._featureName = wfsLayer.typename;
	        }
    	}
    	
    	override public function write(features:Object):Object {
    		var transaction:XML = new XML("<?xml version=\"1.0\" encoding=\"UTF-8\"?><" + this._wfsprefix + ":Transaction service=\"WFS\" version=\"1.0.0\" outputFormat=\"GML2\" xmlns:" + this._wfsprefix + "=\"" + this._wfsns + "\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.0.0/WFS-basic.xsd\"></" + this._wfsprefix + ":Transaction>");
	        for (var i:int=0; i < features.length; i++) {
	            switch (features[i].state) {
	                case State.INSERT:
	                    transaction.appendChild(this.insert(features[i]));
	                    break;
	                case State.UPDATE:
	                    transaction.appendChild(this.update(features[i]));
	                    break;
	                case State.DELETE:
	                    transaction.appendChild(this.remove(features[i]));
	                    break;
	            }
	        }
	        return transaction;
    	}
    	
    	override public function createFeatureXML(feature:Vector):XML {
	        var geometryNode:XML = this.buildGeometryNode(feature.geometry);
	        var geomContainer:XML = new XML("<" + this._featurePrefix + ":" + this._geometryName + " xmlns:" + this._featurePrefix + "=\"" + this._featureNS + "\"></" + this._featurePrefix + ":" + this._geometryName + ">");
	        geomContainer.appendChild(geometryNode);
	        var featureContainer:XML = new XML("<" + this._featurePrefix + ":" + this._featureName + " xmlns:" + this._featurePrefix + "=\"" + this._featureNS + "\"></" + this._featurePrefix + ":" + this._featureName + ">");
	        featureContainer.appendChild(geomContainer);
	        for(var attr:String in feature.attributes) {
	            var attrText:XMLNode = new XMLNode(2, feature.attributes[attr]); 
	            var nodename:String = attr;
	            if (attr.search(":") != -1) {
	                nodename = attr.split(":")[1];
	            }    
	            var attrContainer:XML = new XML("<" + this._featurePrefix + ":" + nodename + " xmlns:" + this._featurePrefix + "=\"" + this._featureNS + "\"></" + this._featurePrefix + ":" + nodename + ">");
	            attrContainer.appendChild(attrText);
	            featureContainer.appendChild(attrContainer);
	        }    
	        return featureContainer;
    	}
    	
    	public function insert(feature:Vector):XML {
	        var insertNode:XML = new XML("<" + this._wfsprefix + ":Insert xmlns:" + this._wfsprefix + "=\"" + this._wfsns + "\"></" + this._wfsprefix + ":Insert>");
	        insertNode.appendChild(this.createFeatureXML(feature));
	        return insertNode;
    	}
    	
    	public function update(feature:Vector):XMLNode {
	        if (!feature.id) { trace("Can't update a feature for which there is no FID."); }
	        var updateNode:XMLNode = new XMLNode(1, "wfs:Update");
	        updateNode.attributes.typeName = this._layerName;
	
	        var propertyNode:XMLNode = new XMLNode(1, "wfs:Property");
	        var nameNode:XMLNode = new XMLNode(1, "wfs:Name");
	        
	        var txtNode:XMLNode = new XMLNode(3, this._geometryName);
	        nameNode.appendChild(txtNode);
	        propertyNode.appendChild(nameNode);
	        
	        var valueNode:XMLNode = new XMLNode(1, "wfs:Value");
	        valueNode.appendChild(this.buildGeometryNode(feature.geometry) as XMLNode);
	        
	        propertyNode.appendChild(valueNode);
	        updateNode.appendChild(propertyNode);
	        
	        var filterNode:XMLNode = new XMLNode(1, "ogc:Filter");
	        var filterIdNode:XMLNode = new XMLNode(1, "ogc:FeatureId");
	        filterIdNode.attributes.fid = feature.id;
	        filterNode.appendChild(filterIdNode);
	        updateNode.appendChild(filterNode);
	
	        return updateNode;
    	}
    	
    	public function remove(feature:Vector):XMLNode {
	        if (!feature.attributes.fid) { 
	            trace("Can't update a feature for which there is no FID."); 
	            return null; 
	        }
	        var deleteNode:XMLNode = new XMLNode(1, "wfs:Delete");
	        deleteNode.attributes.typeName = this._layerName;
	
	        var filterNode:XMLNode = new XMLNode(1, "ogc:Filter");
	        var filterIdNode:XMLNode = new XMLNode(1, "ogc:FeatureId");
	        filterIdNode.attributes.fid = feature.attributes.fid;
	        filterNode.appendChild(filterIdNode);
	        deleteNode.appendChild(filterNode);
	
	        return deleteNode;
    	}
    	
    	public function destroy():void {
        	this.layer = null;
    	}
    	
    	public function get layer():org.openscales.core.layer.WFS {
			return this._layer;
		}
		
		public function set layer(value:org.openscales.core.layer.WFS):void {
			this._layer = value;
		}
		
	}
}