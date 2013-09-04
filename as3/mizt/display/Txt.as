package mizt.display {
    import flash.text.*;
    import flash.events.MouseEvent;

    public class Txt {
        public function Txt() { return; }
        
        // フォーカスイヴェント
		// textField.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
        // textField.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
        // textField.addEventListener(Event.CHANGE,onTextChange);
		private static　var _smooth:Boolean = false;
		public static function smooth($b:Boolean=true):void { _smooth=$b; }
		
        public static function rect($str:String,$width:uint,$height:uint,$color:uint=0,$font:String="_ゴシック",$size:uint=12,$embed:Boolean=false):TextField {
            var tf:TextField   = new TextField();
            var fmt:TextFormat = new TextFormat();
            fmt.font = $font;
			fmt.size = $size;
            tf.defaultTextFormat = fmt;
            if($embed) tf.embedFonts = true;
            tf.selectable = false;
            tf.textColor = $color;
            tf.text = $str;
            tf.width =  $width  + 2*2;
            tf.height = $height + 2*2;
			if(_smooth) tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;//AntiAliasType.NORMAL;//
            return tf;
        }
        
        public static function fit($str:String,$color:uint=0,$font:String="_ゴシック",$size:uint=12,$embed:Boolean=false):TextField {
            var tf:TextField   = new TextField();
            var fmt:TextFormat = new TextFormat();
            fmt.font = $font;
			fmt.size = $size;
            tf.defaultTextFormat = fmt;
            if($embed) tf.embedFonts = true;
            tf.selectable = false;
            tf.textColor = $color;
            tf.text = $str;
            tf.width =  tf.textWidth  + 2*2;
            tf.height = tf.textHeight + 2*2;
			if(_smooth) tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;//AntiAliasType.NORMAL;//
            return tf;
        }
        
        public static function type($tf:TextField,$type:String="input"):TextField {
            if($type=="input") {
                $tf.type = "input";
                $tf.selectable = true;
            }
            else {
                $tf.type = "dynamic";
                $tf.selectable = false;
            }
            return $tf;
        }

        public static function offset($tf:TextField,$x:int,$y:int):TextField {
            $tf.x = $x;
            $tf.y = $y;
            return $tf; 
        }
        public static function mouse($tf:TextField,$down:Function,$over:Function=null,$out:Function=null):TextField {
            //$tf.buttonMode = true;
            //$tf.mouseEnabled = false;
            if(($down as Function)) $tf.addEventListener(MouseEvent.MOUSE_DOWN,$down);
            $tf.addEventListener(MouseEvent.MOUSE_OVER,($over as Function)?$over:(function(e:MouseEvent):void {e.currentTarget.alpha=.8;}));
            $tf.addEventListener(MouseEvent.MOUSE_OUT ,($out as Function)?$out :(function(e:MouseEvent):void {e.currentTarget.alpha=1.;}));
            return $tf; 
        }


    }
}