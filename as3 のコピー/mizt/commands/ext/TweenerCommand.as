package mizt.commands.ext {
	import mizt.commands.CommandBase;
	import mizt.Mizt;

	// Command implementation for Tweener addTween. 
	// This command internally uses Tweener's onComplete and dispaches Event.COMPLETE after animation.
	public class TweenerCommand extends CommandBase {
		protected var _target : Object
		protected var _paramObj : Object
		protected var _waitComplete : Boolean
		
		// target:Object target for tween, same as Tweener
		// paramObj:Object parameters for tween, same as Tweener
		public function TweenerCommand($target:Object,$paramObj:Object,$waitComplete:Boolean=true) {
			super();
			_target   = $target;
			_paramObj = $paramObj;
			_waitComplete = $waitComplete;
			if(waitComplete==true) _paramObj.onComplete = _onCompleteCallback;
		}
		
		override public function execute():void {
			Mizt.addTween(_target, _paramObj);		
			if(_waitComplete==false) _onCompleteCallback();
		}
		
		protected function _onCompleteCallback():void {
			_target   = null;
			_paramObj = null;	
			dispatchComplete();
		}
	}
};