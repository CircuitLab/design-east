package {
    
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
    import flash.external.*;
	import flash.geom.*;
	

    public class TextFieldManager extends Sprite {
    
    	private var WIDTH:int  = 1920;
    	private var HEIGHT:int = 1080;
    	
    	private var TEXT_HEIGHT:int = 24;
    	
    	private var MAX_NUM:uint = 4800;
    	private var _words:Array = [];
    	private var _types:Array = [];
    	private var _tf:Array = [];
    	
    	//private var _panel:Panel = new Panel(1);
    	
    	private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		private var _cnt:int = 0;
		
		
		public function add($word:String,$type:Boolean=false):void {
			
			for(var k:int=1; k<MAX_NUM; k++) {
			
				var tmp:int = (MAX_NUM-1)-k;
				_words[tmp] = _words[tmp-1];
				_types[tmp] = _types[tmp-1];
				
			}
			
			_words[0] = $word;
			_types[0] = $type;
			
		}
		
		
		public function TextFieldManager():void {	
			//stage.scaleMode = "noScale";
			//stage.align = "TL";
			
			//with(this.graphics) { beginFill(0xFF00171c); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			
			
			///_context.applicationDomain = ApplicationDomain.currentDomain;

			//_font = new Loader();
			//(_font.contentLoaderInfo).addEventListener(Event.COMPLETE,onComplete);
			//_font.load(new URLRequest("fonts/A1Mincho.swf"),_context);
			
		//}
		
		
		//private function onComplete(e:Event):void {
			var r:int = 0;
			var c:int = 0;
			
			var fmt:TextFormat = new TextFormat();
			fmt.font="A1Mincho"; // AxisStd-Light //"AxisStd-Light"; // Bold
			fmt.size=TEXT_HEIGHT;
			fmt.letterSpacing = 3;
			
			for(var k:int=0; k<MAX_NUM; k++) {
				_words.push("");
				_types.push(false);
				
				_tf.push(new TextField());
				var tf:TextField = _tf[k];
				
				addChild(tf);
				tf.embedFonts = true;
				tf.defaultTextFormat = fmt;
				tf.text = _words[k];
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				//tf.textColor =(k&1)?0x666666:0xFFFFFF;
				tf.textColor = 0x666666;
				tf.x = r;
				tf.y = c;
				r+=tf.textWidth;
				if(r>=WIDTH) {
					r = 0;
					c+=TEXT_HEIGHT;
				}
			}
			
			//this.addEventListener(Event.ENTER_FRAME,onUpdate);
			//addChild(new Stats());
			//addChild(_panel);
			//_panel.x = 50;
			//_panel.y = 400;
			
		}
		
		private var _on:Boolean = false;
		
		public function on($type:Boolean = false):void {
			_on = $type;
			var tf:TextField;
			
			if(_on) {
				for(var k:int=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					tf.textColor = _types[k]?0xFFFFFF:0x666666;
				}
			}
			else {
				for(var k:int=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					tf.textColor = 0x666666;
				}
			}
		}
		
		public function onUpdate(e:Event=null):void {
			
			if(_cnt++>20) {
				_cnt=0;
				
				
				/*
				var offset:int = (int)(10+Math.random()*40);
				
				for(var k=offset; k<MAX_NUM; k++) {
					words[(MAX_NUM-1)-k] = words[(MAX_NUM-1)-k-offset];
				}
				for(var k=0; k<offset; k++) {
					words[k] = (Math.random()>0.5)?"愛知県":"Mexico";
				}
				*/
				
				
				var r:int = 0;
				var c:int = 0;
				var tf:TextField;
				
				for(var k:int=0; k<MAX_NUM; k++) {
					
					tf = _tf[k];
					
					if(c>HEIGHT) {
						tf.visible = false;
					}
					else {
						tf.visible = true;

						if(_on) {
							tf.textColor = _types[k]?0x666666:0xFFFFFF;
						}
						
						tf.text = _words[k];
						tf.selectable = false;
						tf.x = r;
						tf.y = c;
						r+=tf.textWidth+1;
						if(r>=WIDTH) {
							r = 0;
							c+=(TEXT_HEIGHT+5);
						}
					}
				}
			}
			else if(_cnt%5==10) {
				//var tf:TextField
				//for(var k:int=0; k<MAX_NUM; k++) {
					//tf = _tf[k];	
					//tf.textColor = (tf.textColor==0xFFFFFF)?0x666666:0xFFFFFF;
				//}
			}
		}
		
	}
};