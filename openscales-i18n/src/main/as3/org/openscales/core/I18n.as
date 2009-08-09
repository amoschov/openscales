package org.openscales.core {
	import org.openscales.core.i18n.Lang;
	import org.openscales.core.i18n.LocalizedClassProperties;

	/**
	 * Internationalization class for openscales.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author didier.richard@ign.fr
	 */
	public class I18n {

		/**
		 * Localized properties for openscales.
		 * @private
		 */
		private static var _I18N:LocalizedClassProperties;
		{
			_I18N=new LocalizedClassProperties(I18n);
			// WARNING direct port of OpenLayers/Lang/*.js messages :
			_I18N.setLocale(Lang.EN, { /*
				   "unhandledRequest":
						  "Unhandled request return ${statusText}",

					   "permalink":
					   "Permalink",

					   "overlays":
					   "Overlays",

					   "baseLayer":
					   "Base Layer",

					   "sameProjection":
					   "The overview map only works when it is in the same projection as the main map",

					   "readNotImplemented":
					   "Read not implemented.",

					   "writeNotImplemented":
					   "Write not implemented.",

					   "noFID":
					   "Can't update a feature for which there is no FID.",

					   "errorLoadingGML":
					   "Error in loading GML file ${url}",

					   "browserNotSupported":
					   "Your browser does not support vector rendering. Currently supported renderers are:\n${renderers}",

					   "componentShouldBe":
					   "addFeatures : component should be an ${geomType}",

					   "getFeatureError":
					   "getFeatureFromEvent called on layer with no renderer. This usually means you destroyed a layer, but not some handler which is associated with it.",

					   "minZoomLevelError":
					   "The minZoomLevel property is only intended for use with the FixedZoomLevels-descendent layers. That this wfs layer checks for minZoomLevel is a relic of the past. We cannot, however, remove it without possibly breaking OL based applications that may depend on it.  Therefore we are deprecating it -- the minZoomLevel check below will be removed at 3.0. Please instead use min/max resolution setting as described here: http://trac.openlayers.org/wiki/SettingZoomLevels",

					   "commitSuccess":
					   "WFS Transaction: SUCCESS ${response}",

					   "commitFailed":
					   "WFS Transaction: FAILED ${response}",

					   "googleWarning":
					   "The Google Layer was unable to load correctly.<br><br> To get rid of this message, select a new BaseLayer in the layer switcher in the upper-right corner.<br><br> Most likely, this is because the Google Maps library script was either not included, or does not contain the correct API key for your site.<br><br> Developers: For help getting this working correctly, <a href='http://trac.openlayers.org/wiki/Google' target='_blank'>click here</a>",

					   "getLayerWarning":
					   "The ${layerType} Layer was unable to load correctly.<br><br> To get rid of this message, select a new BaseLayer in the layer switcher in the upper-right corner.<br><br> Most likely, this is because the ${layerLib} library script was not correctly included.<br><br> Developers: For help getting this working correctly, <a href='http://trac.openlayers.org/wiki/${layerLib}' target='_blank'>click here</a>",

					   "scale":
					   "Scale = 1 : ${scaleDenom}",

					   "layerAlreadyAdded":
					   "You tried to add the layer: ${layerName} to the map, but it has already been added",

					   "reprojectDeprecated":
					   "You are using the 'reproject' option on the ${layerName} layer. This option is deprecated: its use was designed to support displaying data over commercial basemaps, but that functionality should now be achieved by using Spherical Mercator support. More information is available from http://trac.openlayers.org/wiki/SphericalMercator.",

					   "methodDeprecated":
					   "This method has been deprecated and will be removed in 3.0. Please use ${newMethod} instead.",

					   "boundsAddError":
					   "You must pass both x and y values to the add function.",

					   "lonlatAddError":
					   "You must pass both lon and lat values to the add function.",

					   "pixelAddError":
					   "You must pass both x and y values to the add function.",

					   "unsupportedGeometryType":
					   "Unsupported geometry type: ${geomType}",

					   "pagePositionFailed":
					   "OpenLayers.Util.pagePosition failed: element with id ${elemId} may be misplaced.",

					   "filterEvaluateNotImplemented":
					   "evaluate is not implemented for this filter type.",
					 */

					"__end__": ""});

			_I18N.setLocale(Lang.FR, { /*
				   "unhandledRequest":
						  "Retour de requête non pris en compte ${statusText}",

					   "permalink":
					   "Lien permanent",

					   "overlays":
					   "Cartes additionnelles",

					   "baseLayer":
					   "Carte de base",

					   "sameProjection":
					   "La mini carte ne peut fonctionner que si sa projection est celle de la carte de base",

					   "readNotImplemented":
					   "Lecture non mise en oeuvre.",

					   "writeNotImplemented":
					   "Écriture non mise en oeuvre.",

					   "noFID":
					   "Ne peut mettre à jour un objet sans FID.",

					   "errorLoadingGML":
					   "Erreur au chargement du fichier GML ${url}",

					   "browserNotSupported":
					   "Votre butineur ne supporte pas de rendu vectoriel. Actuellement les rendus supportés sont :\n${renderers}",

					   "componentShouldBe":
					   "addFeatures : le composant devrait être un ${geomType}",

					   "getFeatureError":
					   "getFeatureFromEvent appelé sur une couche sans moteur de rendu. Ceci signifie que vous avez supprimé la couche, mais pas le gestionnaire qui lui était associé.",

					   "minZoomLevelError":
					   "La propriété minZoomLevel est uniquement utilisée avec les couches dépendant de FixedZoomLevels. Le fait que la couche WFS vérifie le minZoomLevel est un vestige du passé. Cependant, nous ne pouvons le retirer sans provoquer des problèmes dans les applications. OpenLayers qui dépendraient de cette fonctionnalités.  De fait, elle a été dépréciée -- la vérification du minZoomLevel sera retirée en 3.0. Il est préférable d'utiliser les résolutions min/max comme décrit ici : http://trac.openlayers.org/wiki/SettingZoomLevels",

					   "commitSuccess":
					   "Transaction WFS: SUCCÉS ${response}",

					   "commitFailed":
					   "Transaction WFS: ÉCHEC ${response}",

					   "googleWarning":
					   "La couche Google n'a pas été chargée correctement.<br/><br/> Pour supprimer cette alerte, sélectionner dans le gestionnaire de couches.<br/></br/> Il est probable que la bibliothèque Google Maps n'a, soit pas été incluse, soit ne contient pas une clef de licence correcte pour votre site.<br/><br/> Développeurs : afin d'obtenir de l'aide sur ce problème, <a href='http://trac.openlayers.org/wiki/Google' target='_blank'>cliquer ici</a>",

					   "getLayerWarning":
					   "La couche ${layerType} n'a pas été chargée correctement.<br/><br/> Pour supprimer cette alerte, sélectionner une nouvelle carte de base dans le gestionnaire de couches.<br/></br/>" +
					   "Il est probable que la bibliothèque ${layerLib} n'a pas été incluse correctement.<br/><br/> Développeurs : afin d'obtenir de l'aide sur ce problème, <a href='http://trac.openlayers.org/wiki/${layerLib}' target='_blank'>cliquer ici</a>",

					   "scale":
					   "Échelle = 1 : ${scaleDenom}",

					   "layerAlreadyAdded":
					   "Vous avez tenté d'ajouter la couche : ${layerName} à la carte, mais celle-ci existe déjà",

					   "reprojectDeprecated":
					   "Vous utilisez l'option 'reproject' pour la couche ${layerName} Cette option est dépréciée : son utilisation a été conçue pour supporter l'affichage de couches sur des cartes de base commerciales, mais cette fonctionnalité devrait dorénavant être assurée via le support du Mercator sphérique. Plus d'information est disponible <a href='http://trac.openlayers.org/wiki/SphericalMercator' target='_blank'>là</a>",

					   "methodDeprecated":
					   "Cette méthode a été dépréciée et sera retirée en 3.0. Prière d'utiliser ${newMethod} à la place.",

					   "boundsAddError":
					   "Vous devez fournir à la fois les valeurs de x et y à la méthode add.",

					   "lonlatAddError":
					   "Vous devez fournir à la fois les valeur lon et lat à la méthode add.",

					   "pixelAddError":
					   "Vous devez fournir à la fois les valeurs de x et y à la méthode add.",

					   "unsupportedGeometryType":
					   "Type géométrique non supporté : ${geomType}",

					   "pagePositionFailed":
					   "OpenLayers.Util.pagePosition échoué : élément d'identifiant ${elemId} doit être mal positionné",

					   "filterEvaluateNotImplemented":
					   "la méthode evaluate n'est pas mise en oeuvre sur ce type de filtre.",
					 */

					"__end__": ""});
		}

		/**
		 * Return the last loaded language.
		 *
		 * @return the current language.
		 */
		public static function getLanguage():Lang {
			return _I18N.language;
		}

		/**
		 * Set the current language.
		 *
		 * @param lang the language to set.
		 */
		public static function setLanguage(lang:Lang):void {
			_I18N.language=lang;
		}

		/**
		 * Return a translated string for the localized properties and current language.
		 *
		 * @param key the property key to retrieve.
		 * @param context An object with properties corresponding to the tokens in the format
		 *                string. If no context, the property value is returned unchanged.
		 * @param args arguments to pass to any functions found in the context.  If a context
		 *             property is a function, the token will be replaced by the return from the
		 *             function called with these arguments.
		 *
		 * @return A string with tokens replaced with properties from the given context object.
		 */
		public static function translate(key:String, context:Object=null, args:Array=null):String {
			return _I18N.translate(key, context, args);
		}

	}

}
