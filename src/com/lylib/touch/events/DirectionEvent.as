package com.lylib.touch.events
{
	import com.lylib.touch.TouchPoint;
	
	/**
	 * 方向手势事件，用于判断手指的滑动方向
	 * @author 刘渊 
	 */	
	public class DirectionEvent extends BaseGestureEvent
	{
		
		/**
		 * 方向
		 */		
		static public const DIRECTION:String = "direction";
		
		private var _direction:String;
		private var _downTouchPoint:TouchPoint;
		private var _upTouchPoint:TouchPoint;
		
		public function DirectionEvent(type:String, state:String="")
		{
			super(type, bubbles, cancelable);
			
			_direction = state;
		}

		
		
		/**
		 * 滑动方向
		 */
		public function get direction():String
		{
			return _direction;
		}
		public function set direction(value:String):void
		{
			_direction = value;
		}

		/**
		 * 按下时的触摸点
		 */
		public function get downTouchPoint():TouchPoint
		{
			return _downTouchPoint;
		}
		public function set downTouchPoint(value:TouchPoint):void
		{
			_downTouchPoint = value;
		}

		/**
		 * 弹起时的触摸点
		 */
		public function get upTouchPoint():TouchPoint
		{
			return _upTouchPoint;
		}
		public function set upTouchPoint(value:TouchPoint):void
		{
			_upTouchPoint = value;
		}


	}
}