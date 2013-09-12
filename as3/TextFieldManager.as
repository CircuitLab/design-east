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
    	
    	private var _rect:Rectangle = new Rectangle(0,0,WIDTH,HEIGHT);
    	
    	private var _text:Sprite = new Sprite();
    	private var _fill:Sprite = new Sprite();
    	
    	private var TEXT_HEIGHT:int = 24;
    	
    	private var MAX_NUM:uint = 2048;
    	private var _words:Vector.<String> = new Vector.<String>(MAX_NUM,true);
    	private var _types:Vector.<Boolean> = new Vector.<Boolean>(MAX_NUM,true);
    	
    	private var _keywords:Vector.<String> = new Vector.<String>(MAX_NUM,true);
    	
    	private var _txtStep:int = 0;
    	private var _rowStep:int = 0;
    	private var _colStep:int = 0;
    	
    	private var _exKeywords:Vector.<String> = new Vector.<String>(MAX_NUM,true);
    	private var _exTypes:Vector.<Boolean> = new Vector.<Boolean>(MAX_NUM,true);
    	
    	private var _cacheCount:int = 0;
    	private var _cacheWords:Array = [];
    	private var _cacheTypes:Array = [];
    	
    	private var _timer:int = 0;
    	private var _tf:Vector.<TextField> = new Vector.<TextField>(MAX_NUM,true);    	
    	private var _bar:int = 0;
    	
    	private var _bitmapData:BitmapData = new BitmapData(WIDTH,HEIGHT,false,0x00171c);
		private var _bitmap:Bitmap = new Bitmap(_bitmapData); 
		
    	private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		private var _cnt:int = 0;
		
		private var _tmpTextField:TextField = new TextField();
		
		private var isPlay:Boolean = false;
		private var isUpdate:Boolean = false;
		
		private var _matrix:Matrix = new Matrix();
    	
    	[Embed(source="recv.mp3")]
		private var RecvSnd:Class;
	    private var _recv:Sound = new RecvSnd();
	
		[Embed(source="swap.mp3")]
		private var SwapSnd:Class;
	    private var _swap:Sound = new SwapSnd();
	
		[Embed(source="fall.mp3")]
		private var FallSnd:Class;
	    private var _fall:Sound = new FallSnd();
	
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
			
			
			// update words
			
			var cnt:int = _cacheCount;
			
			var k:int = 0;
			var tmp:int = 0;
			var keywordsCnt:int = 0;
			
			var tmpKeywords:Array = [];
			
			// update keywords
			for(k=0; k<MAX_NUM-cnt; k++) {
				if(_cacheTypes[k])  {
					tmpKeywords.push(_cacheWords[k]);
					keywordsCnt++;
				}
			}
			
			var overflowKeywords:int = 0;
			if(keywordsCnt>=MAX_NUM) overflowKeywords = keywordsCnt-MAX_NUM;
			
			if(overflowKeywords==0) {	
				for(k=0; k<MAX_NUM-keywordsCnt; k++) {
					tmp = (MAX_NUM-1);
					_keywords[tmp-k] = _keywords[tmp-k-keywordsCnt];
				}
			}
			
			for(k=overflowKeywords; k<keywordsCnt; k++) {
				tmp = (keywordsCnt-1)-(k-overflowKeywords);
				_keywords[k-overflowKeywords] = tmpKeywords[tmp];
			}
			
			
			var overflow:int = 0;
			if(cnt>=MAX_NUM) overflow = cnt-MAX_NUM;
			
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
			with(_fill.graphics) { beginFill(0xFF00171c); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			_fill.alpha = 0;
			
			
			var r:int = 0;
			var c:int = 0;
			
			var fmt:TextFormat = new TextFormat();
			fmt.font="A1Mincho"; // AxisStd-Light //"AxisStd-Light"; // Bold
			fmt.size=TEXT_HEIGHT;
			fmt.letterSpacing = 3;
			
			for(var k:int=0; k<MAX_NUM; k++) {
				_words[k] = "";
				_exKeywords[k] = "";
				_keywords[k] = "";
				
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
				
				_text.addChild(tf);
				
				_fill.alpha=1.;
			}
			
			_tmpTextField.embedFonts = true;
			_tmpTextField.defaultTextFormat = fmt;
			_tmpTextField.autoSize = TextFieldAutoSize.LEFT;
			_tmpTextField.textColor = 0xFFFFFF;
			
			addChild(_text);
			addChild(_bitmap);
			_bitmap.visible=false;
			addChild(_fill);
		}
		
		
		public function getTimer():Number { return _timer; }
		
		public function onUpdate(e:Event=null):void {
			
			isPlay = !isPlay;
			
			var k:int = 0;
			
			var tf:TextField;		
			
			_timer++;
			if(_timer<300) { // 150 //  
				
				if(_fill.alpha>=0) {
					_fill.alpha-=0.1;
				}
				
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
			else if(_timer==300) { //150
				
				this.dispatchEvent(new Event("EXTRACTION"));
				
				_swap.play();
				_bar=150; // reset
				
				// copy current data
				
				var looper:int=0;
				
				for(k=0; k<MAX_NUM; k++) {
					//tf = _tf[k];
					_exTypes[k] = _types[k];
					
					if(_keywords[looper]!="") {
						_exKeywords[k] =  _keywords[looper++];
					}
					else {
						looper = 0;
						_exKeywords[k] =  _keywords[looper++];
					}
					
				}
				
				if(!isPlay) return;
				
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor!=0xFFFFFF) tf.textColor += 0x333333;
				}
				
			}
			else if(_timer<500) { // 300
			
				if(!isPlay) return;
				
				_bar+=150;
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor!=0xFFFFFF) tf.textColor += 0x333333;
				}
			}
			else if(_timer<520) { // 330
				if(_fill.alpha<=1) {
					_fill.alpha+=0.1;
				}
			}
			else if(_timer==520) { // 360
				_text.visible = false;
				_fill.visible = false;
				
				(_bitmap.bitmapData).fillRect(_rect,0x00171c);//00171c);
				
				_bitmap.alpha = 1;
				_bitmap.visible = true;
				_bitmap.smoothing = true;
				_txtStep = 0;
    			_rowStep = 0;
    			_colStep = 0;
    			
    			_fall.play();
				
			}
			else if(_timer<720) {  // 480
			
				var bmp:BitmapData = _bitmap.bitmapData;
			
			
				if(_colStep<HEIGHT) {
				
					for(k=0; k<MAX_NUM; k++) {	
						
						// wrap
						if(_txtStep<=(MAX_NUM-1)) {
							_txtStep++;
						}
						else {
							_txtStep = 0;
						}
						
						if(_exKeywords[_txtStep]=="") break;
						
						_tmpTextField.text = _exKeywords[_txtStep];
						
						bmp.draw(_tmpTextField,new Matrix(1,0,0,1,_rowStep-6,_colStep-13));//,_matrix);
					
						_rowStep+=(_tmpTextField.textWidth+2);
						if(_rowStep>=WIDTH) break;
					}
					
					
					_rowStep = 0;
					_colStep+=(TEXT_HEIGHT+5);					
					
				}
			}
			else if(_timer<740) { // 510
				if(_bitmap.alpha>=0) {
					_bitmap.alpha-=0.1;
				}
			}
			else if(_timer==740) { // 540
				this.dispatchEvent(new Event("ACCUMLATION"));
				
				for(k=0; k<MAX_NUM; k++) {
					tf = _tf[k];
					if(_exTypes[k]&&(tf.x<=_bar)&&tf.textColor>0x666666) tf.textColor = 0x666666;
				}
				
				_fill.visible = true;
				_text.visible = true;
				_bitmap.visible = false;
				
				_timer = 0;
				_recv.play();
			}
		}
	}
};