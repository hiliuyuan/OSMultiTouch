package com.lylib.touch.gestures
{
	import com.lylib.touch.TouchOptions;
	import com.lylib.touch.TouchPoint;
	import com.lylib.touch.events.ZoomEvent;
	
	import flash.events.Event;
	import flash.events.TouchEvent;

	/**
	 缩放手势事件
	 @eventType	com.lylib.touch.events.ZoomEvent.ZOOM
	 */
	[Event(name="zoom", type="com.lylib.touch.events.ZoomEvent")] 
	
	
	/**
	 * 缩放手势
	 * @author		刘渊
	 * @version	2.0.2.2011-2-14_beta
	 */	
	public class ZoomGesture extends DurativeGesture
	{
		private var _oldDistance:Number;
		private var _oldScale:Number;
		
		public function ZoomGesture()
		{
			super(ZoomEvent.ZOOM);
			
			_minTouchPoints = 2;
			_maxTouchPoints = TouchOptions.maxTouchCount;
		}
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			var evt:ZoomEvent;
			
			if(manager.blobs.length == 2)
			{
				_oldDistance = manager.getDistance();
				evt = new ZoomEvent(this.gestureEvent, 1);
				evt.gestureState = GestureState.Begin;
				_waitList.push(evt);
				
				this.obj.addEventListener(Event.ENTER_FRAME, onFrame);
			}
			else if(manager.blobs.length > 2 && manager.blobs.length <= TouchOptions.maxTouchCount)
			{
				_oldDistance = manager.getDistance();
				
				evt = new ZoomEvent(this.gestureEvent, 1);
				evt.gestureState = GestureState.Progress;
				_waitList.push(evt);
			}
		}
		
		override public function touchMoveHandler(event:TouchEvent):void
		{
			if(manager.blobs.length>=2)
			{
				//trace(getAngleByPoint( manager.p1, manager.p2) , _oldAngle);
				var evt:ZoomEvent = new ZoomEvent(this.gestureEvent, manager.getDistance() / _oldDistance);
				evt.gestureState = GestureState.Progress;
				_waitList.push(evt);
				_oldDistance = manager.getDistance();
			}
		}
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			//manager.removeBlob(event.touchPointID);
			var evt:ZoomEvent = new ZoomEvent(this.gestureEvent, 1);
			if(manager.blobs.length == 0)
			{
				evt.gestureState = GestureState.End;
				obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
				obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
			}
			else if(manager.blobs.length == 1)
			{
				evt.gestureState = GestureState.Progress;
				evt.deltaScale
			}
			else
			{
				evt.gestureState = GestureState.Progress;
				_oldDistance = manager.getDistance();
			}
			_waitList.push(evt);
		}
		
		override public function touchRollOutHandler(event:TouchEvent):void
		{
			if(manager.blobs.length>=2)
			{
				obj.stage.addEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
				obj.stage.addEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
			}
		}
		
		//舞台触控点弹起
		private function stageTouchUpHandler(event:TouchEvent):void
		{	
			manager.removeBlob(event.touchPointID);
			touchUpHandler(event);
		}
		
		private function stageTouchMoveHandler(e:TouchEvent):void
		{
			manager.UpdateCaptureTouchInfor(e);
			touchMoveHandler(null);
		}
		
		override protected function onFrame(e:Event):void
		{
			while(_waitList.length>0)
			{
				raiseGestureEvent(_waitList[0]);
				
				if(_waitList[0].gestureState == GestureState.End && manager.blobs.length==0)
				{
					_waitList.splice(0, _waitList.length);
					obj.removeEventListener(Event.ENTER_FRAME, onFrame);
					obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
					obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
				}
				else
				{
					_waitList.splice(0,1);
				}
			}
		}
		
		/**
		 * 禁用该手势
		 */		
		override public function dispose():void
		{
			obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
			obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
			
			super.dispose();
		}
	}
}