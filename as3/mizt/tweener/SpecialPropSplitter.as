package mizt.tweener {
	public class SpecialPropSplitter {

		public var parameters:Array;
		public var splitValues:Function;

		public function SpecialPropSplitter ($splitFunction:Function,$parameters:Array) {
			splitValues = $splitFunction;
			parameters  = $parameters;
		}

		public function toString():String { return "[SpecialPropertySplitter splitValues:"+String(splitValues);", parameters:"+String(parameters)+ "]"; }
	}
};
