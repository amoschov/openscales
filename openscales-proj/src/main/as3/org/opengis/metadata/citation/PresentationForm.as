/**
 * @see http://geoapi.sourceforge.net/2.3/javadoc/org/opengis/metadata/citation/PresentationForm.html
 * @see http://www.opengeospatial.org/ogc/legal
 */
package org.opengis.metadata.citation {
	import flash.utils.getQualifiedClassName;
	import org.opengis.util.CodeList;

	/**
	 * Mode in which the data is represented.
	 *
	 * UML: CI_PresentationFormCode
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public final class PresentationForm extends CodeList {

		/**
		 * Values for this code list.
		 * @private
		 */
		private static var VALUES:Array=[];

		/**
		 * Digital representation of a primarily textual item (can contain illustrations also).
		 */
		public static const DOCUMENT_DIGITAL:PresentationForm=new PresentationForm("DOCUMENT_DIGITAL", "documentDigital");

		/**
		 * Representation of a primarily textual item (can contain illustrations also) on paper,
		 * photographic material, or other media.
		 */
		public static const DOCUMENT_HARDCOPY:PresentationForm=new PresentationForm("DOCUMENT_HARDCOPY", "documentHardcopy");

		/**
		 * Likeness of natural or man-made features, objects, and activities acquired through the
		 * sensing of visual or any other segment of the electromagnetic spectrum by sensors, such as
		 * thermal infrared, and high resolution radar and stored in digital format.
		 */
		public static const IMAGE_DIGITAL:PresentationForm=new PresentationForm("IMAGE_DIGITAL", "imageDigital");

		/**
		 * Likeness of natural or man-made features, objects, and activities acquired through the
		 * sensing of visual or any other segment of the electromagnetic spectrum by sensors, such as
		 * thermal infrared, and high resolution radar and reproduced on paper, photographic material,
		 * or other media for use directly by the human user.
		 */
		public static const IMAGE_HARDCOPY:PresentationForm=new PresentationForm("IMAGE_HARDCOPY", "imageHardcopy");

		/**
		 * Map represented in raster or vector form.
		 */
		public static const MAP_DIGITAL:PresentationForm=new PresentationForm("MAP_DIGITAL", "mapDigital");

		/**
		 * Map printed on paper, photographic material, or other media for use directly by the human
		 * user.
		 */
		public static const MAP_HARDCOPY:PresentationForm=new PresentationForm("MAP_HARDCOPY", "mapHardcopy");

		/**
		 * Multi-dimensional digital representation of a feature, process, etc.
		 */
		public static const MODEL_DIGITAL:PresentationForm=new PresentationForm("MODEL_DIGITAL", "modelDigital");

		/**
		 * 3-dimensional, physical model.
		 */
		public static const MODEL_HARDCOPY:PresentationForm=new PresentationForm("MODEL_HARDCOPY", "modelHardcopy");

		/**
		 * Vertical cross-section in digital form.
		 */
		public static const PROFILE_DIGITAL:PresentationForm=new PresentationForm("PROFILE_DIGITAL", "profileDigital");

		/**
		 * Vertical cross-section printed on paper, etc.
		 */
		public static const PROFILE_HARDCOPY:PresentationForm=new PresentationForm("PROFILE_HARDCOPY", "profileHardcopy");

		/**
		 * Digital representation of facts or figures systematically displayed, especially in columns.
		 */
		public static const TABLE_DIGITAL:PresentationForm=new PresentationForm("TABLE_DIGITAL", "tableDigital");

		/**
		 * Representation of facts or figures systematically displayed, especially in columns, printed
		 * on paper, photographic material, or other media.
		 */
		public static const TABLE_HARDCOPY:PresentationForm=new PresentationForm("TABLE_HARDCOPY", "tableHardcopy");

		/**
		 * Digital video recording.
		 */
		public static const VIDEO_DIGITAL:PresentationForm=new PresentationForm("VIDEO_DIGITAL", "videoDigital");

		/**
		 * Video recording on film.
		 */
		public static const VIDEO_HARDCOPY:PresentationForm=new PresentationForm("VIDEO_HARDCOPY", "videoHardcopy");

		/**
		 * Build a new type of mode.
		 *
		 * @param name the codelist value.
		 * @param identifier the codelist value identifier.
		 *
		 * @throws DefinitionError duplicated name.
		 */
		public function PresentationForm(name:String, identifier:String="") {
			// FIXME : PresentationForm.VALUES is null ... while VALUES is ok !
			super(VALUES, name, identifier);
		}

		/**
		 * Return the list of enumerations of the same kind than this enum.
		 *
		 * @return The codes of the same kind than this code.
		 */
		public function family():Array {
			return PresentationForm.values();
		}

		/**
		 * Return the list of DateType.
		 *
		 * @return The list of codes.
		 */
		public static function values():Array {
			return PresentationForm.VALUES;
		}

		/**
		 * Return the date type that matches the given string.
		 *
		 * @param name the codelist value.
		 *
		 * @return the date type or null.
		 */
		public static function valueOf(name:String):PresentationForm {
			return CodeList.valueOf(name, getQualifiedClassName(PresentationForm)) as PresentationForm;
		}

	}

}
