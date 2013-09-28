package com.lylib.touch.events
{
	import com.lylib.touch.TouchPoint;

	/**
	 * 轻敲手势事件，有TapGesture派发
	 * @author		刘渊
	 * @version	2.0.2.2011_2_14_beta
	 */	
	public class TapEvent extends BaseGestureEvent
	{
		
		private var _touchPoints:uint;
		private var _tapLength:uint;
		
		/**
		 * 轻敲
		 */		
		public static const TAP:String = "tap";
		
		/**
		 * @param type				事件类型TAP="tap"
		 * @param touchPoints		并发触控点数
		 * @param tapLength		敲击次数
		 */		
		public function TapEvent(type:String, touchPoints:uint=0, tapLength:uint=0)
		{
			super(type, true, false);
			this.touchPoints = touchPoints;
			this.tapLength = tapLength;
		}

		/**
		 * 规定并发的触碰点数
		 */
		public function get touchPoints():uint
		{
			return _touchPoints;
		}

		/**
		 * @private
		 */
		public function set touchPoints(value:uint):void
		{
			_touchPoints = value;
		}

		/**
		 * 敲击次数
		 */
		public function get tapLength():uint
		{
			return _tapLength;
		}

		/**
		 * @private
		 */
		public function set tapLength(value:uint):void
		{
			_tapLength = value;
		}


	}
}