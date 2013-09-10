package mizt.fonts {	
	import flash.text.Font;
	public class Fnt extends Object  {
		public function Fnt() { return };
		public static function register($font:Class):void {
			Font.registerFont($font);
		}
		public static function list():void { 
			trace("<font>");
			var fontList:Array = Font.enumerateFonts(false);
			for each(var font:Font in fontList) trace("\t"+font.fontName);
			trace("</font>");
        }
	}
};