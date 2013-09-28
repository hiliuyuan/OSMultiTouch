package com.lylib.touch.gestures.tapGestures
{
	import com.lylib.touch.events.TapGestureEvent;
	
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.utils.Timer;
	

	public class OneFingerDoubleTapGesture extends OneFingerTapGesture
	{
		protected var _touchCount:int=0;
		
		protected var _timer:Timer;
		
		
		/**
		 * 一个手指点选手势
		 * @param delay		时间延迟
		 * @param offset		按下与弹起允许的偏移量
		 * 
		 */	
		public function OneFingerDoubleTapGesture(delay:int=300, offset:int=40)
		{
			this.delay = delay;
			this.offset = offset;
			
			this.gestureEvent = TapGestureEvent.ONE_FINGER_DOUBLE_TAP;
			
			_timer = new Timer(delay,1);
		}
		
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			_touchCount++;
			
			if(_touchCount==1)
			{
				_downX = event.stageX;
				_downY = event.stageY;
				
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.start();
			}
			
			if(this.manager.blobs.length > _maxTouchPoints)
			{
				_isCancel = true;
				_touchCount = 0;
			}
		}
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			if(!_isCancel)
			{
				if(_touchCount==2)
				{
					if(Math.abs(_downX - event.stageX)<offset && Math.abs(_downY - event.stageY)<offset)
					{
						this.raiseGestureEvent(new TapGestureEvent(TapGestureEvent.ONE_FINGER_DOUBLE_TAP) );
					}
					reset();
				}
				else if(_touchCount>2){
					reset();
				}
			}
			else{
				_touchCount = 0;
				_isCancel = false;
			}
		}
		
		override public function touchRollOutHandler(event:TouchEvent):void
		{
			this.manager.removeBlob( event.touchPointID );
			_touchCount--;
		}

		protected function onTimerComplete(e:TimerEvent):void
		{
			reset();
		}
		
		protected function reset():void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.reset();
			_touchCount = 0;
		}
		
		
		/**
		 * 禁用
		 */		
		override public function dispose():void
		{
			super.dispose();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
		}
	}
}