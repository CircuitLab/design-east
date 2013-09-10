package mizt.utils {
	public class Counter extends Delay {
		public function Counter($duration:Number) { super($duration); }
		public function getTime():Number  { return t; }
		public function getValue():Number { return t/d; }
	}
}