package com.lylib.touch.gestures.tapGestures
{
	import com.lylib.touch.events.TapGestureEvent;
	import com.lylib.touch.gestures.EventGesture;
	
	import flash.events.TouchEvent;
	
	
	
	public class OneFingerTapGesture extends EventGesture
	{
		private var _delay:int;
		private var _offset:int;
		
		
		protected var _downX:int;
		protected var _downY:int;
		
		
		
		/**
		 * 一个手指点选手势
		 * @param delay		时间延迟
		 * @param offset		按下与弹起允许的偏移量
		 * 
		 */		
		public function OneFingerTapGesture(delay:int=200, offset:int=20)
		{
			this.delay = delay;
			this.offset = offset;
			this._maxTouchPoints = 1;
			
			super(TapGestureEvent.ONE_FINGER_TAP);
		}

		
		
		override public function touchDownHandler(event:TouchEvent):void 
		{
			if(this.manager.blobs.length > this._maxTouchPoints)
			{	
				_isCancel = true;
			}
			else
			{
				_downX = event.stageX;
				_downY = event.stageY;
			}
		}
		
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			if(this.manager.blobs.length == _maxTouchPoints)
			{
				if(!_isCancel)
				{
					if( Math.abs(_downX - event.stageX)<_offset && Math.abs(_downY - event.stageY)<_offset
						&& manager.getTouchPoint(event.touchPointID).touchAge<_delay )
					{
						this.raiseGestureEvent( new TapGestureEvent(TapGestureEvent.ONE_FINGER_TAP) );
					}
				}
				else
				{
					_isCancel = false;
				}
			}
		}
		
		
		override public function touchRollOutHandler(event:TouchEvent):void
		{
			this.manager.removeBlob( event.touchPointID );
		}
		
		
		
		
		/**
		 * 手指按下与弹起的时间间隔
		 */
		public function get delay():int
		{
			return _delay;
		}
		/**
		 * @private
		 */
		public function set delay(value:int):void
		{
			_delay = value;
		}

		
		/**
		 * 允许按下区域与弹起区域的偏差
		 */
		public function get offset():int
		{
			return _offset;
		}
		/**
		 * @private
		 */
		public function set offset(value:int):void
		{
			_offset = value;
		}


	}
}