package com.lylib.touch.gestures
{
	import com.lylib.touch.events.HoldEvent;
	
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 延时手势事件
	 @eventType	com.lylib.touch.events.HoldEvent.HOLD
	 */
	[Event(name="hold", type="com.lylib.touch.events.HoldEvent")] 
	
	
	
	/**
	 * 保持长按手势
	 * @author 	刘渊
	 * @version	2.0.2.2011-2-14_beta
	 */	
	public class HoldGesture extends EventGesture
	{
		
		private var _holdTime:uint;
		private var _tolDis:uint;
		
		private var _timer:Timer;
		private var _oldPosition:Point;
		
		/**
		 * 保持长按手势
		 * @param touchPoints		规定的并发触控点数
		 * @param holdTime		保持长按的时间，以秒为单位
		 * @param tolDis			距离的容差
		 * 
		 */		
		public function HoldGesture(touchPoints:uint=1, holdTime:uint=1, tolDis:uint=100)
		{
			super(HoldEvent.HOLD);
			
			_touchPoints = touchPoints;
			if(_touchPoints==0)
			{
				_touchPoints = 1;
			}
			else if(_touchPoints>5)
			{
				_touchPoints = 5;
			}
			
			this._holdTime = holdTime;
			if(_holdTime==0)
			{
				_holdTime = 1;
			}
			
			_tolDis = tolDis;
			
			_timer = new Timer(_holdTime*1000,1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			if(manager.blobs.length == _touchPoints)
			{
				_isCancel = false;
				_oldPosition = manager.getConterPoint();
				_timer.reset();
				_timer.start();
			}
			else
			{
				_isCancel = true;
				_timer.stop();
				_timer.reset();
			}
		}
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			_isCancel = true;
			_timer.stop();
			_timer.reset();
		}
		
		
		override public function touchMoveHandler(event:TouchEvent):void
		{
			if(_isCancel)return;
			if(Point.distance(_oldPosition, manager.getConterPoint()) > this.tolDis)
			{
				_timer.stop();
				_timer.reset();
			}
		}
		
		override public function touchRollOutHandler(event:TouchEvent):void
		{
			_isCancel = true;
			_timer.stop();
			_timer.reset();
		}
		

		private function onTimer(e:TimerEvent):void
		{
			var event:HoldEvent = new HoldEvent(this.gestureEvent);
			this.raiseGestureEvent(event);
		}
		
		
		/**
		 * 禁用此手势
		 */		
		override public function dispose():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
			_oldPosition = null;
			
			super.dispose();
		}
		
		
		/**
		 * 保持时间 
		 */		
		public function get holdTime():uint
		{
			return _holdTime;
		}
		public function set holdTime(value:uint):void
		{
			_holdTime = value;
		}

		/**
		 * 距离的容差
		 */		
		public function get tolDis():uint
		{
			return _tolDis;
		}
		public function set tolDis(value:uint):void
		{
			_tolDis = value;
		}


	}
}