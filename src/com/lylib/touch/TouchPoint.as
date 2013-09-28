package com.lylib.touch
{
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;


	/**
	 * 触控点，记录触控点的基本信息
	 * @author 刘渊
	 * @version	2.0.1.2011_2_11_beta
	 */	
	public class TouchPoint extends Point
	{
		
		private var _touchID:int;
		
		private var _localX:Number;
		
		private var _localY:Number;
		
		private var _downTime:Number;
		
		private var _upTime:Number;
		
		/**
		 * 触控点
		 * @param touchID		点的ID
		 * @param x			舞台坐标 X
		 * @param y			舞台坐标 y
		 * @param localX		局部坐标 x
		 * @param localY		局部坐标 y
		 */	
		public function TouchPoint(touchID:int=0, stageX:Number=0, stageY:Number=0, localX:Number=0, localY:Number=0, downTime:Number=0, upTime:Number=0)
		{
			super(stageX,stageY);
			this._touchID = touchID;
			this.localX = localX;
			this.localY = localY;
			this.downTime = downTime;
			this.upTime = upTime;
		}
		
		
		/**
		 * 获得这个触控点的副本（深度复制）
		 * @return 
		 */		
		public function getCopy():TouchPoint
		{
			var point:TouchPoint = new TouchPoint(this.touchID, this.x, this.y, this.stageX, this.stageY, this.downTime, this.upTime);
			return point;
		}
		
		
		/**
		 * 更新触控点
		 * @param o
		 */		
		public function update(o:Object):void
		{
			localX = o.localX;
			localY = o.localY;
			stageX = o.stageX;
			stageY = o.stageY;
			_touchID = o.touchPointID;
		}

		
		/**
		 * 计算两个触摸点基于舞台坐标系的距离
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		static public function distanceStage(p1:TouchPoint, p2:TouchPoint):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			return Math.sqrt( dx*dx + dy*dy );
		}
		
		
		/**
		 * 触摸点的ID
		 */
		public function get touchID():int
		{
			return _touchID;
		}



		/**
		 * 触摸点的全局舞台X坐标
		 */
		public function get stageX():Number
		{
			return x;
		}
		public function set stageX(value:Number):void
		{
			x = value;
		}

		/**
		 * 触摸点的全局舞台Y坐标
		 */
		public function get stageY():Number
		{
			return y;
		}
		public function set stageY(value:Number):void
		{
			y = value;
		}

		public function get downTime():Number
		{
			return _downTime;
		}

		public function set downTime(value:Number):void
		{
			_downTime = value;
		}

		public function get upTime():Number
		{
			return _upTime;
		}

		public function set upTime(value:Number):void
		{
			_upTime = value;
		}

		/**
		 * 按下与弹起的时间差
		 */
		public function get touchAge():Number
		{
			return _upTime - _downTime;
		}

		/**
		 * 局部坐标x
		 */		
		public function get localX():Number
		{
			return _localX;
		}
		public function set localX(value:Number):void
		{
			_localX = value;
		}

		/**
		 * 局部坐标y
		 */		
		public function get localY():Number
		{
			return _localY;
		}
		public function set localY(value:Number):void
		{
			_localY = value;
		}


	}
}