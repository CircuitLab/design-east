package {
    
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
    public class Preloader extends Sprite {
		
		private var _text:TextField;
		private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		
		public static function getClass(str:String):Class { return Class(ApplicationDomain.currentDomain.getDefinition(str)); }


		public function Preloader():void {	
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			_context.applicationDomain = ApplicationDomain.currentDomain;

			_font = new Loader();
			(_font.contentLoaderInfo).addEventListener(Event.COMPLETE,onComplete);
			//_font.load(new URLRequest("fonts/AxisStdBold.swf"),_context);		
			_font.load(new URLRequest("fonts/AxisStdLight.swf"),_context);
		}
		
		private function onComplete(e:Event):void {
			trace("onComplete");
			
			//new getClass();
			
			trace("<font>");
			var fontList:Array = Font.enumerateFonts(false);
			for each(var font:Font in fontList) {
				trace(font.fontName);
			}
			trace("</font>");
			
			_text = new TextField();
			
			var fmt:TextFormat = new TextFormat();
			fmt.font="AxisStd-Light"; 
			fmt.size=50;
			//fmt.color=0xFFFFFF;
			_text.embedFonts = true;
			_text.defaultTextFormat = fmt;
			_text.text = "こんにちは";
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.textColor = 0xFFFFFF;
			//
			
			addChild(_text);
		}
	}
};