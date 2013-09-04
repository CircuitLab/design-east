package commands.ext
{
	import commands.CommandBase;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * XMLを返す、URLLoaderCommandの拡張。
	 * 
	 * XMLにデータを変換する為には、URLLoaderのdataFormatがテキストであるように注意すること。
	 */
	public class XMLLoaderCommand extends URLLoaderCommand
	{
		public function XMLLoaderCommand(paramObj:Object)
		{
			super(paramObj);
		}
		
		// dataConversion
		override protected function formatData(data:*):*
		{
			return new XML(data);
		}
	}
}