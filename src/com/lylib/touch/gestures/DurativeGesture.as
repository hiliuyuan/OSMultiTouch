package com.lylib.touch.gestures
{
	import com.lylib.touch.events.BaseGestureEvent;
	
	import flash.events.Event;

	/**
	 * 可持续性手势
	 * @author 刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */	
	public class DurativeGesture extends EventGesture
	{
		
		/**
		 * 存放派发的事件
		 */		
		protected var _waitList:Vector.<BaseGestureEvent>;
		
		public function DurativeGesture(gestureType:String)
		{
			super(gestureType);
			
			_waitList = new Vector.<BaseGestureEvent>();
		}
		
		
		
		
		
		protected function onFrame(e:Event):void
		{
			
		}
		
		
		
		/**
		 * 禁用此手势
		 */		
		override public function dispose():void
		{
			obj.removeEventListener(Event.ENTER_FRAME, onFrame);
			_waitList.splice(0, _waitList.length);
			_waitList = null;
			
			super.dispose();
		}
		
		
		/**
		 * 暂停使用手势，移除enter_frame事件监听，清空_waitList数组
		 */	
		protected function suspend():void
		{
			obj.removeEventListener(Event.ENTER_FRAME, onFrame);
			_waitList.splice(0, _waitList.length);
		}
	}
}