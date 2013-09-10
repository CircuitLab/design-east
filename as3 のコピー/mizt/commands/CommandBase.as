package mizt.commands {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 全てのコマンドの基底クラス.
	 * 
	 * <p>このクラスが直接使われることはありません。独自のコマンドを作成する場合には、このクラスを継承してください。</p>
	 */
	public class CommandBase extends EventDispatcher implements ICommand
	{
		/**
		 * コマンドとして定義された処理を実行します.
		 * 
		 * <p>この関数はテンプレート関数です。実際の実装はサブクラスで行われます。</p>
		 * <p>サブクラスの実装ではexecuteによって行われる全ての処理の終了時に、関数dispatchComplete()を呼び出してください。</p>
		 */
		public function execute():void
		{
			//ここに実行したい処理を書く
			
			//すべての処理が終了したらこいつを呼ぶ
			dispatchComplete();
		}
		
		
		/**
		 * この関数は将来の拡張の為に予約されています。.
		 */
		public function cancel():void{

		}
		
		
		/**
		 * コマンドの終了を通知する為に、Event.COMPLETEを発行します.
		 * 
		 * <p>CommandBaseのサブクラスでは、execute()で実行する処理の終了時には、
		 * 明示的にこの関数を呼び出してください</p>
		 */
		protected function dispatchComplete():void
		{
			dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
}