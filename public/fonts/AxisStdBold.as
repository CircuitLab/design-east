package {
	import flash.display.*;
    import flash.text.*;
	public class AxisStdBold extends Sprite {
		[Embed(source="AxisStd-Bold.otf",fontName="AxisStd-Bold",mimeType="application/x-font",embedAsCFF="false")]
		public static var AxisStdBoldFont:Class;
		public function AxisStdBold(){
			trace("AxisStdBold");
            Font.registerFont(AxisStdBoldFont);            
			return;
        }
	}
};