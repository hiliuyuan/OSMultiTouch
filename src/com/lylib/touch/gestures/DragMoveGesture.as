package com.lylib.touch.gestures
{
	import com.lylib.touch.events.BaseGestureEvent;
	import com.lylib.touch.events.DragMoveEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;

	/**
	 拖拽移动手势事件
	 @eventType	com.lylib.touch.events.DragMoveEvent.DRAG_MOVE
	 */
	[Event(name="drag_move", type="com.lylib.touch.events.DragMoveEvent")] 
	

	/**
	 * 拖拽移动手势
	 * 
	 * @author		刘渊
	 * @version	2.0.2.2011-2-14_beta
	 */
	public class DragMoveGesture extends DurativeGesture
	{
		private var _context:DisplayObjectContainer;
		
		private var _oldX:Number;
		private var _oldY:Number;
		private var _dX:Number;
		private var _dY:Number;
		private var _stageConterPoint:Point;
		private var _contextConterPoint:Point;
		
		/**
		 * 拖拽移动手势
		 * @param minTouchPoints	最小并发点数
		 * @param maxTouchPoints	最大并发点数
		 * @param context			坐标系，默认null以舞台为坐标系，尽量以obj.parent为移动的坐标系
		 * 
		 */		
		public function DragMoveGesture(minTouchPoints:uint=1, maxTouchPoints:uint=1, context:DisplayObjectContainer=null)
		{
			super(DragMoveEvent.DRAG_MOVE);
			
			_minTouchPoints = minTouchPoints;
			_maxTouchPoints = maxTouchPoints;
			this.context = context;
		}
		
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			obj.addEventListener(Event.ENTER_FRAME, onFrame);
			
			var dragEvt:DragMoveEvent = new DragMoveEvent(this.gestureEvent);
			if(manager.blobs.length>=_minTouchPoints && manager.blobs.length<=_maxTouchPoints)
			{
				_isCancel = false;
				
				update_oldX_oldY();
				
				_dX = 0;
				_dY = 0;
				dragEvt.gestureState = GestureState.Begin;
			}
			else
			{
				_isCancel = true;
				dragEvt.gestureState = GestureState.End;
				dragEvt.deltaOffsetX = _dX;
				dragEvt.deltaOffsetY = _dY;
			}
			_waitList.push(dragEvt);
		}
		
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			//manager.removeBlob(event.touchPointID);
			if(manager.blobs.length>=_minTouchPoints && manager.blobs.length<=_maxTouchPoints)
			{
				update_oldX_oldY();
				_dX = 0;
				_dY = 0; 
			}
			else
			{
				var dragEvt:DragMoveEvent = new DragMoveEvent(this.gestureEvent, _dX, _dY);
				dragEvt.gestureState = GestureState.End;
				_waitList.push(dragEvt);
				_isCancel = true;
			}
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
		
		override public function touchMoveHandler(event:TouchEvent):void
		{
			if(_isCancel)return;
			_stageConterPoint = manager.getConterPoint();
			
			var dragEvt:DragMoveEvent = new DragMoveEvent(this.gestureEvent);
			dragEvt.gestureState = GestureState.Progress;
			if(context)
			{
				_contextConterPoint = context.globalToLocal(_stageConterPoint);
				_dX = _contextConterPoint.x - this._oldX;
				_dY = _contextConterPoint.y - this._oldY;
				_oldX = _contextConterPoint.x;
				_oldY = _contextConterPoint.y;
			}
			else
			{
				_dX = _stageConterPoint.x - this._oldX;
				_dY = _stageConterPoint.y - this._oldY;
				_oldX = _stageConterPoint.x;
				_oldY = _stageConterPoint.y;
			}
			dragEvt.deltaOffsetX = _dX;
			dragEvt.deltaOffsetY = _dY;
			
			//trace(_dX, _dY)
			_waitList.push(dragEvt)
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

		override public function dispose():void
		{
			obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
			obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
			_stageConterPoint = null;
			_contextConterPoint = null;
			
			super.dispose();
		}
		
		private function update_oldX_oldY():void
		{
			_stageConterPoint = manager.getConterPoint();
			if(context)
			{
				_contextConterPoint = context.globalToLocal(_stageConterPoint);
				_oldX = _contextConterPoint.x;
				_oldY = _contextConterPoint.y;
			}
			else
			{
				_oldX = _stageConterPoint.x;
				_oldY = _stageConterPoint.y;
			}
		}
		
		
		/**
		 * 坐标系，默认null以舞台为坐标系
		 */		
		public function get context():DisplayObjectContainer
		{
			return _context;
		}
		public function set context(value:DisplayObjectContainer):void
		{
			_context = value;
		}

	}
}