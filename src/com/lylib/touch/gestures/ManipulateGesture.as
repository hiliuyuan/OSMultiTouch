package com.lylib.touch.gestures
{
	import com.lylib.touch.TouchPoint;
	import com.lylib.touch.events.ManipulateEvent;
	import com.lylib.touch.geom.Vector2D;
	
	import flash.events.Event;
	import flash.events.TouchEvent;

	
	/**
	 机械手手势事件
	 @eventType	com.lylib.touch.events.ManipulateEvent.MANIPULATE
	 */
	[Event(name="manpulate", type="com.lylib.touch.events.ManipulateEvent")] 
	
	
	
	/**
	 * 旋转缩放移动手势,以对象的注册点为中心缩放旋转
	 * @author 	刘渊
	 * @version	2.0.2.2011-2-14_beta
	 */	
	public class ManipulateGesture extends DurativeGesture
	{
		private var _oldDistance:Number;
		private var _oldAngle:Number;
		private var _oldX:Number;
		private var _oldY:Number;
		
		public function ManipulateGesture()
		{
			super(ManipulateEvent.MANIPULATE);
		}
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			var evt:ManipulateEvent = new ManipulateEvent(this.gestureEvent, new Vector2D(), 1, 0);
			evt.gestureState = GestureState.Begin;
			
			if(manager.blobs.length==1)
			{
				obj.addEventListener(Event.ENTER_FRAME, onFrame);
			}
			else
			{
				_oldDistance = manager.getDistance();
				_oldAngle = manager.getAngle();
			}
			_oldX = manager.getConterPoint().x;
			_oldY = manager.getConterPoint().y;
			
			_waitList.push(evt);
		}
		
		
		override public function touchMoveHandler(event:TouchEvent):void
		{
			var evt:ManipulateEvent = new ManipulateEvent(this.gestureEvent, new Vector2D(), 1, 0);
			evt.gestureState = GestureState.Progress;
			
			evt.deltaVector.x = manager.getConterPoint().x - _oldX;
			evt.deltaVector.y = manager.getConterPoint().y - _oldY;
			_oldX = manager.getConterPoint().x;
			_oldY = manager.getConterPoint().y;
			if( manager.blobs.length >= 2)
			{
				evt.deltaAngle = manager.getAngle() - _oldAngle;
				evt.deltaScale = manager.getDistance() / _oldDistance;
				
				_oldAngle = manager.getAngle();
				_oldDistance = manager.getDistance();
			}
			_waitList.push(evt);
		}
		
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			//manager.removeBlob(event.touchPointID);
			var evt:ManipulateEvent = new ManipulateEvent(this.gestureEvent, new Vector2D(), 1, 0);
			if(manager.blobs.length == 0)
			{
				evt.gestureState = GestureState.End;
				obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
				obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
			}
			else
			{
				evt.gestureState = GestureState.Progress;
				_oldX = manager.getConterPoint().x;
				_oldY = manager.getConterPoint().y;
				_oldAngle = manager.getAngle();
				_oldDistance = manager.getDistance();
			}
			_waitList.push(evt);
		}
		
		override public function touchRollOutHandler(event:TouchEvent):void
		{
			obj.stage.addEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
			obj.stage.addEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
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
		
		
		override public function onUpdateP1P2():void
		{
			_oldX = manager.getConterPoint().x;
			_oldY = manager.getConterPoint().y;
			_oldAngle = manager.getAngle();
			_oldDistance = manager.getDistance();
		}
		
		
		override protected function onFrame(e:Event):void
		{
			while(_waitList.length>0)
			{
				raiseGestureEvent(_waitList[0]);
				
				if(_waitList[0].gestureState == GestureState.End && manager.blobs.length==0)
				{//trace("remove");
					_waitList.splice(0, _waitList.length);
					obj.removeEventListener(Event.ENTER_FRAME, onFrame);
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