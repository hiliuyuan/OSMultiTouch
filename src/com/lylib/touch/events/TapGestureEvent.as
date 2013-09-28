package com.lylib.touch.events
{
	import com.lylib.touch.TouchPoint;

	public class TapGestureEvent extends BaseGestureEvent
	{
		
		/**
		 * 一个手指一次敲击
		 */		
		public static const ONE_FINGER_TAP:String = "one_finger_tap";
		
		/**
		 * 一个手指两次敲击
		 */		
		public static const ONE_FINGER_DOUBLE_TAP:String = "one_finger_double_tap";
		
		
		/**
		 * 一个手指三次敲击
		 */		
		public static const ONE_FINGER_TRIPLE_TAP:String = "one_finger_triple_tap";
		
		
		/**
		 * 多个手指多次敲击
		 */	
		public static const MULTI_FINGER_MULTI_TAP:String = "multi_finger_multi_tap";
		
		public function TapGestureEvent(type:String)
		{
			super(type, true, false);
		}
	}
}