package mizt.commands {
	import mizt.Mizt;
	
	/**
	 * 「指定したミリ秒待機する」コマンド.
	 * 
	 * <p>SerialCommandやParallelCommand等のバッチ処理系のコマンドにインターバルを挟む為に用います。</p>
	 * 
	  * @example 以下はWaitCommandクラスの基本的な使い方です。この例では関数executeを実行して1秒後に、Event.COMPLETEが発行されます。
	 * <listing version="3.0">
	 * var command:ICommand = new WaitCommand(1000);
	 * command.addEventListener(Event.COMPLETE, function():void{
	 * 		trace("Command Completed");
	 * });
	 * CommandContainer.execute( command );</listing>
	 * 
	 * @example この例ではSerialCommandを用いて１秒待った後に文字列を表示しています。
	 * <listing version="3.0">
	 * var serial:SerialCommand = new SerialCommand();
	 * serial.push( new WaitCommand( 1000 ));
	 * serial.push( new Command( null, trace, "Hello World" );
	 * 
	 * CommandContainer.execute( serial );</listing>
	 * 
	 * @see commands.SerialCommand
	 * @see commands.ParallelCommand
	 * @see commands.CommandContainer
	 */
	public class WaitCommand extends CommandBase {
		//protected var _timer:Timer
		protected var _delay:Number;
		protected var _timer:Number;
		
		// 待ち時間の秒。
		public function WaitCommand($delay:Number=1) {
			super();
			_delay=$delay;
		}
		
		protected function update(_step:Number):void {
			//trace("update : "+_timer);
			_timer+=_step;
			if(_timer>_delay) {
				(Mizt.getInstance()).removeEnterFrame(this.update);
				_timer = 0;
				this.dispatchComplete();
			}
		} 

		override public function execute():void {
			_timer = 0;
			(Mizt.getInstance()).addEnterFrame(this.update);
		}
	}
};