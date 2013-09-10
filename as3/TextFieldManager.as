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
    	private var _words:Vector.<String> = new Vector.<String>(MAX_NUM,true);
    	private var _cache:Vector.<String> = new Vector.<String>(MAX_NUM,true);
    	
    	private var _types:Vector.<Boolean> = new Vector.<Boolean>(MAX_NUM,true);
    	private var _tf:Vector.<TextField> = new Vector.<TextField>(MAX_NUM,true);
    	
    	private var _bar:int = 0;
    	
    	//private var _panel:Panel = new Panel(1);
    	
    	private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		private var _cnt:int = 0;
		
		
		public function add($word:String,$type:Boolean=false):void {
			
			isUpdate = true;
			
			for(var k:int=0; k<MAX_NUM-1; k++) {
			
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
				_words[k] = "";
				_types[k] = false;
				
				_tf[k] = new TextField();
				
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
				this.add("あ",(Math.random()>0.5)?true:false);
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
				_bar = 0;
				for(var k:int=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					tf.textColor = 0x666666;
					_cache[k] = _words[k];
					
					tf.text = _cache[k];
					
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
			
			if(_on) {
				_bar+=100;
			}
			
			if(_cnt++) {
				_cnt=0;
				/*
				if(_on) {
					_blink++;
					_off = false;
					if(_blink>=2&&_blink<=4) {
						_off = true;
					}
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
						
						
						if(_on&&_types[k]&&(tf.x<=_bar)) {
							if(tf.textColor!=0xFFFFFF) {
								tf.textColor += 0x333333;
							}
						}
						else {
							if(tf.textColor!=0x666666) {
								tf.textColor = 0x666666;
							}
						}
						
						if(!_on&&isUpdate) {
							tf.x = r;
							tf.y = c;
							
							tf.text = _words[k];
							
							r+=tf.textWidth+2;
							if(r>=WIDTH) {
								r = -6;
								c+=(TEXT_HEIGHT+5);
							}
						}
						
						if(!tf.visible) tf.visible = true;
						
					}
				}
				
				if(!_on) isUpdate = false;
			}
			
			
			
		}
		
	}
};