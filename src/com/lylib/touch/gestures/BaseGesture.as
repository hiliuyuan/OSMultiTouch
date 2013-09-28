package com.lylib.touch.gestures
{
	import com.lylib.touch.TouchManager;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.TouchEvent;

	/**
	 * 所有手势的基类
	 * @author 刘渊
	 * @version	2.0.1.2011_2_11_beta
	 */
	public class BaseGesture
	{
		private var _manager:TouchManager;
		
		/**
		 * 手势被取消
		 */		
		protected var _isCancel:Boolean = false;
		
		
		/**
		 * 手势要求最大并发触摸点数
		 */		
		protected var _maxTouchPoints:uint=1;
		
		/**
		 * 手势要求最小并发触摸点数
		 */	
		protected var _minTouchPoints:uint=1;
		
		/**
		 * 手势规定的并发点数
		 */		
		protected var _touchPoints:uint=1;
		
		public function BaseGesture()
		{
			
		}

		/**
		 * 初始化
		 */		
		public function init(manager:TouchManager):void
		{
			_manager = manager;
		}
		
		
		/**
		 * 禁用
		 */		
		public function dispose() : void
		{
			_manager = null;
		}

		
		
		/**
		 * 触摸点按下
		 * @param event
		 */		
		public function touchDownHandler(event:TouchEvent) : void
		{
			
		}
		
		
		/**
		 * 触摸点移动
		 * @param event
		 */		
		public function touchMoveHandler(event:TouchEvent) : void
		{
			
		}
		
		
		/**
		 * 触摸点弹起
		 * @param event
		 */		
		public function touchUpHandler(event:TouchEvent) : void
		{
			
		}
		
		
		/**
		 * 触摸点滑出
		 * @param event
		 * 
		 */		
		public function touchRollOutHandler(event:TouchEvent):void
		{
			
		}
		
		
		/**
		 * 两个基准点p1,p2更新的通知函数
		 */		
		public function onUpdateP1P2():void
		{
			
		}
		
		
		
		/**
		 * 注册手势的对象
		 */
		public function get obj():InteractiveObject
		{
			if (manager != null)
			{
				return manager.obj;
			}
			return null;
		}

		public function get manager():TouchManager
		{
			return _manager;
		}


	}
}