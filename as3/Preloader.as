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
		
		private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		
		private var WIDTH:int = 1280;
		private var HEIGHT:int = 800;
		
		//private var _bitmapData:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0xFF00171c);
		//private var _bitmap:Bitmap = new Bitmap(_bitmapData); 
		
		private var _text:TextFieldManager = new TextFieldManager();
		private var _panel:Panel;
		
		private var _progress:Sprite = new Sprite();
		
		public static function getClass(str:String):Class { return Class(ApplicationDomain.currentDomain.getDefinition(str));}
		public static function getQuery($str:String):String { return (ExternalInterface.available)?(ExternalInterface.call("function() { var q=location.search.slice(1); if(q.indexOf('"+$str+"=')==0) { var q = q.replace('"+$str+"=',''); } else{ q=''; } return q; }")):(""); }
        	
		public function Preloader():void {	
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			_context.applicationDomain = ApplicationDomain.currentDomain;

			_font = new Loader();
			(_font.contentLoaderInfo).addEventListener(Event.COMPLETE,onComplete);
			(_font.contentLoaderInfo).addEventListener (ProgressEvent.PROGRESS,onProgress);
			_font.load(new URLRequest("fonts/A1Mincho.swf"),_context);
			
			addChild(_progress);
		}
		
		private function onProgress(e:ProgressEvent):void {
			_progress.graphics.clear();
			_progress.graphics.lineStyle(0,0xFFFFFF);
			_progress.graphics.moveTo(0,stage.stageHeight>>1);
			_progress.graphics.lineTo(stage.stageWidth*(e.bytesLoaded/e.bytesTotal),stage.stageHeight>>1);
			
		}
		
		
		private function onResize(e:Event=null):void {
			
			
			with(this.graphics) { clear(); beginFill(0xFF00171c); drawRect(0,0,stage.stageWidth,stage.stageHeight); endFill(); }
			
			
			var _x:Number = stage.stageWidth/_text.width;
			var _y:Number = stage.stageHeight/_text.height;
			
			if(_x>_y) {
				_text.scaleX = _x;
				_text.scaleY = _x;
				_text.x = 0;
				_text.y = (stage.stageHeight-(_text.height*_text.scaleY))>>1;
			}
			else {
				_text.scaleX = _y;
				_text.scaleY = _y;
				_text.x = (stage.stageWidth-(_text.width*_text.scaleX))>>1;;
				_text.y = 0;
			}
			
			_panel.x = 50;
			_panel.y = (stage.stageHeight-_panel.height)>>1;
			
			_credit.x = 22;
			_credit.y = stage.stageHeight-35;
			
		}
		

		private var japanes:RegExp = /[ぁ-ん一-龠ァ-ヾー]/g;
		private var kanji:RegExp   = /[一-龠]/g;
		private var number:RegExp   = /[0-9]/g;
		
		private var english:Array = [
			"topophilia",
			"design",
			"east",
			"designeast",
			"anne",
			"mieke",
			"eggenkamp",
			"kirstie",
			"van",
			"noort",
			"itay",
			"ohaly",
			"thomas",
			"vailly",
			"kunlé",
			"adeyemi",
			"nlé",
			"tokyo",
			"mom",
			"oy",
			"arnout",
			"visser",
			"beyer",
			"pyjamammal",
			"aom",
			"neve",
			"ui",
			"nono",
			"fantastic",
			"market",
			"market",
			"omomma"
		]; 
		
		private function on($arr:Array):void {
			//trace($arr);
			var len:int = $arr.length;
			
			_text.begin();
			
			
			for(var k:int=0; k<len; k++) {
			
				var uid:int = (len-1)-k;
				//trace($arr[k][7]);
				var cache:Array = $arr[uid];
				var tmp:String = cache[0];
				//var tmp:String = $arr[k][1];
				if(tmp!=="*") {
					
					var key:Boolean = false;
					
					if((cache[1]=="名詞")) {
					
						
						if(tmp.length==1&&tmp=="/") {
							if(uid-1>=0&&uid+1<len&&(($arr[uid-1][0].search(number)>=0))&&(($arr[uid+1][0].search(number)>=0))) {
								key = true;
							}
						}
						else if(tmp.length==1&&tmp.search(kanji)>=0) {
							key = false;
							if(tmp=="時") key = true;
							else if(tmp=="分") key = true;
							else if(tmp=="前") key = true;
							else {
								// どちらかが感じなら true に
								
							}
						}
						else if(tmp.search(japanes)>=0) {
							
							
							if(tmp.length==1&&tmp=="の") {	
								if(uid-4>=0&&uid+3<len) {
									if($arr[uid-4][0]=="ファッション"&&$arr[uid-3][0]=="は"&&$arr[uid-2][0]=="更新"&&$arr[uid-1][0]=="できる"&&$arr[uid+1][0]=="か"&&$arr[uid+2][0]=="?"&&$arr[uid+3][0]=="会議") key = true;
									else if($arr[uid-4][0]=="ファッション"&&$arr[uid-3][0]=="は"&&$arr[uid-2][0]=="更新"&&$arr[uid-1][0]=="できる"&&$arr[uid+1][0]=="か"&&$arr[uid+2][0]=="？"&&$arr[uid+3][0]=="会議") key = true;
								}
							}
							if(tmp.length<=3&&tmp.search(kanji)==-1) {
								key = false;
							}
							else {
								key = true;
							}
						}
						else {
							var lowercase:String = tmp.toLowerCase();
							
							if(lowercase=="04"&&(uid-1>=0)&&($arr[uid-1][0].toLowerCase()=="designeast")) {
								key = true;
							}
							if(lowercase=="?"&&(uid-6>=0)&&(uid+1<len)) {
								if($arr[uid-6][0]=="ファッション"&&$arr[uid-5][0]=="は"&&$arr[uid-4]=="更新"&&$arr[uid-3][0]=="できる"&&$arr[uid-2][0]=="の"&&$arr[uid-1][0]=="か"&&$arr[uid+1][0]=="会議") key = true;
							}
							else if(tmp.length==1) {
								if(lowercase=="c"&&(uid+1<len)&&($arr[uid+1][0].toLowerCase()=="-")) key = true;
								else if(lowercase=="-"&&(uid-1>=0)&&($arr[uid-1][0].toLowerCase()=="c")) key = true;
							}
							else {
								for(var e:int=0; e<english.length; e++) {
									if(lowercase==english[e]) {
										key = true;
									}
								}
								
								if(lowercase=="designeast") {
									if((uid-1>=0)&&[uid-1][0]=="@") key = false;
									if((uid+1>=0)&&[uid+1][0]==".") key = false;
								}
							}
						}
					}
					else if(cache[1]=="助詞") {
					
						if(tmp=="と") {
							if(uid-1>=0&&uid+1<len) {
								if($arr[uid-1][0]=="良平"&&$arr[uid+1][0]=="仕事") {
									key = true;
								}
								else if($arr[uid-1][0]=="吉行良平"&&$arr[uid+1][0]=="仕事") {
									key = true;
								}
								else if(($arr[uid-1]=="みそしる")&&$arr[uid+1][0]=="MC") {
									key = true;
								}
								else if(uid-2>=0&&$arr[uid-2][0]=="みそ"&&$arr[uid-1][0]=="しる"&&$arr[uid+1][0]=="MC") {
									key = true;
								}
							}
						}
						else if(tmp=="へ") {
							if(uid-1>=0&&uid+2<len&&$arr[uid-1][0]=="場"&&$arr[uid+1][0]=="の"&&$arr[uid+2][0]=="愛") key = true;
						}
						else if(tmp=="の") {
							if(uid-2>=0&&uid+1<len&&$arr[uid-2][0]=="場"&&$arr[uid-1][0]=="へ"&&$arr[uid+1][0]=="愛") key = true;
							
						}
						else if(tmp=="か") {
							if(uid-4>=0&&uid+2<len) {
								if($arr[uid-5][0]=="ファッション"&&$arr[uid-4][0]=="は"&&$arr[uid-3][0]=="更新"&&$arr[uid-2][0]=="できる"&&$arr[uid-1][0]=="の"&&$arr[uid+1][0]=="?"&&$arr[uid+2][0]=="会議") key = true;
								else if($arr[uid-5][0]=="ファッション"&&$arr[uid-4][0]=="は"&&$arr[uid-3][0]=="更新"&&$arr[uid-2][0]=="できる"&&$arr[uid-1][0]=="の"&&$arr[uid+1][0]=="？"&&$arr[uid+2][0]=="会議") key = true;
							}
						}
						else if(tmp=="は") {
							if(uid-1>=0&&uid+6<len) {
								if($arr[uid-1][0]=="ファッション"&&$arr[uid+1][0]=="更新"&&$arr[uid+2][0]=="できる"&&$arr[uid+3][0]=="の"&&$arr[uid+4][0]=="か"&&$arr[uid+5][0]=="?"&&$arr[uid+6][0]=="会議") key = true;
								else if($arr[uid-1][0]=="ファッション"&&$arr[uid+1][0]=="更新"&&$arr[uid+2][0]=="できる"&&$arr[uid+3][0]=="の"&&$arr[uid+4][0]=="か"&&$arr[uid+5][0]=="？"&&$arr[uid+6][0]=="会議") key = true;
							}
						}
					}
					else if(cache[1]=="動詞") {
						if(tmp=="できる") {
							if(uid-3>=0&&uid+4<len) {
								if($arr[uid-3][0]=="ファッション"&&$arr[uid-2][0]=="は"&&$arr[uid-1][0]=="更新"&&$arr[uid+1][0]=="の"&&$arr[uid+2][0]=="か"&&$arr[uid+3][0]=="?"&&$arr[uid+4][0]=="会議") key = true;
								else if($arr[uid-3][0]=="ファッション"&&$arr[uid-2][0]=="は"&&$arr[uid-1][0]=="更新"&&$arr[uid+1][0]=="の"&&$arr[uid+2][0]=="か"&&$arr[uid+3][0]=="？"&&$arr[uid+4][0]=="会議") key = true;
							}
						}
					}
					else if(cache[1]=="記号") {
						if(tmp=="々"&&uid-1>=0&&uid+1<len) {
							if($arr[uid-1][0]=="柳"&&$arr[uid+1][0]=="堂") {
								key = true;
							}
						}
						else if(tmp=="？"&&uid-6>=0&&uid+1<len) { // 
							if($arr[uid-6][0]=="ファッション"&&$arr[uid-5][0]=="は"&&$arr[uid-4][0]=="更新"&&$arr[uid-3][0]=="できる"&&$arr[uid-2][0]=="の"&&$arr[uid-1][0]=="か"&&$arr[uid+1][0]=="会議") key = true;
						}
					}
					
					
					if(cache[2]=="数") {
						key = true;
						
						if(tmp=="04") {
							if(uid-2>=0) {
								//key = true;
								if($arr[uid-2][0]=="#") key = false;
								else if($arr[uid-2][0]=="@") key = false;
							}
						}
						else if((uid-1>=0&&($arr[uid-1][0].search(japanes)>=0))||(uid+1<len&&($arr[uid+1][0].search(japanes)>=0))) {
							key = true;
						}
						
					}
					
					_text.add(tmp,(key)?true:false);
					
				}
			}
			
			
			_text.end();
				
				
		}
		
		private function onAccumlation(e:Event):void {
			_panel.on(true);
		}
		
		private function onExtraction(e:Event):void {
			_panel.on(false);
		}
		
		
		private function onUpdate(e:Event):void {
			_text.onUpdate();
		}
			
		private function onComplete(e:Event):void {
			
			_progress.graphics.clear();
			_progress.graphics.lineStyle(0,0xFFFFFF);
			_progress.graphics.moveTo(0,stage.stageHeight>>1);
			_progress.graphics.lineTo(stage.stageWidth,stage.stageHeight>>1);
			
			Mizt.addTween(_progress,{time:0.5,alpha:0,onComplete:onLoaded})	
		}
		
		private function onLoaded():void {
			trace("onComplete");
			_progress.graphics.clear();
			removeChild(_progress);
			
			
			addChild(_text);
			_text.addEventListener("ACCUMLATION",onAccumlation);
			_text.addEventListener("EXTRACTION",onExtraction);
			
			addChild(_credit);
			_credit.x = 22;
			_credit.y = stage.stageHeight - 35;
			
			var day:String = getQuery("day");
			
			if(day=="2") {
				_panel = new Panel(2);
			}
			else if(day=="3") {
				_panel = new Panel(3);
			}
			else {
				_panel = new Panel(1);
			}			
			
			addChild(_panel);
			_panel.x = 50;
			_panel.y = (stage.stageHeight-_panel.height)>>1;
			
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
			
			addChild(new Stats());
			
			ExternalInterface.addCallback("emit",on);
			ExternalInterface.call("de04.intialize");
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
			
		}
	}
};