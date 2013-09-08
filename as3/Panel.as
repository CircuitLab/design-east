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
	
    public class Panel extends Sprite {
		
		[Embed(source="assets/logo.png",mimeType="image/png")]
		private var LogoPNG:Class;
		private var _logo:Bmp = new Bmp(new LogoPNG);
		
		
		[Embed(source="assets/day1.png",mimeType="image/png")]
		private var Day1PNG:Class;
		private var _day1:Bmp = new Bmp(new Day1PNG);
		
		[Embed(source="assets/day2.png",mimeType="image/png")]
		private var Day2PNG:Class;
		private var _day2:Bmp = new Bmp(new Day2PNG);
		
		[Embed(source="assets/day3.png",mimeType="image/png")]
		private var Day3PNG:Class;
		private var _day3:Bmp = new Bmp(new Day3PNG);
		
		[Embed(source="assets/text1.png",mimeType="image/png")]
		private var Text1PNG:Class;
		private var _text1:Bmp = new Bmp(new Text1PNG);
		
		[Embed(source="assets/text2.png",mimeType="image/png")]
		private var Text2PNG:Class;
		private var _text2:Bmp = new Bmp(new Text2PNG);
		
		
		
		// 255x32 <--25---> 
		private var _label1:Sprite = new Sprite();
		private var _label2:Sprite = new Sprite();
		private var _base:Sprite = new Sprite();
		
		
		public function on($b:Boolean=false):void {
			
			if($b) {
				//_label1.alpha = 0;
				//_label2.alpha = 1;
				
				Mizt.addTween(_label1,{alpha:0,time:0.8});
				Mizt.addTween(_label2,{alpha:1,time:0.8});
				
			}
			else {
				//_label1.alpha = 1;
				//_label2.alpha = 0;
				
				Mizt.addTween(_label1,{alpha:1,time:0.8});
				Mizt.addTween(_label2,{alpha:0,time:0.8});
			}
			
		}
		
		public function Panel($day:int):void {	
			
			if($day==1) {
				addChild(_day1);
			}
			else if($day==2) {
				addChild(_day2);
			} 
			else {
				addChild(_day3);
			}
			
			addChild(_logo);
			_logo.y = 0;
			_logo.x = 0;
			
			with(_base.graphics) { beginFill(0x5b5b5b),drawRect(0,0,255,32),drawRect(255+25,0,255,32),endFill(); }

			with(_label1.graphics) { beginFill(0xFFFFFF),drawRect(0,0,255,32),endFill(); }
			with(_label2.graphics) { beginFill(0xFFFFFF),drawRect(0,0,255,32),endFill(); }
			
			addChild(_base);
			_base.x = _logo.x + 2;
			_base.y = _logo.y + _logo.height + 35;
			
			addChild(_label1);
			addChild(_label2);
			
			_label2.alpha = 0;
			
			_label1.x = _logo.x + 2;
			_label1.y = _logo.y + _logo.height + 35;
			_label2.x = _label1.x + _label1.width + 25;
			_label2.y = _label1.y;
			
			addChild(_text1);
			addChild(_text2);
			
			_text1.x = _label1.x + ((_label1.width-_text1.width)>>1);
			_text1.y = _label1.y + ((_label1.height-_text1.height)>>1);
			
			_text2.x = _label2.x + ((_label2.width-_text2.width)>>1);
			_text2.y = _label2.y + ((_label2.height-_text2.height)>>1);
			
		}
	}
};