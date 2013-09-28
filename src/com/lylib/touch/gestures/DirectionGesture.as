package com.lylib.touch.gestures
{
	import com.lylib.touch.TouchPoint;
	import com.lylib.touch.events.BaseGestureEvent;
	import com.lylib.touch.events.DirectionEvent;
	import com.lylib.utils.MathUtil;
	
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 方向手势事件
	 @eventType	com.lylib.touch.events.DirectionEvent.DIRECTION
	 */
	[Event(name="direction", type="com.lylib.touch.events.DirectionEvent")] 
	
	/**
	 * 方向手势，用于判断触摸点滑动的方向，包括：上，下，左，右
	 * 
	 * @author		刘渊
	 * @version	2.0.2.2011-02-14_beta
	 */
	public class DirectionGesture extends EventGesture
	{
		/**
		 * 触摸点向左滑动,可作为“前进”命令
		 */		
		static public const LEFT:String = "left";
		
		/**
		 * 触摸点向右滑动，可作为“后退”命令
		 */		
		static public const RIGHT:String = "right";
		
		/**
		 * 触摸点向下滑动
		 */		
		static public const BOTTOM:String = "bottom";
		
		/**
		 * 触摸点向上滑动
		 */		
		static public const TOP:String = "top";
		
		/**
		 * 触摸点向左上滑动
		 */		
		static public const LEFT_TOP:String = "left_top";
		
		/**
		 * 触摸点向左下滑动
		 */		
		static public const LEFT_BOTTOM:String = "left_bottom";
		
		/**
		 * 触摸点向右上滑动
		 */		
		static public const RIGHT_TOP:String = "right_top";
		
		/**
		 * 触摸点向右下滑动
		 */		
		static public const RIGHT_BOTTOM:String = "right_bottom";
		
		private var _delay:uint;
		private var _offDis:uint;		
		private var _offAng:uint;
		private var _width:uint;
		private var _height:uint;
		private var _ang:Number;
		private var _started:Boolean = false;		//是否启动
		private var _isLocal:Boolean = true;		//是否以自身的坐标系判断方向
		
		private var _downPoint:TouchPoint;
		private var _upPoint:TouchPoint;
		
		private var _stateArr:Array;
		
		/**
		 * @param delay			导航手势判断的时间，如果在此时间内还未弹起触摸点，将不会触发 NavigateGestureEvent.NAVIGATION 事件
		 * @param offDis			触摸点按下与弹起的x方向偏移量，在 delay 时间内，触摸点的x坐标要超过这个范围，否则不会触发 NavigateGestureEvent.NAVIGATION 事件
		 * @param offAng			角度的偏移量
		 * @param maxTouchPoints	此手势支持最大触控点数
		 * @param width			触控区域的宽度
		 * @param height			触控区域的高度
		 */		
		public function DirectionGesture(delay:uint=100, offDis:uint=10, offAng:uint=20, maxTouchPoints:uint=1, width:uint=200, height:uint=200)
		{
			super(DirectionEvent.DIRECTION);
			_maxTouchPoints = maxTouchPoints;
			
			this.delay = delay;
			this.offDis = offDis;
			this.offAng = offAng;
			this.width = width;
			this.height = height;
			
			_downPoint = new TouchPoint();
			_upPoint = new TouchPoint();
		}

		
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			//判断点数
			if(this.manager.blobs.length == this._maxTouchPoints)
			{
				//判断区域
				var r:Rectangle = this.manager.getPointsRectangle();
				if(r.width <= this._width && r.height <= this._height)
				{
					_started = true;
					var p1:Point = manager.getConterPoint();
					var p2:Point = obj.globalToLocal(p1);
					_downPoint.stageX = p1.x;
					_downPoint.stageY = p1.y;
					_downPoint.localX = p2.x;
					_downPoint.localY = p2.y;
					_downPoint.downTime = getTimer();
				}
				else
				{
					_isCancel = true;
				}
			}
			else
			{
				_isCancel = true;
			}
		}
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			if(_started==false || manager.blobs.length != 0)return;
			
			_started = false;
//			var p1:Point = manager.getConterPoint();
//			var p2:Point = obj.globalToLocal(p1);
			_upPoint.stageX = event.stageX;
			_upPoint.stageY = event.stageY;
			_upPoint.localX = event.localX;
			_upPoint.localY = event.localY;
			_upPoint.upTime = getTimer();
			
			if( _upPoint.upTime - _downPoint.downTime > delay)
			{
				_isCancel = true;
			}
			else
			{
				_isCancel = false;
			}
			
			if(manager.blobs.length == 0)
			{
				if(!_isCancel)
				{
					//要派发的事件
					var evt:DirectionEvent = new DirectionEvent(this.gestureEvent);
					evt.downTouchPoint = _downPoint;
					evt.upTouchPoint = _upPoint;
					
					var d:Number = Point.distance( _downPoint, _upPoint );
					
					if(d*obj.scaleX < offDis){
						//trace("<<<<",d,_downPoint,_upPoint);
						return;
					}
					
					if(isLocal)
					{
						_ang = MathUtil.getAngleByPoint(_downPoint.localX, _downPoint.localY, _upPoint.localX, _upPoint.localY);
						trace(_ang,_downPoint.localX, _downPoint.localY, _upPoint.localX, _upPoint.localY);
					}else
					{
						_ang = MathUtil.getAngleByPoint(_downPoint.x, _downPoint.y, _upPoint.x, _upPoint.y);
					}
					
					if(_ang >= -_offAng && _ang <= _offAng)
					{
						evt.direction = RIGHT;
					}
					else if( _ang>_offAng && _ang<=90-_offAng )
					{
						evt.direction = RIGHT_BOTTOM;
					}
					else if( _ang>90-_offAng && _ang<=90+_offAng)
					{
						evt.direction = BOTTOM;
					}
					else if( _ang>90+_offAng && _ang<=180-_offAng)
					{
						evt.direction = LEFT_BOTTOM;
					}
					else if( _ang>180-_offAng && _ang<=180 || _ang>=-180 && _ang<=-180+_offAng)
					{
						evt.direction = LEFT;
					}
					else if( _ang>-180+_offAng && _ang<= -90-_offAng)
					{
						evt.direction = LEFT_TOP;
					}
					else if( _ang>-90-_offAng && _ang<= -90+_offAng)
					{
						evt.direction = TOP;
					}
					else
					{
						evt.direction = RIGHT_TOP;
					}
					this.raiseGestureEvent(evt);
				}
				else
				{
					_isCancel = false;
				}
			}
		}
		
		
		
		
		/**
		 * 导航手势判断的时间，如果在此时间内还未弹起触摸点，将不会触发 NavigateGestureEvent.NAVIGATION 事件
		 */
		public function get delay():uint
		{
			return _delay;
		}
		public function set delay(value:uint):void
		{
			_delay = value;
		}

		/**
		 * 触摸点按下与弹起的x方向偏移量，在 delay 时间内，触摸点的x坐标要超过这个范围，否则不会触发 NavigateGestureEvent.NAVIGATION 事件
		 */
		public function get offDis():uint
		{
			return _offDis;
		}
		public function set offDis(value:uint):void
		{
			_offDis = value;
		}

		/**
		 * 角度的偏移量
		 */	
		public function get offAng():uint
		{
			return _offAng;
		}
		public function set offAng(value:uint):void
		{
			_offAng = value;
		}
		
		/**
		 * 触控区域的宽度
		 */		
		public function get width():uint
		{
			return _width;
		}
		public function set width(value:uint):void
		{
			_width = value;
		}

		/**
		 * 触控区域的高度
		 */		
		public function get height():uint
		{
			return _height;
		}
		public function set height(value:uint):void
		{
			_height = value;
		}

		/**
		 * 是否以自身的坐标系判断方向 
		 */		
		public function get isLocal():Boolean
		{
			return _isLocal;
		}
		public function set isLocal(value:Boolean):void
		{
			_isLocal = value;
		}


	}
}