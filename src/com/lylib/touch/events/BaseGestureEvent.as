/**
 * BaseGestureEvent
 * 测试阶段，有疑问联系 hiliuyuan@gmail.com
 * 
 * @author		刘渊
 * @version	2.0.1.2011_01_19_beta
 * 	更新：覆盖type属性
 */
package com.lylib.touch.events
{
	import com.lylib.touch.TouchPoint;
	import com.lylib.touch.gestures.GestureState;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.utils.getTimer;
	
	public class BaseGestureEvent extends Event
	{
		
		private var _touchPoint:TouchPoint;
		//private var _touchBlobs:Vector.<TouchPoint>;
		private var _gestureState:GestureState;
		
		public function BaseGestureEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_gestureState = GestureState.Progress;
		}

		
		protected function copyTo(event:BaseGestureEvent) : BaseGestureEvent
		{
			if (event != null)
			{
				//event.touchPoint = _touchPoint
			}
			return event;
		}

		
		
		public function get touchPoint():TouchPoint
		{
			return _touchPoint;
		}
		public function set touchPoint(value:TouchPoint):void
		{
			_touchPoint = value;
		}
		
		/**
		 * 手势的状态
		 * @return 返回：GestureState.Begin、GestureState.End、GestureState.Progress
		 */		
		public function get gestureState():GestureState
		{
			return _gestureState;
		}
		public function set gestureState(value:GestureState):void
		{
			_gestureState = value;
		}

		/**
		 * 事件类型
		 */		
		override public function get type():String
		{
			return super.type.split("_")[0];
		}
	}
}