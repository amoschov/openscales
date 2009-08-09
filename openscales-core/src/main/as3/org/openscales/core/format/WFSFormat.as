package org.openscales.core.format
{
	import flash.xml.XMLNode;

	import org.openscales.core.Trace;
	import org.openscales.core.feature.State;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.layer.ogc.WFS;
	import org.openscales.core.feature.VectorFeature;

	/**
	 * WFS writer extending GML format.
	 * Useful to WFS-T functionality.
	 */
	public class WFSFormat extends GMLFormat
	{

		private var _layer:WFS = null;

		/**
		 * WFSFormat constructor
		 *
		 * @param layer
		 */
		public function WFSFormat(layer:WFS) {

			this.layer = layer;
			if (this.layer.featureNS) {
				this._featureNS = this.layer.featureNS;
			}    
			if (layer.geometryColumn) {
				this._geometryName = layer.geometryColumn;
			}
			var wfsLayer:WFS = this.layer as WFS;
			if (wfsLayer.typename) {
				this._featureName = wfsLayer.typename;
			}
		}

		/**
		 * Takes a feature list, and generates a WFS-T Transaction
		 *
		 * @param features
		 */
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

		/**
		 * Create an XML feature
		 *
		 * @param feature A vectorfeature
		 */
		override public function createFeatureXML(feature:VectorFeature):XML {
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

		/**
		 * Takes a feature, and generates a WFS-T Transaction "Insert"
		 *
		 * @param feature
		 */
		public function insert(feature:VectorFeature):XML {
			var insertNode:XML = new XML("<" + this._wfsprefix + ":Insert xmlns:" + this._wfsprefix + "=\"" + this._wfsns + "\"></" + this._wfsprefix + ":Insert>");
			insertNode.appendChild(this.createFeatureXML(feature));
			return insertNode;
		}

		/**
		 * Takes a feature, and generates a WFS-T Transaction "Update"
		 *
		 * @param feature
		 */
		public function update(feature:VectorFeature):XMLNode {
			if (!feature.name) { Trace.error("Can't update a feature for which there is no FID."); }
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
			filterIdNode.attributes.fid = feature.name;
			filterNode.appendChild(filterIdNode);
			updateNode.appendChild(filterNode);

			return updateNode;
		}

		/**
		 * Takes a feature, and generates a WFS-T Transaction "Delete"
		 *
		 * @param feature
		 */
		public function remove(feature:Feature):XMLNode {
			if (!feature.attributes.fid) { 
				Trace.error("Can't update a feature for which there is no FID."); 
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

		//Getters and Setters
		public function get layer():WFS {
			return this._layer;
		}

		public function set layer(value:WFS):void {
			this._layer = value;
		}

	}
}

