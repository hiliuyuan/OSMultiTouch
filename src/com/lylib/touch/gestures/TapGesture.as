package com.lylib.touch.gestures
{
	import com.lylib.touch.events.TapEvent;
	
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 轻敲手势事件
	 @eventType	com.lylib.touch.events.TapEvent.TAP
	 */
	[Event(name="tap", type="com.lylib.touch.events.TapEvent")] 
	
	
	
	/**
	 * 轻敲手势
	 * @author		刘渊
	 * @version	2.0.3.2011_3_25_beta
	 */	
	public class TapGesture extends EventGesture
	{
		private var _delay:uint;
		private var _tolDis:uint;
		
		/**
		 * 首次按下的点（相对于舞台坐标系）,用此点计算偏移范围
		 */		
		protected var _firstDownPoint:Point;
		
		/**
		 * 最后一次按下的点（相对于舞台坐标系）,用此点计算偏移范围
		 */	
		protected var _lastDownPoint:Point=new Point();
		
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
		 * 轻敲手势
		 * @param touchPoints		规定并发的触控点数
		 * @param tapLength		轻敲次数
		 * @param delay			手势时间限制
		 * @param tolDis			距离容差
		 * @param width			触控区域最大宽度
		 * @param height			触控区域最大高度
		 * 
		 */		
		public function TapGesture(touchPoints:uint=1, tapLength:uint=1, delay:uint=500, tolDis:uint=100, width:int=200, height:int=200)
		{
			super(TapEvent.TAP);
			
			this.delay = delay;
			this.tolDis = tolDis;
			this._touchPoints = touchPoints;
			this._tapLength = tapLength;
			this._timer = new Timer(delay,1);
			this._width = width;
			this._height = height;
		}

		
		
		override public function touchDownHandler(event:TouchEvent):void 
		{
			if(this.manager.blobs.length == _touchPoints)
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
			else if( this.manager.blobs.length > _touchPoints )
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
			//trace("up");
			if(this.manager.blobs.length == 0)
			{
				if(!_isCancel)
				{
					if(_touchCount==_tapLength  )
					{
						
						if(_tapLength==1)
						{
							_lastDownPoint.x = event.stageX;
							_lastDownPoint.y = event.stageY;
						}
						
						if(Point.distance(_lastDownPoint,_firstDownPoint)<_tolDis)
						{
							reset();
							this.raiseGestureEvent( new TapEvent(this.gestureEvent, _touchPoints, _tapLength) );
							return;
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
			//this.manager.removeBlob( event.touchPointID );
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
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
			
			super.dispose();
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
		public function get tolDis():int
		{
			return _tolDis;
		}
		/**
		 * @private
		 */
		public function set tolDis(value:int):void
		{
			_tolDis = value;
		}


	}
}