package {
	import flash.display.*;
    import flash.text.*;
	public class A1Mincho extends Sprite {
		[Embed(source="A-OTF-A1MinchoStd-Bold.otf",fontName="A1Mincho",mimeType="application/x-font",embedAsCFF="false")]
		public static var A1MinchoFont:Class;
		public function A1Mincho(){
			trace("A1Mincho");
            Font.registerFont(A1MinchoFont);            
			return;
        }
	}
};