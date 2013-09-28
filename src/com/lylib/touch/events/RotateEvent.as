package com.lylib.touch.events
{
	import com.lylib.touch.events.BaseGestureEvent;
	
	/**
	 * 旋转手势事件,该事件由RotateGesture派发
	 * @author 	刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */	
	public class RotateEvent extends BaseGestureEvent
	{
		static public const ROTATE:String = "rotate";
		
		private var _deltaAngle:Number;
		
		/**
		 * 旋转手势事件
		 * @param type			
		 * @param deltaAngle 	旋转角度的增量,以弧度为单位
		 */		
		public function RotateEvent(type:String, deltaAngle:Number=0)
		{
			super(type);
			
			_deltaAngle = deltaAngle;
		}

		
		
		
		/**
		 * 旋转角度的增量,以弧度为单位
		 */
		public function get deltaAngle():Number
		{
			return _deltaAngle;
		}

		public function set deltaAngle(value:Number):void
		{
			_deltaAngle = value;
		}

	}
}