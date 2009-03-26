package org.openscales.core.format
{
	import flash.xml.XMLNode;
	
	import org.openscales.core.feature.State;
	import org.openscales.core.feature.Vector;
	import org.openscales.core.layer.Layer;
	import org.openscales.core.layer.WFS;
	
	public class WFS extends GML
	{
		
		private var layer:Layer = null;
    	
    	public function WFS(options:Object, layer:Layer):void {
    		super(options);
	        this.layer = layer;
	        if (this.layer.featureNS) {
	            this.featureNS = this.layer.featureNS;
	        }    
	        if (this.layer.options.geometry_column) {
	            this.geometryName = this.layer.options.geometry_column;
	        }
	        var wfsLayer:org.openscales.core.layer.WFS = this.layer as org.openscales.core.layer.WFS;
	        if (wfsLayer.typename) {
	            this.featureName = wfsLayer.typename;
	        }
    	}
    	
    	override public function write(features:Object):Object {
    		var transaction:XML = new XML("<?xml version=\"1.0\" encoding=\"UTF-8\"?><" + this.wfsprefix + ":Transaction service=\"WFS\" version=\"1.0.0\" outputFormat=\"GML2\" xmlns:" + this.wfsprefix + "=\"" + this.wfsns + "\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.0.0/WFS-basic.xsd\"></" + this.wfsprefix + ":Transaction>");
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
	        var geomContainer:XML = new XML("<" + this.featurePrefix + ":" + this.geometryName + " xmlns:" + this.featurePrefix + "=\"" + this.featureNS + "\"></" + this.featurePrefix + ":" + this.geometryName + ">");
	        geomContainer.appendChild(geometryNode);
	        var featureContainer:XML = new XML("<" + this.featurePrefix + ":" + this.featureName + " xmlns:" + this.featurePrefix + "=\"" + this.featureNS + "\"></" + this.featurePrefix + ":" + this.featureName + ">");
	        featureContainer.appendChild(geomContainer);
	        for(var attr:String in feature.attributes) {
	            var attrText:XMLNode = new XMLNode(2, feature.attributes[attr]); 
	            var nodename:String = attr;
	            if (attr.search(":") != -1) {
	                nodename = attr.split(":")[1];
	            }    
	            var attrContainer:XML = new XML("<" + this.featurePrefix + ":" + nodename + " xmlns:" + this.featurePrefix + "=\"" + this.featureNS + "\"></" + this.featurePrefix + ":" + nodename + ">");
	            attrContainer.appendChild(attrText);
	            featureContainer.appendChild(attrContainer);
	        }    
	        return featureContainer;
    	}
    	
    	public function insert(feature:Vector):XML {
	        var insertNode:XML = new XML("<" + this.wfsprefix + ":Insert xmlns:" + this.wfsprefix + "=\"" + this.wfsns + "\"></" + this.wfsprefix + ":Insert>");
	        insertNode.appendChild(this.createFeatureXML(feature));
	        return insertNode;
    	}
    	
    	public function update(feature:Vector):XMLNode {
	        if (!feature.fid) { trace("Can't update a feature for which there is no FID."); }
	        var updateNode:XMLNode = new XMLNode(1, "wfs:Update");
	        updateNode.attributes.typeName = this.layerName;
	
	        var propertyNode:XMLNode = new XMLNode(1, "wfs:Property");
	        var nameNode:XMLNode = new XMLNode(1, "wfs:Name");
	        
	        var txtNode:XMLNode = new XMLNode(3, this.geometryName);
	        nameNode.appendChild(txtNode);
	        propertyNode.appendChild(nameNode);
	        
	        var valueNode:XMLNode = new XMLNode(1, "wfs:Value");
	        valueNode.appendChild(this.buildGeometryNode(feature.geometry) as XMLNode);
	        
	        propertyNode.appendChild(valueNode);
	        updateNode.appendChild(propertyNode);
	        
	        var filterNode:XMLNode = new XMLNode(1, "ogc:Filter");
	        var filterIdNode:XMLNode = new XMLNode(1, "ogc:FeatureId");
	        filterIdNode.attributes.fid = feature.fid;
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
	        deleteNode.attributes.typeName = this.layerName;
	
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
		
	}
}