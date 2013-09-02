package {
	import flash.display.*;
    import flash.text.*;
	public class AxisCondMedium extends Sprite {
		[Embed(source="AxisCondStd-Medium.otf",fontName="AxisCondMedium",mimeType="application/x-font",embedAsCFF="false")]
		public static var AxisCondMediumFont:Class;
		public function AxisCondMedium(){
			trace("AxisCondMedium");
            Font.registerFont(AxisCondMediumFont);            
			return;
        }
	}
};