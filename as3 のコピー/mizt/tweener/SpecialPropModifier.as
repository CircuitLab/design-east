package mizt.tweener {
	public class SpecialPropModifier {

		public var modifyValues:Function;
		public var getValue:Function;

		public function SpecialPropModifier($modifyFunction:Function,$getFunction:Function) {
			modifyValues = $modifyFunction;
			getValue     = $getFunction;
		}

		public function toString():String { return "[SpecialPropertyModifier "+"modifyValues:"+String(modifyValues)+", "+"getValue:"+String(getValue)+"]"; }
	}
};
