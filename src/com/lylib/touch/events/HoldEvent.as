package com.lylib.touch.events
{
	/**
	 * 延时手势事件
	 * @author 	刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */	
	public class HoldEvent extends BaseGestureEvent
	{
		
		static public const HOLD:String = "hold";
		
		public function HoldEvent(type:String)
		{
			super(type, bubbles, cancelable);
		}
	}
}