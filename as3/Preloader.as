package {
    
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
    import flash.external.*;
	import flash.geom.*;
	
	import mizt.Mizt;
	import mizt.display.Bmp;

    public class Preloader extends Sprite {
    
	    [Embed(source="assets/credit.png",mimeType="image/png")]
		private var CreditPNG:Class;
		private var _credit:Bmp = new Bmp(new CreditPNG);
		
		private var _text:TextField;
		private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		
		private var WIDTH:int = 1920;
		private var HEIGHT:int = 1080;
		
		private var _bitmapData:BitmapData = new BitmapData(1920,1080,true,0xFF00171c);
		private var _bitmap:Bitmap = new Bitmap(_bitmapData); 
		
		
		
		private var _panel:Panel;
		
		private var _dotBitmapData:BitmapData = new BitmapData(2,2,true,0xFF00171c);
		private var _dots:Sprite = new Sprite();
		//private var _dotbitmapData:BitmapData = new BitmapData(1024,768,true,0xFF000000);
		//private var _dotbitmap:Bitmap = new Bitmap(_dotbitmapData); 
		
		private var _overlay:Sprite = new Sprite();
		
		private var _counter:int = 0;
		
		private var _fill:Sprite = new Sprite();
		
		public static function getClass(str:String):Class { return Class(ApplicationDomain.currentDomain.getDefinition(str)); }

		private var _fontSize:int = 22; 

		private var _row:int = 0;
		private var _col:int = 0;
	
		public function Preloader():void {	
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			with(this.graphics) { beginFill(0xFF00171c); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			with(_fill.graphics) { beginFill(0xFF00171c,0.01); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			
			with(_overlay.graphics) { beginFill(0x0,0.5); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			
			_context.applicationDomain = ApplicationDomain.currentDomain;

			_font = new Loader();
			(_font.contentLoaderInfo).addEventListener(Event.COMPLETE,onComplete);
			_font.load(new URLRequest("fonts/A1Mincho.swf"),_context);
		}
		
		private function on($arr:Array):void {
			trace($arr);
			for(var k:int=0; k<$arr.length; k++) {
				//trace($arr[k][7]);
				var cache:Array = $arr[k];
				var tmp:String = cache[0];
				//var tmp:String = $arr[k][1];
				if(tmp!=="*") {
					if(cache[1]=="名詞"&&tmp.length>1) {
						_text.textColor = 0xFFFFFF;
					}
					else {
						_text.textColor = 0x777777;
					}
					_text.text = tmp;//+".";
					_bitmapData.draw(_text,new Matrix(1,0,0,1,_row,_col));
					_row += _text.width;
					if(_row>WIDTH) {
						_row=0;//Math.random()*-_fontSize;
						_col+=_fontSize;
						if(_col>HEIGHT-_fontSize) _col=0;//Math.random()*-_fontSize;
					}
				}
			}
			//JSON.stringify(data.segments, 2)
		}
		
		private function onUpdate(e:Event):void {
			
			if(_counter++>10) {
				//_bitmapData.draw(_fill);
				_counter = 0;
			}
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
			fmt.font="A1Mincho"; // AxisStd-Light //"AxisStd-Light"; // Bold
			fmt.size=_fontSize;
			//fmt.color=0xFFFFFF;
			_text.embedFonts = true;
			_text.defaultTextFormat = fmt;
			_text.text = "";
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.textColor = 0x00FF00;
			//
			
			//addChild(_text);
			
			ExternalInterface.addCallback("emit",on);
			
			addChild(_bitmap);
			
			_dotBitmapData.setPixel32(0,0,0x33000000);
			_dotBitmapData.setPixel32(1,1,0x99000000);
			
			addChild(_credit);
			_credit.x = 22;
			_credit.y = HEIGHT - 35;
			
			if(loaderInfo.parameters["day"]&&loaderInfo.parameters["day"]=="1") {
				trace("day1");
				 _panel = new Panel(1);
			}
			else if(loaderInfo.parameters["day"]&&loaderInfo.parameters["day"]=="2") {
				trace("day2");
				 _panel = new Panel(2);
			}
			else {
				trace("day3");	
				_panel = new Panel(3);
			}
			addChild(_panel);
			_panel.x = 50;
			_panel.y = 400;
			
			addChild(_overlay);
			_overlay.visible = false;
			
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
			
			
		}
	}
};