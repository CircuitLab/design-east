package {
    
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.media.*;
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
    	private var _types:Vector.<Boolean> = new Vector.<Boolean>(MAX_NUM,true);
    	
    	private var _exTypes:Vector.<Boolean> = new Vector.<Boolean>(MAX_NUM,true);
    	
    	private var _cacheCount:int = 0; 
    	private var _cacheWords:Array = [];
    	private var _cacheTypes:Array = [];
    	
    	private var _timer:int = 0;
    	private var _tf:Vector.<TextField> = new Vector.<TextField>(MAX_NUM,true);    	
    	private var _bar:int = 0;
    	
    	
    	private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		private var _cnt:int = 0;
		
		private var isPlay:Boolean = false;
		
		private var isUpdate:Boolean = false;
    	
    	[Embed(source="recv.mp3")]
		private var RecvSnd:Class;
	    private var _recv:Sound = new RecvSnd();
	
		[Embed(source="swap.mp3")]
		private var SwapSnd:Class;
	    private var _swap:Sound = new SwapSnd();
	
		public override function get width():Number  { return WIDTH; }
		public override function get height():Number { return HEIGHT; }
		
		
		
		public function begin():void {
			isUpdate = false;
			_cacheCount = 0;
			for(var k:int=0; k<_cacheWords.length; k++) {
				_cacheWords[k] = "";
				_cacheTypes[k] = false;
			}	
		}
		
		public function add($word:String,$type:Boolean=false):void {
			
			if(_cacheWords.length<=_cacheCount) {
				_cacheWords.push($word);
				_cacheTypes.push($type);
			}
			else {
				_cacheWords[_cacheCount] = $word;
				_cacheTypes[_cacheCount] = $type;
			}	
			
			_cacheCount++;
		}
		
		public function end():void {
			
			var cnt:int = _cacheCount;
			
			var overflow:int = 0;
			if(cnt>=MAX_NUM) overflow = cnt-MAX_NUM;
			
			var k:int = 0;
			var tmp:int = 0;
			
			if(overflow==0) {	
				for(k=0; k<MAX_NUM-cnt; k++) {
					tmp = (MAX_NUM-1);
					_words[tmp-k] = _words[tmp-k-cnt];
					_types[tmp-k] = _types[tmp-k-cnt];
				}
			}
			
			for(k=overflow; k<cnt; k++) {
				tmp = (cnt-1)-(k-overflow);
				_words[k-overflow] = _cacheWords[tmp];
				_types[k-overflow] = _cacheTypes[tmp];
			}
			
			isUpdate = true;
		}
		
		public function TextFieldManager():void {
			
			with(this.graphics) { beginFill(0xFF00171c); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			
			var r:int = 0;
			var c:int = 0;
			
			var fmt:TextFormat = new TextFormat();
			fmt.font="A1Mincho"; // AxisStd-Light //"AxisStd-Light"; // Bold
			fmt.size=TEXT_HEIGHT;
			fmt.letterSpacing = 3;
			
			for(var k:int=0; k<MAX_NUM; k++) {
				_words[k] = "";
				
				_types[k] = false;
				_exTypes[k] = false;
				
				_tf[k] = new TextField();
				
				var tf:TextField = _tf[k];
				
				
				tf.embedFonts = true;
				tf.defaultTextFormat = fmt;
				tf.text = _words[k];
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.textColor = 0x666666;
				tf.visible = false;
				
				addChild(tf);
			}
			
		}
		
		
		
		
		
		
		public function onUpdate(e:Event=null):void {
			
			//if(_cnt++) _cnt=0;
			//var isPlay:Boolean = true;
			
			isPlay = !isPlay;
			
			var k:int = 0;
			
			var tf:TextField;
				
			
			_timer++;
			if(_timer<30*5) { // 
				
				if(!isPlay) return;
				
				var r:int = -6;
				var c:int = -13;
			
				for(k=0; k<MAX_NUM; k++) {
					
					tf = _tf[k];
					
					if(c>HEIGHT) {
						tf.visible = false;
						tf.text = "";
					}
					else {
						if(tf.textColor!=0x666666) tf.textColor = 0x666666;
							
						if(isUpdate) {
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
				
				
				if(isUpdate) {
					isUpdate = false;
					
					_recv.play();
				}
				
			}
			else if(_timer==30*5) {
				
				this.dispatchEvent(new Event("EXTRACTION"));
				
				_swap.play();
				_bar=150; // reset
				
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					_exTypes[k] = _types[k];
				}
				
				if(!isPlay) return;
				
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor!=0xFFFFFF) tf.textColor += 0x333333;
				}
				
			}
			else if(_timer<30*10) {
			
				if(!isPlay) return;
				
				_bar+=150;
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor!=0xFFFFFF) tf.textColor += 0x333333;
				}
			}
			else if(_timer==30*10) { // fadeout
				this.dispatchEvent(new Event("ACCUMLATION"));
				
				if(!isPlay) return;
				
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor>0x666666) tf.textColor -= 0x333333;
				}
			}
			else if(_timer<30*11) { // fadeout
				
				if(!isPlay) return;
				
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor>0x666666) tf.textColor -= 0x333333;
				}
			}
			else if(_timer==30*11) { // crossfade
				_timer = 0;
			}
		}
	}
};