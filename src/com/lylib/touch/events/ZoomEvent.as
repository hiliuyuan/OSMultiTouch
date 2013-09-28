package com.lylib.touch.events
{
	/**
	 * 缩放手势事件,该事件由ZoomGesture派发
	 * @author 	刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */	
	public class ZoomEvent extends BaseGestureEvent
	{
		/**
		 * 缩放事件
		 */		
		static public const ZOOM:String = "zoom";
		
		private var _deltaScale:Number;
		
		/**
		 * 缩放手势事件	
		 * @param type				手势类型
		 * @param deltaScale		缩放的增量
		 */		
		public function ZoomEvent(type:String, deltaScale:Number)
		{
			super(type);
			
			_deltaScale = deltaScale;
		}

		
		/**
		 * 缩放值的增量
		 */		
		public function get deltaScale():Number
		{
			return _deltaScale;
		}
		public function set deltaScale(value:Number):void
		{
			_deltaScale = value;
		}

	}
}