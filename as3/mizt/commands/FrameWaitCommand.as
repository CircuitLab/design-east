package commands
{
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	/**
	 * 「指定フレーム待つ」コマンド.
	 * 
	 * <p>WaitCommandのonEnterFrame版です。指定フレーム数経過したらEvent.COMPLETEを発行します。</p>
	 * 
	 * <p>WaitCommandの使用する為には初期化が必要です。初回クラス使用時の前にあらかじめ<code>WaitCommand.init</code>を呼び出してください。</p>
	 * 
	 * @see commamds.WaitCommand
	 */
	public class FrameWaitCommand extends CommandBase
	{
		protected var count:int
		
		//onEnterFrameを受信する為に、enterFrameを発信できるクラスを渡す必要がある
		public static var enterFrameBeacon:IEventDispatcher
		
		public function FrameWaitCommand( count:int )
		{
			this.count = count;
		}
		
		/**
		 * WaitCommandがEvent.ENTER_FRAMEを受け取れるように初期化します.
		 * 
		 * 初回使用時の前に必ず呼び出してください。
		 * 
		 * @params stage ステージの参照
		 */
		public static function init( stage:Stage ):void
		{
			enterFrameBeacon = stage;	
		}
		
		override public function execute():void
		{
			if(!enterFrameBeacon)
				throw new Error("FrameWaitCommand.init should be called before first execution.");
			enterFrameBeacon.addEventListener(Event.ENTER_FRAME, _enterFrameHandler, false, 0, true);
		}
		
		
		protected function _enterFrameHandler(e:Event):void
		{
			if(count<=0) this.dispatchComplete();
			count--;
		}
	}
}