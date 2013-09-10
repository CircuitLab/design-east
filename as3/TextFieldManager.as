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
    
    	private var WIDTH:int  = 1280;
    	private var HEIGHT:int = 800;
    	
    	private var TEXT_HEIGHT:int = 24;
    	
    	private var MAX_NUM:uint = 2048;
    	private var _words:Array = [];
    	private var _cache:Array = []; // cache
    	
    	private var _types:Array = [];
    	private var _tf:Array = [];
    	
    	//private var _panel:Panel = new Panel(1);
    	
    	private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		private var _cnt:int = 0;
		
		
		public function add($word:String,$type:Boolean=false):void {
			
			isUpdate = true;
			
			for(var k:int=1; k<MAX_NUM; k++) {
			
				var tmp:int = (MAX_NUM-1)-k;
				_words[tmp] = _words[tmp-1];
				_types[tmp] = _types[tmp-1];
				
			}
			
			_words[0] = $word;
			_types[0] = $type;
			/*
			var tf:TextField;
			for(var k:int=0; k<MAX_NUM; k++) {
				tf = _tf[k];
				tf.text = _words[k];
			}
			*/
		}
		
		
		public function TextFieldManager():void {
		
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
				tf.textColor = 0x666666;
				tf.visible = false;
			}
			
			
			for(var i:int=0; i<MAX_NUM; i++) {
				this.add("あ");
			}
		}
		
		private var _on:Boolean = false;
		private var _off:Boolean = false;
		private var _blink:int = 0;
		
		private var isUpdate:Boolean = false;
		
		public function on($type:Boolean = false):void {
		
			
			
			_on = $type;
			_blink=0;
			var tf:TextField;
			
			if(_on) { // lock
				
				for(var k:int=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					tf.textColor = _types[k]?0xFFFFFF:0x666666;
					_cache[k] = _words[k];
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
			
			
			
			if(_cnt++>6) {
				_cnt=0;
				
				if(_on) {
					_blink++;
					_off = false;
					if(_blink>=2&&_blink<=4) {
						_off = true;
					}
				}
				/*
				var offset:int = (int)(10+Math.random()*40);
				
				for(var k=offset; k<MAX_NUM; k++) {
					words[(MAX_NUM-1)-k] = words[(MAX_NUM-1)-k-offset];
				}
				for(var k=0; k<offset; k++) {
					words[k] = (Math.random()>0.5)?"愛知県":"Mexico";
				}
				*/
				
				
				var r:int = -6;
				var c:int = -13;
				var tf:TextField;
				
				//if(isUpdate==false) return;			
				//isUpdate = false;
				
				for(var k:int=0; k<MAX_NUM; k++) {
					
					tf = _tf[k];
					
					if(_words[k]==""||c>HEIGHT) {
						tf.visible = false;
					}
					else {
						tf.visible = true;

						if(_on&&!_off) {
							tf.textColor = (Math.random()>0.5)?0xFFFFFF:0x666666;
						}
						tf.text = (_on)?_cache[k]:_words[k];
						tf.x = r;
						tf.y = c;
						r+=tf.textWidth+2;
						if(r>=WIDTH) {
							r = -6;
							c+=(TEXT_HEIGHT+5);
						}
					}
				}
			}
			//else if(_cnt%5==10) {
				//var tf:TextField
				//for(var k:int=0; k<MAX_NUM; k++) {
					//tf = _tf[k];	
					//tf.textColor = (tf.textColor==0xFFFFFF)?0x666666:0xFFFFFF;
				//}
			//}
		}
		
	}
};