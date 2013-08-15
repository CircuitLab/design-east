package {
	import flash.display.*;
    import flash.text.*;
	public class AxisStdLight extends Sprite {
		[Embed(source="AxisStd-Light.otf",fontName="AxisStd-Light",mimeType="application/x-font",embedAsCFF="false")]
		public static var AxisStdLightFont:Class;
		public function AxisStdLight(){
			trace("AxisStdLight");
            Font.registerFont(AxisStdLightFont);            
			return;
        }
	}
};