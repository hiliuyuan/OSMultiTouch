package com.lylib.touch.manipulators
{
	import com.lylib.touch.TouchPoint;
	import com.lylib.touch.events.BaseGestureEvent;
	import com.lylib.touch.events.ManipulateEvent;
	import com.lylib.touch.gestures.BaseGesture;
//	import com.tweener.transitions.Tweener;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 拖拽缩放旋转手势，以触控点的中心为物体的缩放旋转中心
	 * 
	 * @author		刘渊
	 * @version	2.0.3.2011_2_16_beta
	 */
	public class MultiDragScaleRotate extends BaseGesture
	{
		
		private var _isRotatable:Boolean;
		private var _isScaleable:Boolean;
		private var _isDragable:Boolean;
		private var _isInertiaEnabled:Boolean;
		private var _boundRect:Rectangle = null;
		private var _objRect:Rectangle = null;
//		private var _minWidth:Number = 200;
//		private var _minHeight:Number = 200;
//		private var _maxWidth:Number = 4096;
//		private var _maxHeight:Number = 4096;
		private var _minScale:Number = 0.2;
		private var _maxScale:Number = 5;
		private var _bufferScale:Number = 0.1;
		private var _isBringToFront:Boolean = true;
		private var _angleDamping:Number=0.95;
		
		protected var _dx:Number=0;
		protected var _dy:Number=0;
		protected var _dScale:Number=1;
		protected var _dAngle:Number=0;
		protected var _oldX:Number;
		protected var _oldY:Number;
		protected var _oldAngle:Number;
		protected var _newAngle:Number;
		protected var _oldDistance:Number;
		protected var _vx:Number;
		protected var _vy:Number;
		protected var _m:Matrix;
		protected var _localPoint:Point;
		protected var _parentPoint:Point;
		
		private var _touchBeginFunction:Function;
		private var _touchEndFunction:Function;
		
		/**
		 * 
		 * @param isDragable			允许拖拽
		 * @param isRotatable			允许旋转
		 * @param isScaleable			允许缩放
		 * @param isInertialEnable	启用惯性
		 * @param isBringToFront		置于顶层
		 * @param bound				边界
		 */		
		public function MultiDragScaleRotate(isDragable:Boolean = true, isRotatable:Boolean = true, isScaleable:Boolean = true, isInertialEnable:Boolean = true, isBringToFront:Boolean=true, bound:Rectangle = null)
		{
			super();
			
			this.isDragable = isDragable;
			this.isRotatable = isRotatable;
			this.isScaleable = isScaleable;
			this.isInertiaEnabled = isInertialEnable;
			this.isBringToFront = isBringToFront;
			this.boundRect = bound;
		}
		
		
		override public function touchDownHandler(event:TouchEvent):void
		{
			_parentPoint = obj.parent.globalToLocal(manager.getConterPoint());
			_oldX = _parentPoint.x;
			_oldY = _parentPoint.y;
			_oldAngle = manager.getAngle();
			_oldDistance = manager.getDistance();
			
			if(manager.blobs.length==1)
			{
				//设置旋转阻尼
//				var r:Rectangle = obj.getBounds(obj.stage);
//				var d1:Number = Math.sqrt(r.width*r.width + r.height*r.height)/2;
//				var o:TouchPoint = new TouchPoint();
//				o.x =  r.left + r.width/2;
//				o.y =  r.top + r.height/2;
//				var d2:Number = Point.distance(o, manager.p1);
//				_angleDamping = d2/d1;
				
				obj.addEventListener(Event.ENTER_FRAME, onFrame);
				
				//置于顶层
				if(isBringToFront)
				{
					obj.parent.setChildIndex(obj, obj.parent.numChildren-1);
				}
				
				//回调函数
				if(touchBeginFunction!=null)
				{
					touchBeginFunction(obj);
				}
			}
		}
		
		override public function touchMoveHandler(event:TouchEvent):void
		{
			//允许拖拽
			if(isDragable)
			{
				_dx = obj.parent.globalToLocal(manager.getConterPoint()).x - _oldX;
				_dy = obj.parent.globalToLocal(manager.getConterPoint()).y - _oldY;
			}
			
			//允许旋转
			if(isRotatable)
			{
				_newAngle = manager.getAngle();
				
				//从第3象限移动到第4象限
				if(_newAngle<-Math.PI/2 && _newAngle>=-Math.PI && _oldAngle>Math.PI/2 && _oldAngle<=Math.PI)
				{
					_dAngle = _newAngle + Math.PI;
				}
				else if(_newAngle>Math.PI/2 && _newAngle<=Math.PI && _oldAngle<-Math.PI/2 && _oldAngle>=-Math.PI)
				{
					_dAngle = _newAngle - Math.PI;
				}
				else
				{
					_dAngle = _newAngle - _oldAngle;
				}
			}
			
			//允许缩放
			if(isScaleable)
			{
				_dScale = manager.getDistance() / _oldDistance;
			}
		}
		
		override public function touchUpHandler(event:TouchEvent):void
		{
			if(manager.blobs.length == 0)
			{
				obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
				obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
				obj.removeEventListener(Event.ENTER_FRAME, onFrame);
				
				//如果超出大小限定，恢复
				if(obj.scaleX > _maxScale)
				{
					//Tweener.addTween(obj, {time:0.4, scaleX:_maxScale, scaleY:_maxScale});
				}
				else if(obj.scaleX < _minScale)
				{
					//Tweener.addTween(obj, {time:0.4, scaleX:_minScale, scaleY:_minScale});
				}
				
				//检测是否出了边界
				if(boundRect != null)
				{
					_objRect = obj.getBounds(obj.stage);
					if(_objRect.left+_objRect.width/2<boundRect.left)
					{
						trace("out left");
					}else if(_objRect.right-_objRect.width/2>boundRect.right)
					{
						trace("out right");
					}
					if(_objRect.top+_objRect.height/2<boundRect.top)
					{
						trace("out top");
					}
					else if(_objRect.bottom-_objRect.height/2>boundRect.bottom)
					{
						trace("out bottom");
					}
				}
				
				//触控结束的回调函数
				if(touchEndFunction!=null)
				{
					touchEndFunction(this.obj);
				}
			}
			else
			{
				_parentPoint = obj.parent.globalToLocal(manager.getConterPoint());
				_oldX = _parentPoint.x;
				_oldY = _parentPoint.y;
				_oldAngle = manager.getAngle();
				_oldDistance = manager.getDistance();
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
		
		protected function onFrame(e:Event):void
		{
			_m = obj.transform.matrix;
			_localPoint = obj.globalToLocal(manager.getConterPoint());
			_localPoint = _m.transformPoint( _localPoint );
			_m.tx -= _localPoint.x;
			_m.ty -= _localPoint.y;
			
//			if(manager.blobs.length==1)
//			{
//				_m.rotate(_dAngle*_angleDamping);
//			}
//			else
//			{
//				_m.rotate(_dAngle);
//			}
			if(manager.blobs.length>1)
			{
				_m.rotate(_dAngle);
			}
			
//			if((obj.width*_dScale<scaleMaxSize || obj.height*_dScale<scaleMaxSize) &&
//				(obj.width*_dScale>scaleMinSize || obj.height*_dScale>scaleMinSize) )
//			{
//				_m.scale(_dScale,_dScale);
//			}
			if(_dScale * obj.scaleX > _maxScale + _bufferScale)
			{
				_dScale = (_maxScale + _bufferScale) / obj.scaleX;
			}
			else if(_dScale * obj.scaleX < _minScale - _bufferScale)
			{
				_dScale = (_minScale - _bufferScale) / obj.scaleX;
			}
			_m.scale(_dScale,_dScale);
			_m.translate(_dx,_dy);
			_m.tx += _localPoint.x;
			_m.ty += _localPoint.y;
			//obj.transform.matrix = _m;
			//trace(_localPoint.x);
			obj.x = _m.tx;
			obj.y = _m.ty;
			obj.scaleX *= _dScale;
			obj.scaleY *= _dScale;
			if(manager.blobs.length>1)
			{
				obj.rotation += _dAngle*180/Math.PI; 
			}
			
			_parentPoint = obj.parent.globalToLocal(manager.getConterPoint());
			_oldX = _parentPoint.x;
			_oldY = _parentPoint.y;
			_oldAngle = manager.getAngle();
			_oldDistance = manager.getDistance();
		}
		
		
		
		override public function onUpdateP1P2():void
		{
			_parentPoint = obj.parent.globalToLocal(manager.getConterPoint());
			_oldX = _parentPoint.x;
			_oldY = _parentPoint.y;
			_oldAngle = manager.getAngle();
			_oldDistance = manager.getDistance();
		}
		
		override public function dispose():void
		{
			obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageTouchMoveHandler);
			obj.stage.removeEventListener(TouchEvent.TOUCH_END, stageTouchUpHandler);
			obj.removeEventListener(Event.ENTER_FRAME, onFrame);
			
			_m = null;
			_localPoint = null;
			_touchBeginFunction = null;
			_touchEndFunction = null;
			
			super.dispose();
		}
		

		
		//--------------------------------------------- getter and setter ---------------------------------------------//
		/**
		 * 是否允许旋转
		 */		
		public function get isRotatable():Boolean
		{
			return _isRotatable;
		}
		public function set isRotatable(value:Boolean):void
		{
			_isRotatable = value;
		}
		
		/**
		 * 是否允许缩放
		 */		
		public function get isScaleable():Boolean
		{
			return _isScaleable;
		}
		public function set isScaleable(value:Boolean):void
		{
			_isScaleable = value;
		}
		
		/**
		 * 是否允许拖拽
		 */		
		public function get isDragable():Boolean
		{
			return _isDragable;
		}
		public function set isDragable(value:Boolean):void
		{
			_isDragable = value;
		}

		/**
		 * 是否开启惯性
		 */		
		public function get isInertiaEnabled():Boolean
		{
			return _isInertiaEnabled;
		}
		public function set isInertiaEnabled(value:Boolean):void
		{
			_isInertiaEnabled = value;
		}

		/**
		 * 边界框
		 */		
		public function get boundRect():Rectangle
		{
			return _boundRect;
		}
		public function set boundRect(value:Rectangle):void
		{
			_boundRect = value;
		}
		
		

		/**
		 * 是否允许置于顶层
		 */		
		public function get isBringToFront():Boolean
		{
			return _isBringToFront;
		}
		public function set isBringToFront(value:Boolean):void
		{
			_isBringToFront = value;
		}

		
		/**
		 * 当触控结束时调用此函数
		 */		
		public function get touchEndFunction():Function
		{
			return _touchEndFunction;
		}
		public function set touchEndFunction(value:Function):void
		{
			_touchEndFunction = value;
		}

		/**
		 * 当检测到第一个触控点时调用此函数
		 */		
		public function get touchBeginFunction():Function
		{
			return _touchBeginFunction;
		}
		public function set touchBeginFunction(value:Function):void
		{
			_touchBeginFunction = value;
		}

		/**
		 * 缩放的最小比例
		 */		
		public function get minScale():Number
		{
			return _minScale;
		}
		public function set minScale(value:Number):void
		{
			_minScale = value;
		}

		/**
		 * 缩放的最大比例
		 */		
		public function get maxScale():Number
		{
			return _maxScale;
		}
		public function set maxScale(value:Number):void
		{
			_maxScale = value;
		}

		/**
		 * 放到或缩小超过界限时的缓冲
		 */		
		public function get bufferScale():Number
		{
			return _bufferScale;
		}
		public function set bufferScale(value:Number):void
		{
			_bufferScale = value;
		}
	}
}