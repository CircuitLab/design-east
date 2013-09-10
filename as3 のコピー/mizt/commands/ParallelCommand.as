package commands {
	import flash.events.Event;
	
	// 「全ての子コマンドを同時に実行し、その全ての終了を待つ」コマンド.
	
	//<p>登録された複数のコマンドを全て同時に実行し、その全てのコマンドが終了するとEvent.COMPLETEが発行されます。
	//複数のデータが全てロードされるのを待つ時等に用いられます</p>
	 
	//@example 以下の例では、「文字の表示」「１秒待ち」「文字を表示」を同時に実行し、全てが終了した時点（つまり１秒後）にEvent.COMPLETEを発行します。"
 	//<listing version="3.0">
	//var coms : Array = [
	// 		new Command("hello"),
	// 		new WaitCommand(1000),
	// 		new Command("world")];
	// 
	// var pCom : ParallelCommand = new ParallelCommand( coms );
	// pCom.addEventListener(Event.COMPLETE, _commandCompleteHandler);
	// 
	// CommandContainer.execute( pCom);</listing>
	// 
	// @see commands.SerialCommand
	// @see commands.CommandContainer
	//
	public class ParallelCommand extends BatchCommand
	{
		public function ParallelCommand( commandArray:Array = null )
		{
			super( commandArray );
		}
		
		
		override public function execute():void
		{
			for(var i:int = 0; i<_commands.length; i++)
			{
				var c : ICommand = _commands[ i ];
				c.addEventListener(Event.COMPLETE, doNextCompleteHandler);
				c.execute();
			}
		}
		

		protected function doNextCompleteHandler( e:Event ):void {
			var c : ICommand = ICommand(e.target);
			c.removeEventListener(Event.COMPLETE, doNextCompleteHandler);
			_index ++;
			
			if(_index == _commands.length ) dispatchComplete();	
		}
	}
}