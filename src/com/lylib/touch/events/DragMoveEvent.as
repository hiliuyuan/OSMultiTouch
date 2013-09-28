package com.lylib.touch.events
{
	/**
	 * 拖拽移动手势事件
	 * 
	 * @author		刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */
	public class DragMoveEvent extends BaseGestureEvent
	{
		
		static public const DRAG_MOVE:String = "drag_move";
		
		private var _deltaOffsetX:Number;
		private var _deltaOffsetY:Number;
		
		/**
		 * @param type				事件类型
		 * @param deltaOffsetX	x方向偏移量
		 * @param deltaOffsetY	y方向偏移量
		 */		
		public function DragMoveEvent(type:String, deltaOffsetX:Number=0, deltaOffsetY:Number=0)
		{
			this._deltaOffsetX = deltaOffsetX;
			this._deltaOffsetY = deltaOffsetY;
			
			super(type);
		}

		
		
		
		
		/**
		 * x方向偏移量
		 */		
		public function get deltaOffsetX():Number
		{
			return _deltaOffsetX;
		}
		public function set deltaOffsetX(value:Number):void
		{
			_deltaOffsetX = value;
		}

		/**
		 * y方向偏移量
		 */	
		public function get deltaOffsetY():Number
		{
			return _deltaOffsetY;
		}
		public function set deltaOffsetY(value:Number):void
		{
			_deltaOffsetY = value;
		}


	}
}