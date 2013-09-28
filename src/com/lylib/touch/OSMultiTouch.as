/**
 * OSMultiTouch
 * 多点触控手势框架
 * 
 * @author		刘渊
 * @version	2.0.3.2011_2_16_beta
 */
package com.lylib.touch
{
	import com.lylib.touch.gestures.BaseGesture;
	
	import flash.display.InteractiveObject;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;

	/**
	 * OSMultiTouch框架的总管理类，负责所有手势的注册、删除。
	 * 这个类不能直接实例化，通过调用getInstance()方法返回一个单例。
	 * 使用本框架时，请确保您的Flashplayer版本为10.1以上。
	 */	
	public class OSMultiTouch
	{
		static private var _instance:OSMultiTouch;
		
		/**
		 * 存放受控多点对象与他的TouchManager对应关系
		 */	
		private var objTouchManagerDict:Dictionary;
		
		
		
		public function OSMultiTouch(s:S)
		{
			objTouchManagerDict = new Dictionary();
		}
		
		
		static public function getInstance():OSMultiTouch
		{
			if(_instance==null)
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				_instance = new OSMultiTouch(new S());
			}
			return _instance;
		}
		
		
		/**
		 * 为obj注册一个手势
		 * @param obj						要注册手势的对象
		 * @param gesture					要注册的手势。手势分两种类型：<br>
		 * 									一种是EventGesture。EventGesture类型的手势在com.lylib.touch.gestures包内，它们是靠事件驱动的。当满足某个手势时，该手势就会派发对应的GestureEvent，并执行listener监听函数<br>
		 * 									另一种是Manipulators。Manipulators类型的手势在com.lylib.touch.manipulators包内，它不会派发任何事件，只会完成特定的操作，所以当注册这种类型的手势时不用写listener参数<br>
		 * @param listener				监听函数
		 * @param isStopPropagation		是否阻止事件流
		 * @return 
		 */	
		public function enableGesture(obj:InteractiveObject, gesture:BaseGesture, listener:Function = null, isStopPropagation:Boolean = true) : BaseGesture
		{
			var touchManager:TouchManager;
			if (objTouchManagerDict[obj] != null)
			{
				touchManager = objTouchManagerDict[obj];
			}
			if (touchManager == null)
			{
				touchManager = new TouchManager(obj);
				objTouchManagerDict[obj] = touchManager;
			}
			touchManager.isStopPropagation = isStopPropagation;
			touchManager.addGesture(gesture, listener);
			return gesture;
		}
		
		
		/**
		 * 禁用一个手势
		 * @param gesture		注意：gesture必须与注册时的手势实例保持一致
		 */
		public function disableGesture(gesture:BaseGesture) : void
		{
			var touchManager:TouchManager = null;
			if (gesture == null)
			{
				throw new Error("Argument Null.");
			}
			else
			{
				touchManager = gesture.manager;
				touchManager.remGesture(gesture);
				if (touchManager.gestureList.length == 0)
				{
					objTouchManagerDict[touchManager.obj] = null;
					delete objTouchManagerDict[touchManager.obj];
					touchManager.dispose();
					touchManager = null;
				}
			}
			gesture = null;
		}
		
		/**
		 * 禁用一个类型的手势
		 * @param type		要禁用手势的类型
		 */	
		public function disableGestureType(type:Class):void
		{
			var touchManager:TouchManager;
			for (var obj:Object in objTouchManagerDict) 
			{
				touchManager = objTouchManagerDict[obj];
				if (touchManager != null)
				{
					touchManager.remGestureByType(type);
					if (touchManager.gestureList.length == 0)
					{
						objTouchManagerDict[touchManager.obj] = null;
						delete objTouchManagerDict[touchManager.obj];
						touchManager.dispose();
						touchManager = null;
					}
				}
			}
		}
		
		
		/**
		 * 禁用所有手势
		 */	
		public function disableAllGesture() : void
		{
			var touchManager:TouchManager = null;
			for (var obj:Object in objTouchManagerDict) 
			{ 
				touchManager = objTouchManagerDict[obj];
				if (touchManager != null)
				{
					touchManager.remAllGesture();
					touchManager.dispose();
					touchManager = null;
				}
				objTouchManagerDict[obj] = null;
				delete objTouchManagerDict[obj];
			}
		}
		
		
		/**
		 * 禁用对象手势
		 * @param obj		禁用手势的对象
		 * @param value		如果value为null，则obj禁用已注册的所有手势<br>
		 * 					如果value是BaseGesture的实例，则obj禁用value这个手势<br>
		 * 					如果value是Class类型，则ojb禁用value这种类型的所有手势
		 */		
		public function disableObjectGesture(obj:InteractiveObject, value:Object=null):void
		{
			if (obj == null)
			{
				throw new Error("Argument Null.");
			}
			
			if(value==null)
			{
				//删除obj注册的所有手势
				disableObjectAllGesture(obj);
			}
			else if(value is Class)
			{
				//删除obj注册的此种类型的手势
				disableObjectGestureType(obj, (value as Class));
			}
			else if(value is BaseGesture)
			{
				//删除obj注册的这个手势
				disableGesture(value as BaseGesture);
			}
		}
		
		/**
		 * 禁用对象的某个类型的手势<br>
		 * 根据参数type（手势的类型），禁用obj注册过的所有同类型手势
		 * @param	obj		要禁用手势的对象
		 * @param	type	要禁用的手势类型
		 */
		public function disableObjectGestureType(obj:InteractiveObject, type:Class):void
		{
			if (obj == null)
			{
				throw new Error("Argument Null.");
			}
			
			var touchManager:TouchManager = objTouchManagerDict[obj] as TouchManager;
			
			if (touchManager != null)
			{
				touchManager.remGestureByType(type);
				
				if (touchManager.gestureList.length == 0)
				{
					objTouchManagerDict[touchManager.obj] = null;
					delete objTouchManagerDict[touchManager.obj];
					touchManager.dispose();
					touchManager = null;
				}
			}
		}
		
		/**
		 * 禁用对象的全部手势
		 * @param	obj		要禁用手势的对象
		 */
		public function disableObjectAllGesture(obj:InteractiveObject):void
		{
			if (obj == null)
			{
				throw new Error("Argument Null.");
			}
			
			var touchManager:TouchManager = objTouchManagerDict[obj] as TouchManager;
			
			if (touchManager != null)
			{
				touchManager.remAllGesture();
				
				objTouchManagerDict[touchManager.obj] = null;
				delete objTouchManagerDict[touchManager.obj];
				touchManager.dispose();
				touchManager = null;
			}
		}
		
		

		/**
		 * 获取对象注册的所有手势
		 * @param obj
		 * @return 
		 */		
		public function getGestures(obj:InteractiveObject):Vector.<BaseGesture>
		{
			var touchManager:TouchManager = objTouchManagerDict[obj] as TouchManager;
			
			if (touchManager != null)
			{
				trace(touchManager.gestureList);
				return touchManager.gestureList;
			}
			
			return null;
		}
		
		
		
		
		
		
		
		/**
		 * 返回对象上的触摸点
		 * @param obj	要禁用手势的对象
		 * @return 
		 */		
		public function getRelatedBlobs(obj:InteractiveObject):Vector.<TouchPoint>
		{
			var touchManager:TouchManager = null;
			if (objTouchManagerDict[obj] != null)
			{
				touchManager = objTouchManagerDict[obj];
				return touchManager.blobs.concat();
			}
			return null;
		}
	}
}

class S { }