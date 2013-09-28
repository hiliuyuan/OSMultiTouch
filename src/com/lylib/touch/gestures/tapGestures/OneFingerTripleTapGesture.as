package com.lylib.touch.gestures.tapGestures
{
	import com.lylib.touch.events.TapGestureEvent;
	
	import flash.events.TouchEvent;
	import flash.utils.Timer;

	public class OneFingerTripleTapGesture extends OneFingerDoubleTapGesture
	{
		public function OneFingerTripleTapGesture(delay:int=500, offset:int=40)
		{
			this.delay = delay;
			this.offset = offset;
			
			this.gestureEvent = TapGestureEvent.ONE_FINGER_TRIPLE_TAP;
			
			_timer = new Timer(delay,1);
		}
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			if(!_isCancel)
			{
				if(_touchCount==3)
				{
					if(Math.abs(_downX - event.stageX)<offset && Math.abs(_downY - event.stageY)<offset)
					{
						this.raiseGestureEvent(new TapGestureEvent(TapGestureEvent.ONE_FINGER_TRIPLE_TAP) );
					}
					reset();
				}
				else if(_touchCount>3){
					reset();
				}
			}
			else{
				_touchCount = 0;
				_isCancel = false;
			}
		}
	}
}