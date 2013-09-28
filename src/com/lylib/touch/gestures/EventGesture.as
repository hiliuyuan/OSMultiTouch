package com.lylib.touch.gestures
{
	import com.lylib.touch.events.BaseGestureEvent;

	/**
	 * 事件手势
	 * 
	 * @author		刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */
	public class EventGesture extends BaseGesture
	{
		private var _gestureEvent:String;
		
		/**
		 * 事件手势
		 * @param gestureType		手势类型
		 */	
		public function EventGesture(gestureType:String)
		{
			this._gestureEvent = gestureType + "_" + Math.random().toString();
		}

		/**
		 * 派发手势事件
		 * @param event	手势事件
		 */		
		protected function raiseGestureEvent(event:BaseGestureEvent) : void
		{
			this.obj.dispatchEvent(event);
			return;
		}
		
		
		/**
		 * 手势事件类型
		 */
		public function get gestureEvent():String
		{
			return _gestureEvent;
		}
		public function set gestureEvent(value:String):void
		{
			_gestureEvent = value;
		}


	}
}