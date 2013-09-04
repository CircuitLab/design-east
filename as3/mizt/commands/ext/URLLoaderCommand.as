package commands.ext
{
	import commands.CommandBase;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/*
	 * URLLoaderをCommandでラップしたもの。
	 * 
	 * paramObjectには以下のパラメーターを渡すことで柔軟に行動を指定できます。
	 * 
	 * url:String ロード先のURLを直接指定する場合
	 * request:URLRequest urlRequestを渡す場合
	 * urlScope:*, urlProp:String 特定のオブジェクトのプロパティを遅延評価で渡す場合
	 * 
	 * loader:URLLoader 任意のURLLoaderを使う場合。指定しない場合はCommand内で自前でURLLoaderが作られる。
	 * dataFormat 自動作成されるURLLoaderで用いられるデータフォーマット。ディフォルトはURLLoaderDataFormat.TEXT
	 *
	 * urlVariables: URLVariablesによる変数指定があるならここで渡せる
	 * method: URLRequestMethod.GET or URLRequestMethod.POST
	 *
	 * ignoreIOError	Boolean IOErrorがでた場合もそのまま処理をすすめるフラグ
	 * ignoreCache		Boolean 乱数をGETで送信してキャッシュを無効にするフラグ。キャッシュブレイカーの挙動については検証すること！！
	 * ignoreInvalidVariables	dataFormatにURLLoaderDataFormat.VARIABLESを指定してかつ、取得したデータが不正なデータだった場合、エラーを起こすか、空のオブジェクトを返すか
	 *
	 *
	 * parser : Function	独自のパース関数を使いたい場合、関数にURLLoader.dataが渡されるので加工後にreturnしてください。ない場合はprotectedのformatData関数が呼ばれます。
	 * 
	 * dataScope:*, dataProp:String URLLoaderで取得したデータを、特定のオブジェクトのプロパティに代入する場合
	 */
	public class URLLoaderCommand extends CommandBase{
		
		protected var paramObj:Object
		protected var loader:URLLoader
		
		public function URLLoaderCommand( paramObj:Object ){
			super();
			this.paramObj = paramObj;
		}
		
		
		override public function execute():void{
			var req:URLRequest = buildRequest();
			
			loader = buildURLLoader();
			loader.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler, false, 0, true);
			loader.load(req);

			loader.data = 5;
		}
		
		
		protected function _ioErrorHandler(e:IOErrorEvent):void
		{
			trace("URLLoaderCommand._ioErrorHandler IOErrorが発生しました");
			removeListeners();
			
			if(paramObj.ignoreIOError){
				paramObj = null;
				loader = null;
			
				dispatchComplete();
			}else{
				throw new Error("URLLoaderCommand._ioErrorHandler");
			}
		}
		
		
		//event handler for URLLoader
		protected function _completeHandler(e:Event):void{
			removeListeners();
			
			var data:Object = loader.data;
			
			if(paramObj.dataFormat==URLLoaderDataFormat.VARIABLES)
			{
				var val:URLVariables = new URLVariables();
				try{
					val.decode(String(data));
					data = val;
				}catch(e:Error){
					if(paramObj.ignoreInvalidVariables==true)
					{
						data = {};
					}else{
						throw new Error("取得したVariablesをパースできません");
					}
				}
			}
			
			if(paramObj.dataScope && paramObj.dataProp){
				if(paramObj.parser){
					paramObj.dataScope[paramObj.dataProp] = paramObj.parser(data);
				}else{
					paramObj.dataScope[paramObj.dataProp] = formatData(data);
				}
			}
				
			
			paramObj = null;
			loader = null;
			
			dispatchComplete();
		}
		
		
		protected function removeListeners():void
		{
			loader.removeEventListener(Event.COMPLETE, _completeHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
		}
		
		
		//creates UrlRequest from paramObj
		protected function buildRequest():URLRequest
		{
			var req:URLRequest
			if( paramObj.url ){
				req = new URLRequest(paramObj.url);
			}else if( paramObj.request ){
				req = paramObj.request;
			}else if( paramObj.urlScope && paramObj.urlProp ){
				req = new URLRequest( paramObj.urlScope[paramObj.urlProp] );
			}
			
			if( paramObj.method)
				req.method = paramObj.method;
				
			if( paramObj.urlVariables){
				if(paramObj.ignoreCache)
					paramObj.urlVariables.rnd = new Date().getTime();
				
				req.data = paramObj.urlVariables;
			}
			
			//GETでない場合のCacheBreakerを追加
			if( !paramObj.urlVariables){
				if(paramObj.ignoreCache)
					req.url = req.url + "?rnd=" + new Date().getTime();
			}
			
			return req;
		}
		
		
		//creates URLLoader from paramObj
		protected function buildURLLoader():URLLoader
		{
			var loader:URLLoader
			if( paramObj.loader ){
				loader = paramObj.loader;
			}else{
				loader = new URLLoader();
				
				if(paramObj.dataFormat==URLLoaderDataFormat.BINARY)
				{
					loader.dataFormat = URLLoaderDataFormat.BINARY;
				}else{
					loader.dataFormat = URLLoaderDataFormat.TEXT;
				}
				
				/*
				//
				if(paramObj.dataFormat){
					loader.dataFormat = paramObj.dataFormat;
				}else{
					loader.dataFormat = URLLoaderDataFormat.TEXT;
				}*/
			}
			return loader;
		}
		
		
		//formats data used before property injection
		protected function formatData(data:*):* { return data; }
	}
}