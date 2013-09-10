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
		
		//private var _text:TextField;
		private var _font:Loader;
		private var _context :LoaderContext = new LoaderContext();
		
		private var WIDTH:int = 1280;
		private var HEIGHT:int = 800;
		
		private var _bitmapData:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0xFF00171c);
		private var _bitmap:Bitmap = new Bitmap(_bitmapData); 
		
		private var _text:TextFieldManager = new TextFieldManager();
		private var _panel:Panel;
		
		//private var _dotBitmapData:BitmapData = new BitmapData(2,2,true,0xFF00171c);
		//private var _dots:Sprite = new Sprite();
		//private var _dotbitmapData:BitmapData = new BitmapData(1024,768,true,0xFF000000);
		//private var _dotbitmap:Bitmap = new Bitmap(_dotbitmapData); 
		
		private var _overlay:Sprite = new Sprite();
		
		private var _type:Boolean = false;
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
			with(_fill.graphics) { beginFill(0x00171c); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			
			with(_overlay.graphics) { beginFill(0x0,0.5); drawRect(0,0,WIDTH,HEIGHT); endFill(); }
			
			_context.applicationDomain = ApplicationDomain.currentDomain;

			_font = new Loader();
			(_font.contentLoaderInfo).addEventListener(Event.COMPLETE,onComplete);
			_font.load(new URLRequest("fonts/A1Mincho.swf"),_context);
			
			/*
			stage.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void {			
				
				var value:int = Math.random()*10000;
				_text.begin();
				
				for(var i:int=0; i<value; i++) {
					_text.add(""+(int)(i)+".",(Math.random()>0.5)?true:false);
				}
				_text.end();
			});
			*/
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
			"market"		
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
		
		//private var dir:Number = 1;
		private var dir:Number = 1;
		
		private function onUpdate(e:Event):void {
			_text.onUpdate();
			//_fill.alpha = Math.random();
		
			
			
			if(_counter++>30*5) {
				_counter = 0;
				_type =!_type;
				_text.on(_type); 
				_panel.on(_type);
				
				_fill.visible = false;
				
			}
			
			/*
			if(_fill.visible = true) {
			if(_counter%2==0) {
				_fill.alpha+=0.2*dir;
					if(_fill.alpha>1) {
						_fill.alpha = 1;
						dir = -1;
					}
					if(_fill.alpha<0) {
						_fill.alpha = 0;
						dir = 1;
					}
			
				}
			}
			*/
			
			
			//_bitmap.draw();
		
			//_bitmap.alpha -= 0.1;
			//if(_bitmap.alpha==0) _bitmap.alpha=0;
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
			

			
			addChild(_text);
			addChild(_fill);
			_fill.visible = false;
			
			
			addChild(_bitmap);
			_bitmap.visible = false;
			
			//_dotBitmapData.setPixel32(0,0,0x33000000);
			//_dotBitmapData.setPixel32(1,1,0x99000000);
			//addChild(_bitmap);
			
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
			_panel.y = (800-_panel.height)>>1;
			
			addChild(_overlay);
			_overlay.visible = false;
			
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
			
			addChild(new Stats());
			
			ExternalInterface.addCallback("emit",on);
			ExternalInterface.call("de04.intialize");
			
		}
	}
};