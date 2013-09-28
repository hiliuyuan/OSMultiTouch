package com.lylib.touch.gestures.tapGestures
{
	import com.lylib.touch.events.TapGestureEvent;
	import com.lylib.touch.gestures.EventGesture;
	
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	
	
	public class MultiFingerTapGesture extends EventGesture
	{
		private var _delay:uint;
		private var _offset:uint;
		
		/**
		 * 首次按下的点（相对于舞台坐标系）,用此点计算偏移范围
		 */		
		protected var _firstDownPoint:Point;
		
		/**
		 * 最后一次按下的点（相对于舞台坐标系）,用此点计算偏移范围
		 */	
		protected var _lastDownPoint:Point;
		
		/**
		 * 触摸计数器
		 */		
		protected var _touchCount:int=0;
		
		/**
		 * 计时器
		 */	
		protected var _timer:Timer;
		
		/**
		 * 点击次数
		 */		
		protected var _tapLength:uint=1;
		
		/**
		 * 触摸点宽度范围
		 */		
		protected var _width:uint;
		
		/**
		 * 触摸点高度范围
		 */		
		protected var _height:uint;
		
		/**
		 * 一个手指点选手势
		 * @param delay		时间延迟
		 * @param offset		按下与弹起允许的偏移量
		 * 
		 */		
		public function MultiFingerTapGesture(delay:uint=200, offset:uint=100, maxTouchPoints:uint=1, tapLength:uint=1, width:int=200, height:int=200)
		{
			super(TapGestureEvent.MULTI_FINGER_MULTI_TAP);
			
			this.delay = delay;
			this.offset = offset;
			this._maxTouchPoints = maxTouchPoints;
			this._tapLength = tapLength;
			this._timer = new Timer(delay,1);
			this._width = width;
			this._height = height;
		}

		
		
		override public function touchDownHandler(event:TouchEvent):void 
		{
			if(this.manager.blobs.length == _maxTouchPoints)
			{
				if(this.manager.getPointsRectangle().width < _width &&
					this.manager.getPointsRectangle().height < _height)
				{
					_touchCount++;
				}else
				{
					//trace("超出矩形范围");
				}
			}
			else if( this.manager.blobs.length > _maxTouchPoints )
			{//trace("点个数超出",this.manager.blobs.length);
				_isCancel = true;
				_touchCount = 0;
			}
			
			//第一次
			if(_touchCount==1)
			{
				_firstDownPoint =  manager.getConterPoint();
				
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer.start();
			}
			else if(_touchCount == _tapLength)
			{
				_lastDownPoint = manager.getConterPoint();;
			}
		}
		
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			trace(this.manager.blobs.length);
			if(this.manager.blobs.length == 1)
			{
				if(!_isCancel)
				{
					if(_touchCount==_tapLength  )
					{
						
						if(_tapLength==1)
						{
							_lastDownPoint = this.manager.getConterPoint();
						}
						
						if(Point.distance(_lastDownPoint,_firstDownPoint)<_offset)
						{
							this.raiseGestureEvent( new TapGestureEvent(TapGestureEvent.MULTI_FINGER_MULTI_TAP) );
						}
						reset();
					}
					else if(_touchCount>_tapLength){
						//trace("点击次数超出");
						reset();
					}
				}
				else
				{
					_touchCount = 0;
					_isCancel = false;
				}
			}
		}
		
		
		override public function touchRollOutHandler(event:TouchEvent):void
		{
			this.manager.removeBlob( event.touchPointID );
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