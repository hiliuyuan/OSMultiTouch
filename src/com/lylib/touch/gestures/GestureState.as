package com.lylib.touch.gestures
{
	/**
	 * 手势状态
	 * @author		刘渊
	 * @version	2.0.1.2011-02-11_beta
	 * 
	 */	
	public class GestureState
	{
		private var _value:uint;
		
		/**
		 * 手势开始
		 */		
		public static const Begin:GestureState = new GestureState(0);
		
		/**
		 * 手势结束
		 */		
		public static const End:GestureState = new GestureState(2);
		
		/**
		 * 手势正在进行中
		 */		
		public static const Progress:GestureState = new GestureState(1);
		
		
		/**
		 * 
		 * @param v	0代表Begin、1代表Progress、2代表End
		 */		
		public function GestureState(v:uint)
		{
			_value = v;
		}
		
		public function get value() : uint
		{
			return _value;
		}
		
		public function toString() : String
		{
			switch(_value)
			{
				case 0:
				{
					return "Begin";
				}
				case 1:
				{
					return "Progress";
				}
				default:
				{
					break;
				}
			}
			return "End";
		}
	}
}