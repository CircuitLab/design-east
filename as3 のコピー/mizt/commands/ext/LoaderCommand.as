package commands.ext
{
	import commands.CommandBase;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;

	/*
	LoaderクラスをCommand化したもの。
	引数に渡すparamObjで多様な使い方を指定できる。
	
	url:String
	request:URLRequest
	urlScope:Object, urlProp:String
	
	bytes:ByteArray バイトコードからロードする場合
	
	alternativeURL:String 代替イメージのURL
	
	loader:Loader
	loaderScope:Object, loaderProp:String
	*/
	public class LoaderCommand extends CommandBase
	{
		protected var paramObj:Object
		protected var loader:Loader
		
		public function LoaderCommand(paramObj:Object)
		{
			this.paramObj = paramObj;
		}
		
		override public function execute():void
		{
			var req:URLRequest = this.buildURLRequest();
			loader = this.buildLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler, false, 0, true);
			
			if(paramObj.bytes != undefined){
				loader.loadBytes(paramObj.bytes);
			}else{
				loader.load(req);
			}
		}
		
		
		//eventHandler for Loader
		protected function _completeHandler(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
			
			paramObj = null;
			loader = null;
			this.dispatchComplete();	
		}
		
		protected function _ioErrorHandler(e:Event):void
		{
			trace("irerror", paramObj.url);
			if(paramObj.alternativeURL){
				loader.load(new URLRequest(paramObj.alternativeURL));
			}else{
				_completeHandler(e);
			}
		}
		
		
		protected function buildURLRequest():URLRequest
		{
			var req:URLRequest
			if( paramObj.url ){
				req = new URLRequest(paramObj.url);
			}else if( paramObj.request ){
				req = paramObj.request;
			}else if( paramObj.urlScope && paramObj.urlProp ){
				req = new URLRequest( paramObj.urlScope[paramObj.urlProp] );
			}
			return req;
		}
		
		
		/*
			・loaderプロパティによりローダーが渡されている場合、それを使用する。
			・loaderScopeとloaderPropが指定されている場合、loaderScope[loaderProp]にあるLoaderを使用する
			・loaderScopeとloaderPropが指定されているがLoaderがない場合、loaderScope[loaderProp]にLoaderを作成し使用する
			・一切の指定のない場合、command内でloaderを作成する。
		*/
		protected function buildLoader():Loader
		{
			if( paramObj.loader){
				loader = paramObj.loader;
			}else if( paramObj.loaderScope && paramObj.loaderProp ){
				if(paramObj.loaderScope[paramObj.loaderProp]==null || paramObj.loaderScope[paramObj.loaderProp]==undefined){
					paramObj.loaderScope[paramObj.loaderProp] = new Loader();
				}
				
				loader = paramObj.loaderScope[paramObj.loaderProp]
			}else{
				loader = new Loader();
			}
			
			return loader;
		}
	}
}