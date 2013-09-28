package com.lylib.touch.events
{
	import com.lylib.touch.geom.Vector2D;
	
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 机械手手势事件
	 * @author 	刘渊
	 * @version	2.0.1.2011-02-11_beta
	 */	
	public class ManipulateEvent extends BaseGestureEvent
	{
		/**
		 * 机械手手势事件
		 */		
		static public const MANIPULATE:String = "manpulate";
		
		private var _deltaAngle:Number;
		private var _deltaScale:Number;
		private var _deltaVector:Vector2D;
		private var _conterPoint:Point;
		
		/**
		 * 机械手手势事件
		 * @param type				事件类型
		 * @param vector			位置的增量
		 * @param deltaScale		缩放的增量
		 * @param deltaAngle		角度的增量
		 * 
		 */		
		public function ManipulateEvent(type:String, vector:Vector2D, deltaScale:Number, deltaAngle:Number)
		{
			super(type);
			this.deltaVector = vector;
			this.deltaScale = deltaScale;
			this.deltaAngle = deltaAngle;
		}

		
		override public function clone():Event
		{
			var evt:ManipulateEvent;
			evt = new ManipulateEvent(type, this.deltaVector, this.deltaScale, this.deltaAngle);
			evt.gestureState = this.gestureState;
			return evt;
		}
		
		
		//-------------------------------- getter and setter --------------------------------//
		
		/**
		 * 角度的增量
		 */		
		public function get deltaAngle():Number
		{
			return _deltaAngle;
		}
		public function set deltaAngle(value:Number):void
		{
			_deltaAngle = value;
		}

		/**
		 * 缩放的增量
		 */		
		public function get deltaScale():Number
		{
			return _deltaScale;
		}
		public function set deltaScale(value:Number):void
		{
			_deltaScale = value;
		}

		/**
		 * 位置的增量
		 */		
		public function get deltaVector():Vector2D
		{
			return _deltaVector;
		}
		public function set deltaVector(value:Vector2D):void
		{
			_deltaVector = value;
		}

		public function get conterPoint():Point
		{
			return _conterPoint;
		}
		public function set conterPoint(value:Point):void
		{
			_conterPoint = value;
		}

	}
}