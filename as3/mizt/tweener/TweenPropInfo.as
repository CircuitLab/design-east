package mizt.tweener {
	public class TweenPropInfo {
		public var valueStart				:Number;	// Starting value of the tweening (null if not started yet)
		public var valueComplete			:Number;	// Final desired value
		public var valueChange				:Number;	// Final desired value
		public var originalValueComplete	:Object;	// Final desired value as declared initially
		public var arrayIndex				:Number;	// Index (if this is an array item)
		public var extra					:Object;	// Additional parameters, used by some special properties
		public var isSpecialProperty		:Boolean;	// Whether or not this is a special property instead of a direct one
		public var hasModifier				:Boolean;	// Whether or not it has a modifier function
		public var modifierFunction			:Function;	// Modifier function, if any
		public var modifierParameters		:Array;		// Additional array of modifier parameters

		public function TweenPropInfo($valueStart:Number,$valueComplete:Number,$originalValueComplete:Object,$arrayIndex:Number,$extra:Object,$isSpecialProperty:Boolean,$modifierFunction:Function,$modifierParameters:Array) {
			valueStart				=	$valueStart;
			valueComplete			=	$valueComplete;
			valueChange 			=   $valueComplete - $valueStart;
			originalValueComplete	=	$originalValueComplete;
			arrayIndex				=	$arrayIndex;
			extra					=	$extra;
			isSpecialProperty		=	$isSpecialProperty;
			hasModifier				=	Boolean($modifierFunction);
			modifierFunction 		=	$modifierFunction;
			modifierParameters		=	$modifierParameters;
		}

		public function clone():TweenPropInfo { return new TweenPropInfo(valueStart, valueComplete, originalValueComplete, arrayIndex, extra, isSpecialProperty, modifierFunction, modifierParameters); }		
		public function toString():String { return "\n[TweenPropInfo valueStart:"+String(valueStart)+", valueComplete:"+String(valueComplete)+", originalValueComplete:"+String(originalValueComplete)+", arrayIndex:"+String(arrayIndex)+", extra:"+String(extra)+", isSpecialProperty:"+String(isSpecialProperty)+", hasModifier:"+String(hasModifier)+", modifierFunction:"+String(modifierFunction)+", modifierParameters:"+String(modifierParameters)+"]\n"; }
	}
};
