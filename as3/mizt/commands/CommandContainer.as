package commands
{
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	/**
	 * 実行中の非同期コマンドがガベージコレクトされないよう、参照を保持するクラス.
	 * 
	 * SerialCommand, ParallelCommand, AsyncCommandなど非同期のコマンドが、実行中にガベージコレクションされるのを防ぐのに用いられます。
	 * 実行終了後、CommandContainerに格納されたICommandインスタンスへの参照は開放されます。
	 * 
	 * @example 以下の例ではSerialCommandを実行し、その終了までSerialCommandの参照を保持します。
	 * <listing version="3.0">
	 * var serialCommand = new SerialCommand([
	 *   new Command(null, trace, ["test"]);
	 *   new WaitCommand(10000);
	 *   new Command(null, trace, ["test"]);
	 * ])
	 * 
	 * CommandContainer.execute( serialCommand );
	 * </listing>
	 */
	public class CommandContainer {
		protected static var _commandDict:Dictionary
		protected static var _numCommands:int = 0;
		
		/**
		 * 引数として渡したICommandを実行し、処理が終了するまで参照を保持します。
		 * 
		 * コマンドの終了時、CommandContainer内に保持された参照は破棄されます。
		 */
		public static function execute(command:ICommand):void {
			if(_commandDict==null) _commandDict = new Dictionary();	
			if(_commandDict[command]){ throw new Error("CommandContainer.execute() this command is alrealdy registerd"); }
			_commandDict[command] = command;
			_numCommands++;
			command.addEventListener(Event.COMPLETE, executeHandler);
			command.execute();
		}
		
		
		//デバッグ用、現在実行中のコマンドの数を返す。
		public static function get numCommands():int { return _numCommands; }

		//デバッグ用、現在実行中のコマンドをダンプする。
		public static function dump():void {
			for (var prop:* in _commandDict) trace(_commandDict[prop]);
		}
		//コマンドの終了のハンドリング。
		//終了したコマンドのリスナ解除と、参照の廃棄を行う。
		protected static function executeHandler(e:Event):void {
			var command:ICommand = ICommand(e.target);
			command.removeEventListener(Event.COMPLETE, executeHandler);
			_numCommands--;
			//すぐ消さないずに１フレームぐらい待ったほうがいいのか？？
			_commandDict[command] = null;
			delete _commandDict[command];
		}
	}
}