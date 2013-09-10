package mizt.tweener {
	public class SpecialProp {
		public var getValue:Function; // ($obj:Object, $parameters:Array, $extra:Object):Number
		public var setValue:Function; // ($obj:Object, $value:Number, $parameters:Array, p_extra:Object): Void
		public var parameters:Array;
		public var preProcess:Function; // ($obj:Object, p_parameters:Array, $originalValueComplete:Object, $extra:Object): Number

		public function SpecialProp($getFunction:Function, $setFunction:Function, $parameters:Array = null, $preProcessFunction:Function = null) {
			getValue   = $getFunction;
			setValue   = $setFunction;
			parameters = $parameters;
			preProcess = $preProcessFunction;
		}
	
		public function toString():String { return "[SpecialProperty "+"getValue:"+String(getValue)+", setValue:"+String(setValue)+ ", parameters:"+String(parameters)+", preProcess:"+String(preProcess) + "]"; }
	}
};
