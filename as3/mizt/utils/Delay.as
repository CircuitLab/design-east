package mizt.utils {
	public class Delay {
		protected var t:Number, d:Number;
		public function Delay($duration:Number) { this.reset(); d=$duration; }
		public function update($step:Number):Boolean { return ((t+=$step)<d)?false:true; }
		public function reset():void { t = 0; }
	}
}