package {
    
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
    import flash.external.*;
	import flash.geom.*;

    public class Preloader extends Sprite {
		
		private var _text:TextField;
		private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		
		private var _bitmapData:BitmapData = new BitmapData(1024,768,true,0xFF000000);
		private var _bitmap:Bitmap = new Bitmap(_bitmapData); 
		
		private var _dotBitmapData:BitmapData = new BitmapData(2,2,true,0x00000000);
		private var _dots:Sprite = new Sprite();
		//private var _dotbitmapData:BitmapData = new BitmapData(1024,768,true,0xFF000000);
		//private var _dotbitmap:Bitmap = new Bitmap(_dotbitmapData); 
		
		private var _overlay:Sprite = new Sprite();
		
		private var _counter:int = 0;
		
		private var _fill:Sprite = new Sprite();
		
		public static function getClass(str:String):Class { return Class(ApplicationDomain.currentDomain.getDefinition(str)); }

		private var _fontSize:int = 32; 

		private var _row:int = 0;
		private var _col:int = 0;
	
		public function Preloader():void {	
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			with(this.graphics) {
				beginFill(0x0);
				drawRect(0,0,1024,768);
				endFill();
			}
			
			
			with(_fill.graphics) {
				beginFill(0x0,0.01); // 0.04
				drawRect(0,0,1024,768);
				endFill();
			}
			
			
			with(_overlay.graphics) { beginFill(0x0,0.5); drawRect(0,0,1024,768); endFill(); }
			
			_context.applicationDomain = ApplicationDomain.currentDomain;

			_font = new Loader();
			(_font.contentLoaderInfo).addEventListener(Event.COMPLETE,onComplete);
			//_font.load(new URLRequest("fonts/AxisStdBold.swf"),_context);		
			_font.load(new URLRequest("fonts/AxisCondMedium.swf"),_context); // AxisCondMedium // AxisStdLight // AxisStdBold
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
					if(_row>1024) {
						_row=0;//Math.random()*-_fontSize;
						_col+=_fontSize;
						if(_col>768-_fontSize) _col=0;//Math.random()*-_fontSize;
					}
				}
			}
			//JSON.stringify(data.segments, 2)
		}
		
		private function onUpdate(e:Event):void {
			
			if(_counter++>10) {
				_bitmapData.draw(_fill);
				_counter = 0;
			}
			/*
			//_overlay.visible = !_overlay.visible;
			//_bitmapData.fillRect(new Rectangle(0,0,1024,768),0x00000000);
			_bitmapData.draw(_fill);
			
			var rand:int = Math.random()*30; 
			//var p:int = rand%3;
			
			if(Math.random()>0.5) return;
			
			
			for(var k:int=0; k<rand; k++) {
				
				
				var p:int = (Math.random()*30)%6;
				
				if(p==0) _text.text = "こんにちは.";
				else if(p==1) _text.text = "さようなら.";
				else if(p==2) _text.text = "疲れた.";
				else if(p==3) _text.text = "ナイター.";
				else if(p==4) _text.text = "hello.";
				else {
					_text.text = "正確.";
				}
			
				
				_bitmapData.draw(_text,new Matrix(1,0,0,1,_row,_col));
				
				_row += _text.width;
				if(_row>1024) {
					_row=0;//Math.random()*-_fontSize;
					_col+=_fontSize;
					if(_col>768-_fontSize) _col=0;//Math.random()*-_fontSize;
				//_col
				}
			}
			*/
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
			fmt.font="AxisCondMedium"; // AxisStd-Light //"AxisStd-Light"; // Bold
			fmt.size=_fontSize;
			//fmt.color=0xFFFFFF;
			_text.embedFonts = true;
			_text.defaultTextFormat = fmt;
			_text.text = "こんにちは";
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.textColor = 0x00FF00;
			//
			
			//addChild(_text);
			
			ExternalInterface.addCallback("emit",on);
			
			addChild(_bitmap);
			
			_dotBitmapData.setPixel32(0,0,0x33000000);
			_dotBitmapData.setPixel32(1,1,0x99000000);
			
			_dots.graphics.beginBitmapFill(_dotBitmapData);
			_dots.graphics.drawRect(0,0,1024,768);
			_dots.graphics.endFill();
			addChild(_dots);
			
			
			addChild(_overlay);
			_overlay.visible = false;
			
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
			
			
		}
	}
};