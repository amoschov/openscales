package org.openscales.core.i18n {
	import org.openscales.core.loader.TextLoader;
	import org.openscales.core.StringUtils;

	/**
	 * Properties loader base class. A properties file is a UTF-8 text file following this syntax :
	 * <ul>
	 * <li>a comment line starts with # or ! : it is ignored;</li>
	 * <li>an empty line is ignored;</li>
	 * <li>key=value line, key must not contain spaces;</li>
	 * <li>special characters like \u000D, \u2028 and \u02029 are replaced with \u000A (Line
	 *     Feed).</li>
	 * </ul>
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class PropertiesLoader extends TextLoader {

		/**
		 * The regexp for searching a comment.
		 * @private
		 */
		private static const _ISCOMRX:RegExp=new RegExp("^[#!]", "");

		/**
		 * The regexp for getting the key and value.
		 * @private
		 */
		private static const _KVPRX:RegExp=new RegExp("\\s*=", "");

		/**
		 * The regexp for search spaces in keys.
		 * @private
		 */
		private static const _SPACE:RegExp=new RegExp("\\s");

		/**
		 * Build a properties loader.
		 */
		public function PropertiesLoader() {
			super();
		}

		/**
		 * Parse the loaded properties.
		 *
		 * @param source the return UTF-8 text to parse.
		 */
		override public function parse(source:String):Object {
			var p:Object={};
			// replace CR, LS, PS by LF :
			source=source.replace(TextLoader._SCHARRX, "\u000A");
			// get lines :
			var lines:Array=source.split("\u000A");
			var line:String;
			for (var i:Number=0, n:Number=lines.length; i < n; i++) {
				line=lines[i];
				if (line.length == 0) {
					continue;
				}
				if (line.match(_ISCOMRX) != null) {
					continue;
				}
				var kvp:Array=line.split(_KVPRX);
				if (kvp == null || kvp.length == 0) {
					continue;
				}
				kvp[0]=StringUtils.trim(kvp[0]);
				if (kvp[0].search(_SPACE) == -1) {
					p[kvp[0]]=kvp[1];
				}
			}
			line=null;
			lines=null;
			return p;
		}

	}

}
