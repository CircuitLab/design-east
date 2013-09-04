package mizt.tweener {

    import mizt.Mizt;

	public class TweenList {
		
		public var target					:Object;	// Object affected by this tweening
		public var prop						:Object;	// List of properties that are tweened (PropertyInfoObj instances)
		public var timeStart				:Number;	// Time when this tweening should start
		public var timeComplete				:Number;	// Time when this tweening should end
		public var transition				:Function;	// Equation to control the transition animation
		public var transitionParams			:Object;	// Additional parameters for the transition
		public var onStart					:Function;	// Function to be executed on the object when the tween starts (once)
		public var onUpdate					:Function;	// Function to be executed on the object when the tween updates (several times)
		public var onComplete				:Function;	// Function to be executed on the object when the tween completes (once)
		public var onOverwrite				:Function;	// Function to be executed on the object when the tween is overwritten
		public var onError					:Function;	// Function to be executed if an error is thrown when tweener exectues a callback (onComplete, onUpdate etc)
		public var onStartParams			:Array;		// Array of parameters to be passed for the event
		public var onUpdateParams			:Array;		// Array of parameters to be passed for the event
		public var onCompleteParams			:Array;		// Array of parameters to be passed for the event
		public var onOverwriteParams		:Array;		// Array of parameters to be passed for the event
		public var onStartScope				:Object;	// Scope in which the event function is ran
		public var onUpdateScope			:Object;	// Scope in which the event function is ran
		public var onCompleteScope			:Object;	// Scope in which the event function is ran
		public var onOverwriteScope			:Object;	// Scope in which the event function is ran
		public var onErrorScope				:Object;	// Scope in which the event function is ran
		public var rounded					:Boolean;	// Use rounded values when updating
		public var count					:Number;	// Number of times this caller should be called
		public var hasStarted				:Boolean;	// Whether or not this tween has already started

		// ==================================================================================================================================
		// CONSTRUCTOR function -------------------------------------------------------------------------------------------------------------

		/**
		 * Initializes the basic TweenListObj.
		 *
		 * @param	p_scope				Object		Object affected by this tweening
		 * @param	p_timeStart			Number		Time when this tweening should start
		 * @param	p_timeComplete		Number		Time when this tweening should end
		 * @param	p_transition		Function	Equation to control the transition animation
		 */
		function TweenList($target:Object,$timeStart:Number,$timeComplete:Number,$transition:Function,$transitionParams:Object) {
			target				=	$target;
			timeStart			=	$timeStart;
			timeComplete		=	$timeComplete;
			transition			=	$transition;
			transitionParams	=	$transitionParams;

			// Other default information
			prop		=	new Object();
			hasStarted		=	false;
		}

		public function setup($prop:Object,$obj:Object):void {
			prop				=	$prop;
			onStart				=	$obj.onStart;
			onUpdate			=	$obj.onUpdate;
			onComplete			=	$obj.onComplete;
			onOverwrite			=	$obj.onOverwrite;
			onError			    =	$obj.onError;
			onStartParams		=	$obj.onStartParams;
			onUpdateParams		=	$obj.onUpdateParams;
			onCompleteParams    =	$obj.onCompleteParams;
			onOverwriteParams	=	$obj.onOverwriteParams;
			onStartScope        =	$obj.onStartScope;
			onUpdateScope		=	$obj.onUpdateScope;
			onCompleteScope		=	$obj.onCompleteScope;
			onOverwriteScope    =	$obj.onOverwriteScope;
			onErrorScope	    =	$obj.onErrorScope;
			rounded				=	$obj.rounded;

		}

 
		// ==================================================================================================================================
		// OTHER functions ------------------------------------------------------------------------------------------------------------------
	
		/**
		 * Clones this tweening and returns the new TweenListObj
		 *
		 * @param	omitEvents		Boolean			Whether or not events such as onStart (and its parameters) should be omitted
		 * @return					TweenListObj	A copy of this object
		 */
		public function clone(omitEvents:Boolean):TweenList {
			var nTween:TweenList = new TweenList(target, timeStart, timeComplete, transition, transitionParams);
			nTween.prop = new Array();
			for (var pName:String in prop) {
				nTween.prop[pName] = prop[pName].clone();
			}
			if (!omitEvents) {
				nTween.onStart = onStart;
				nTween.onUpdate = onUpdate;
				nTween.onComplete = onComplete;
				nTween.onOverwrite = onOverwrite;
				nTween.onError = onError;
				nTween.onStartParams = onStartParams;
				nTween.onUpdateParams = onUpdateParams;
				nTween.onCompleteParams = onCompleteParams;
				nTween.onOverwriteParams = onOverwriteParams;
				nTween.onStartScope = onStartScope;
				nTween.onUpdateScope = onUpdateScope;
				nTween.onCompleteScope = onCompleteScope;
				nTween.onOverwriteScope = onOverwriteScope;
				nTween.onErrorScope = onErrorScope;
			}
			nTween.rounded = rounded;
			nTween.count = count;
			nTween.hasStarted = hasStarted;

			return nTween;
		}

		/**
		 * Returns this object described as a String.
		 *
		 * @return					String		The description of this object.
		 */
		public function toString():String {
			var returnStr:String = "\n[TweenListObj ";
			returnStr += "target:" + String(target);
			returnStr += ", prop:";
			var isFirst:Boolean = true;
			for (var i:String in prop) {
				if (!isFirst) returnStr += ",";
				returnStr += "[name:"+prop[i].name;
				returnStr += ",valueStart:"+prop[i].valueStart;
				returnStr += ",valueComplete:"+prop[i].valueComplete;
				returnStr += "]";
				isFirst = false;
			}
			returnStr += ", timeStart:" + String(timeStart);
			returnStr += ", timeComplete:" + String(timeComplete);
			returnStr += ", transition:" + String(transition);
			returnStr += ", transitionParams:" + String(transitionParams);

			if (Boolean(onStart))			returnStr += ", onStart:"			+ String(onStart);
			if (Boolean(onUpdate))			returnStr += ", onUpdate:"			+ String(onUpdate);
			if (Boolean(onComplete))		returnStr += ", onComplete:"		+ String(onComplete);
			if (Boolean(onOverwrite))		returnStr += ", onOverwrite:"		+ String(onOverwrite);
			if (Boolean(onError))			returnStr += ", onError:"			+ String(onError);
			
			if (onStartParams)		returnStr += ", onStartParams:"		+ String(onStartParams);
			if (onUpdateParams)		returnStr += ", onUpdateParams:"	+ String(onUpdateParams);
			if (onCompleteParams)	returnStr += ", onCompleteParams:"	+ String(onCompleteParams);
			if (onOverwriteParams)	returnStr += ", onOverwriteParams:" + String(onOverwriteParams);

			if (onStartScope)		returnStr += ", onStartScope:"		+ String(onStartScope);
			if (onUpdateScope)		returnStr += ", onUpdateScope:"		+ String(onUpdateScope);
			if (onCompleteScope)	returnStr += ", onCompleteScope:"	+ String(onCompleteScope);
			if (onOverwriteScope)	returnStr += ", onOverwriteScope:"	+ String(onOverwriteScope);
			if (onErrorScope)		returnStr += ", onErrorScope:"		+ String(onErrorScope);

			if (rounded)			returnStr += ", rounded:"			+ String(rounded);
			if (count)				returnStr += ", count:"				+ String(count);
			if (hasStarted)			returnStr += ", hasStarted:"		+ String(hasStarted);
			
			returnStr += "]\n";
			return returnStr;
		}
		
		/**
		 * Checks if $obj "inherits" properties from other objects, as set by the "base" property. Will create a new object, leaving others intact.
		 * o_bj.base can be an object or an array of objects. Properties are collected from the first to the last element of the "base" filed, with higher
		 * indexes overwritting smaller ones. Does not modify any of the passed objects, but makes a shallow copy of all properties.
		 *
		 * @param		$obj		Object				Object that should be tweened: a movieclip, textfield, etc.. OR an array of objects
		 * @return					Object				A new object with all properties from the $obj and $obj.base.
		 */

		public static function makePropChain($obj:Object):Object {
			
			var baseObject:Object = $obj.base; // Is this object inheriting properties from another object?
			if(baseObject){
				var chainedObject:Object = {}; // object inherits. Are we inheriting from an object or an array
				var chain:Object;
				if (baseObject is Array){
					chain = []; // Inheritance chain is the base array
					for (var k:Number=0; k<baseObject.length; k++) chain.push(baseObject[k]); // make a shallow copy
				}
				else {
					chain = [baseObject]; // Only one object to be added to the array
				}				
				chain.push($obj); // add the final object to the array, so it's properties are added last

				var currChainObj:Object;
				var len:Number = chain.length; // Loops through each object adding it's property to the final object
				for(var i:uint=0; i<len ; i++) {
					// deal with recursion: watch the order! "parent" base must be concatenated first!
					currChainObj  = (chain[i]["base"])?(Mizt.concatObjects( makePropChain(chain[i]["base"] ), chain[i])):(chain[i]);
					chainedObject = Mizt.concatObjects(chainedObject, currChainObj );
				}
				if(chainedObject["base"]) delete chainedObject["base"];
				return chainedObject;
			}
			else{
				return $obj; // No inheritance, just return the object it self
			}
		}
	}
};
