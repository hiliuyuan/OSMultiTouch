package com.lylib.touch
{
	import com.lylib.touch.gestures.BaseGesture;
	import com.lylib.touch.gestures.EventGesture;
	
	import flash.display.InteractiveObject;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	 * TouchManager 	负责管理一个对象注册的多个手势
	 * @author 		刘渊
	 * @version		2.0.2.2011_2_14_beta
	 */	
	public class TouchManager
	{
		
		private var _obj:InteractiveObject;
		private var _blobs:Vector.<TouchPoint>;
		private var _touchIDs:Array;
		private var _gestureList:Vector.<BaseGesture>;
		private var _handlerList:Vector.<Function>;
		private var _isStopPropagation:Boolean;
		private var _p1:TouchPoint;
		private var _p2:TouchPoint;
		private var _distance:Number;		//记录p1与p2的距离
		
		/**
		 * 对象与手势的联系
		 * @param o	要注册手势的对象
		 */
		public function TouchManager(o:InteractiveObject)
		{
			_touchIDs = [];
			_blobs = new Vector.<TouchPoint>();
			_gestureList = new Vector.<BaseGesture>();
			_handlerList = new Vector.<Function>();
			
			init(o);
		}
		
		private function init(o:InteractiveObject):void
		{
			removeEventListeners();
			_obj = o;
			_obj.addEventListener(TouchEvent.TOUCH_BEGIN, TouchDown, false, 0, true);
			_obj.addEventListener(TouchEvent.TOUCH_MOVE, TouchMove, false, 0, true);
			_obj.addEventListener(TouchEvent.TOUCH_END, TouchUp, false, 0, true);
			_obj.addEventListener(TouchEvent.TOUCH_ROLL_OUT, TouchRollOut, false, 0, true);
		}
		
		
		/**
		 * 添加一个触摸点
		 * @param p
		 */
		private function addBlob(p:TouchPoint):Boolean
		{
			if (touchIDs.indexOf(p.touchID) >= 0 || touchIDs.length+1 >= TouchOptions.maxTouchCount)
			{
				return false;
			}
			touchIDs.push( p.touchID );
			blobs.push(p);
			
			//确定p1,p2两个基准点
			if(touchIDs.length == 1)
			{
				_p1 = _p2 = p;
			}
			else if(touchIDs.length == 2)
			{
				_p1 = blobs[0];
				_p2 = blobs[1];
				_distance = TouchPoint.distanceStage(_p1, _p2);
			}
			else
			{
				_distance = 0;
				for(var i:int=0; i<_blobs.length-1; i++)
				{
					for(var j:int=i+1; j<_blobs.length; j++)
					{
						if(_distance<TouchPoint.distanceStage(_blobs[i],_blobs[j]))
						{
							_distance = TouchPoint.distanceStage(_blobs[i],_blobs[j]);
							_p1 = _blobs[i];
							_p2 = _blobs[j];
						}
					}
				}
//				for(var i:int=0; i<blobs.length-1; i++)
//				{
//					if(_distance < TouchPoint.distanceStage(blobs[i], blobs[blobs.length-1]))
//					{
//						_p1 = blobs[i];
//						_p2 = blobs[blobs.length-1];
//						_distance = TouchPoint.distanceStage(blobs[i], blobs[blobs.length-1]);
//					}
//				}
			}
			
			return true;
		}
		
		/**
		 * 删除一个触摸点
		 * @param touchID
		 */
		public function removeBlob(touchID:int) : void
		{
			var index:int = touchIDs.length - 1;
			while (index >= 0)
			{
				if (touchIDs[index] == touchID)
				{
					touchIDs.splice(index, 1);
					_blobs.splice(index, 1);
					break;
				}
				index -= 1;
			}
			
			//确定p1,p2两个基准点
			if(touchIDs.length == 0)
			{
				_p1 = _p2 = null;
			}
			else if(touchIDs.length == 1)
			{
				_p1 = _p2 = blobs[0];
			}
			else if(touchIDs.length == 2)
			{
				_p1 = blobs[0];
				_p2 = blobs[1];
				_distance = TouchPoint.distanceStage(_p1, _p2);
			}
			else
			{
				_distance = 0;
				for(var i:int=0; i<_blobs.length-1; i++)
				{
					for(var j:int=i+1; j<_blobs.length; j++)
					{
						if(_distance<TouchPoint.distanceStage(_blobs[i],_blobs[j]))
						{
							_distance = TouchPoint.distanceStage(_blobs[i],_blobs[j]);
							_p1 = _blobs[i];
							_p2 = _blobs[j];
						}
					}
				}
//				for(var i:int=0; i<blobs.length-1; i++)
//				{
//					if(_distance < TouchPoint.distanceStage(blobs[i], blobs[blobs.length-1]))
//					{
//						_p1 = blobs[i];
//						_p2 = blobs[blobs.length-1];
//						_distance = TouchPoint.distanceStage(blobs[i], blobs[blobs.length-1]);
//					}
//				}
			}
		}
		
		
		/**
		 * 删除所有触摸点
		 */		
		public function removeAllBlob():void
		{
			while(touchIDs.length>0)
			{
				removeBlob(touchIDs[0]);
			}
		}
		
		
		
		/**
		 * 添加一个要监听手势，如果触发手势就执行监听函数
		 * @param gesture		要监听的手势
		 * @param listenter	监听函数
		 */	
		public function addGesture(gesture:BaseGesture, listenter:Function) : void
		{
			var gesture:* = gesture;
			var listenter:* = listenter;
			_gestureList.push(gesture);
			_handlerList.push(listenter);
			gesture.init(this as TouchManager);
			if (gesture is EventGesture)
			{
				if ((gesture as EventGesture).gestureEvent != null)
				{
					try
					{
						this.obj.addEventListener((gesture as EventGesture).gestureEvent, listenter, false, 0, true);
					}
					catch (e:Error)
					{
						throw new Error(e.toString());
					}
				}
			}
		}
		
		/**
		 * 移除一个手势
		 * @param gesture
		 */		
		public function remGesture(gesture:BaseGesture) : void
		{
			var i:int = _gestureList.indexOf(gesture);
			if (i >= 0)
			{
				remGestureByIndex(i);
			}
		}
		
		/**
		 * 移除obj的所有手势
		 */		
		public function remAllGesture() : void
		{
			var leng:int = _gestureList.length - 1;
			while (leng >= 0)
			{
				remGestureByIndex(leng);
				leng = leng - 1;
			}
		}
		
		/**
		 * 根据手势的类型移出手势
		 * @param	type
		 */
		public function remGestureByType(type:Class):void
		{
			for (var i:int = 0; i < _gestureList.length; i++)
			{
				if (type == getDefinitionByName(getQualifiedClassName(_gestureList[i])))
				{
					remGestureByIndex(i);
				}
			}
		}
		
		
		/**
		 * 根据index值获得手势
		 * @param	index	是注册手势时的索引
		 * @return
		 */
		//private function getGestureAt(index:uint):BaseGesture
		//{
			//return _gestureList[index];
		//}
		
		
		/**
		 * 禁用
		 */	
		public function dispose() : void
		{
			removeEventListeners();
			if (touchIDs != null)
			{
				touchIDs.splice(0, touchIDs.length);
			}
			if (_blobs != null)
			{
				_blobs.splice(0, _blobs.length);
			}
			_touchIDs = null;
			_blobs = null;
			_obj = null;
			return;
		}
		
		/**
		 * 根据索引移除手势
		 * @param index
		 */		
		private function remGestureByIndex(index:int) : void
		{
			var baseGesture:BaseGesture = null;
			baseGesture = _gestureList[index];
			if (baseGesture != null)
			{
				if (baseGesture is EventGesture)
				{
					this.obj.removeEventListener((baseGesture as EventGesture).gestureEvent, _handlerList[index]);
				}
				baseGesture.dispose();
				_handlerList.splice(index, 1);
				_gestureList.splice(index, 1);
			}
		}
		
		
		/**
		 * 返回一个触摸点
		 * @param id
		 * @return 
		 */		
		public function getTouchPoint(id:Number):TouchPoint
		{
			var index:int = touchIDs.indexOf(id);
			if(index>=0)
			{
				return blobs[index];
			}
			return null;
		}
		
		
		/**
		 * 触控点按下
		 * @param e
		 */		
		private function TouchDown(e:TouchEvent):void
		{
			var touchPoint:TouchPoint = new TouchPoint(e.touchPointID, e.stageX, e.stageY, e.localX, e.localY, getTimer());
			
			if(addBlob(touchPoint))
			{
				TouchDownHandler(e);
				
				if (_isStopPropagation)
				{
					e.stopPropagation();
				}
			}
		}
		
		private function TouchDownHandler(event:TouchEvent) : void
		{
			var i:int = 0;
			while (i < _gestureList.length)
			{
				(_gestureList[i] as BaseGesture).touchDownHandler(event);
				i = i + 1;
			}
		}
		
		
		/**
		 * 触控点移动
		 * @param event
		 */		
		private function TouchMove(e:TouchEvent) : void
		{
			
			if (UpdateCaptureTouchInfor(e))
			{
				TouchMoveHandler(e);
				if (_isStopPropagation)
				{
					e.stopPropagation();
				}
			}
		}
		
		private function TouchMoveHandler(event:TouchEvent) : void
		{
			var i:int = 0;
			while (i < _gestureList.length)
			{
				(_gestureList[i] as BaseGesture).touchMoveHandler(event);
				i = i + 1;
			}
		}
		
		
		/**
		 * 触控点弹起
		 * @param event
		 */		
		private function TouchUp(event:TouchEvent) : void
		{
			if (UpdateCaptureTouchInfor(event))
			{
				this.getTouchPoint(event.touchPointID).upTime = getTimer();
				removeBlob(event.touchPointID);
				TouchUpHandler(event);
				if (_isStopPropagation)
				{
					event.stopPropagation();
				}
			}
		}
		
		private function TouchUpHandler(event:TouchEvent) : void
		{
			var index:int = 0;
			while (index < _gestureList.length)
			{
				(_gestureList[index] as BaseGesture).touchUpHandler(event);
				index = index + 1;
			}
		}
		
		
		/**
		 * 触摸滑出
		 * @param event
		 */		
		private function TouchRollOut(event:TouchEvent):void
		{
			if (UpdateCaptureTouchInfor(event))
			{
				TouchRollOutHandler(event);
			}
			if (_isStopPropagation)
			{
				event.stopPropagation();
			}
		}
		
		private function TouchRollOutHandler(event:TouchEvent):void
		{
			var index:int = 0;
			while (index < _gestureList.length)
			{
				(_gestureList[index] as BaseGesture).touchRollOutHandler(event);
				index = index + 1;
			}
		}
		
		
		
		
		/**
		 * 更新触摸点
		 * @param event
		 * @return 
		 */		
		public function UpdateCaptureTouchInfor(event:TouchEvent) : Boolean
		{
			var index:int = touchIDs.indexOf(event.touchPointID);
			var touchPoint:TouchPoint;
			if (index >= 0)
			{
				touchPoint = _blobs[index];
				touchPoint.update(event);
				//更新 p1,p2
				//updateP1P2();
				//trace(obj, _p1, _p2);
				return true;
			}
			return false;
		}
		
		
		private function updateP1P2():void
		{
			var tempDis:Number=getDistance();
			var isChange:Boolean=false;
			for(var i:int=0; i<_blobs.length-1; i++)
			{
				for(var j:int=i+1; j<_blobs.length; j++)
				{
					if(tempDis<TouchPoint.distanceStage(_blobs[i],_blobs[j]))
					{
						tempDis = TouchPoint.distanceStage(_blobs[i],_blobs[j]);
						_p1 = _blobs[i];
						_p2 = _blobs[j];
						var index:int = 0;
						while (index < _gestureList.length)
						{
							(_gestureList[index] as BaseGesture).onUpdateP1P2();
							index = index + 1;
						}
					}
				}
			}
		}
		
		
		/**
		 * 移出所有触控事件
		 */		
		private function removeEventListeners() : void
		{
			if (obj != null)
			{
				obj.removeEventListener(TouchEvent.TOUCH_BEGIN, TouchDown);
				obj.removeEventListener(TouchEvent.TOUCH_MOVE, TouchMove);
				obj.removeEventListener(TouchEvent.TOUCH_END, TouchUp);
				obj.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, TouchRollOut);
			}
			return;
		}
		
		
		/**
		 * 返回相对于舞台坐标系的中心点
		 * @param points
		 * @return 
		 */		
		public function getConterPoint():Point
		{
			return new Point((p1.stageX+p2.stageX)/2,(p1.stageY+p2.stageY)/2);
		}
		
		
		/**
		 * 当有一个触控点时，获得obj的bounds中心点，到p1的角度
		 * 当大于一个触控点时，获得p1到p2的角度
		 * 没有触控点的情况下返回NaN
		 */		
		public function getAngle():Number
		{
			var dx:Number;
			var dy:Number;
			if(_blobs.length>=2)
			{
				dx=p1.stageX - p2.stageX;
				dy=p1.stageY - p2.stageY;
				return Math.atan2(dy, dx);
			}
			else if(_blobs.length==1)
			{
				var r:Rectangle = obj.getBounds(obj.stage);
				dx=p1.stageX - (r.left+r.right)/2;
				dy=p1.stageY - (r.top+r.bottom)/2;
//				if(Math.abs(Math.atan2(dy, dx))>1)
//				{
//					trace("getAngle:", Math.atan2(dy, dx));
//				}
				return Math.atan2(dy, dx);
			}
			else
			{
				return NaN;
			}
		}
		
		/**
		 * 获得p1与p2的距离
		 */	
		public function getDistance():Number
		{
			if(_blobs.length<2)return 1;
			var dx:Number = p1.stageX - p2.stageX;
			var dy:Number = p1.stageY - p2.stageY;
			return Math.sqrt( dx*dx + dy*dy );
		}
		
		/**
		 * 返回触摸点的矩形
		 * @param points
		 * @return 
		 * 
		 */		
		public function getPointsRectangle():Rectangle
		{
			var rect:Rectangle;
			
			var top:int=int.MAX_VALUE;
			var bottom:int=int.MIN_VALUE;
			var left:int=int.MAX_VALUE;
			var right:int=int.MIN_VALUE;
			
			for(var i:int=0; i<_blobs.length; i++)
			{
				if(top>_blobs[i].stageY)
				{
					top = _blobs[i].stageY
				}
				if(bottom<_blobs[i].stageY)
				{
					bottom = _blobs[i].stageY
				}
				if(left>_blobs[i].stageX)
				{
					left = _blobs[i].stageX;
				}
				if(right<_blobs[i].stageX)
				{
					right = _blobs[i].stageX;
				}
			}
			
			rect = new Rectangle();
			rect.left = left;
			rect.right = right;
			rect.top = top;
			rect.bottom = bottom;
			return rect;
		}
		
		
		/**
		 * 很据索引值返回手势
		 * @param index
		 * @return 
		 */		
		public function getGestureAt(index:uint):BaseGesture
		{
			return gestureList[index];
		}
		
		
		/**
		 * 受触控的显示对象
		 * @return 
		 */		
		public function get obj():InteractiveObject
		{
			return _obj;
		}

		/**
		 * 存放触摸点 TouchPoint
		 */
		public function get blobs():Vector.<TouchPoint>
		{
			return _blobs;
		}

		/**
		 * 存放触摸点ID
		 */
		public function get touchIDs():Array
		{
			return _touchIDs;
		}

		/**
		 * 阻止事件流
		 * @return 
		 */		
		public function get isStopPropagation():Boolean
		{
			return _isStopPropagation;
		}
		public function set isStopPropagation(value:Boolean):void
		{
			_isStopPropagation = value;
		}

		/**
		 * 存放手势
		 */
		public function get gestureList():Vector.<BaseGesture>
		{
			return _gestureList;
		}

		/**
		 * 存放手势的监听函数
		 */
		public function get handlerList():Vector.<Function>
		{
			return _handlerList;
		}

		/**
		 * 基准点p1，p1与p2为所有触控点中距离最大的两个点。
		 */		
		public function get p1():TouchPoint
		{
			return _p1;
		}

		/**
		 * 基准点p2，p1与p2为所有触控点中距离最大的两个点。
		 */		
		public function get p2():TouchPoint
		{
			return _p2;
		}
	}
}