package com.lylib.touch
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * 触摸选项
	 * @author 刘渊
	 * @version	2.0.2.2011_2_14_beta
	 */	
	final public class TouchOptions
	{
		
		/**
		 * 触摸计数上限
		 */		
		static public const TOUCH_COUNT_UPPERLIMIT:uint = 10;
		
		static public var maxTouchCount:uint = 10;
		
		/**
		 * 有效触摸约束
		 */		
		public static var validTouchBound:Rectangle = new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		
		/**
		 * 版本号
		 */		
		static public const VERSION:String = "2.0.2.2011_2_14_beta";
		
		public function TouchOptions()
		{
		}
		
		public static function setMaxTouchCount(count:uint) : void
		{
			if (count <= TOUCH_COUNT_UPPERLIMIT)
			{
				maxTouchCount = count;
			}
			else
			{
				throw new Error("参数：[count]超出范围.");
			}
			return;
		}
	}
}