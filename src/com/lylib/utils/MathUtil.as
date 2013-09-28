/**
 * MathUtil
 * 
 * @author		刘渊
 * @version	1.0.1.2010-12-28_beta
 */

package com.lylib.utils
{
	
	/**
	 * 数学工具
	 * @author 刘渊
	 */	
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		
		/**
		 * 将弧度转换成角度
		 * @param radian	弧度
		 * @return 角度
		 */		
		static public function R2D(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		
		
		/**
		 * 将角度转换成弧度
		 * @param degress		角度
		 * @return  弧度
		 */		
		static public function D2R(degress:Number):Number
		{
			return degress * Math.PI / 180;
		}
		
		
		
		/**
		 * 计算圆周运动
		 * @param centerX		圆心的x坐标
		 * @param centerY		圆心的y坐标
		 * @param radius		圆的半径
		 * @param angle		角度（弧度制）
		 * @return  			返回一个对象{x,y}
		 */		
		static public function circle(centerX:Number, centerY:Number, radius:Number, angle:Number):Object
		{
			var _x:Number = centerX + Math.cos(angle) * radius;
			var _y:Number = centerY + Math.sin(angle) * radius;
			return {x:_x, y:_y};
		}
		
		
		/**
		 * 计算椭圆运动
		 * @param centerX		圆心的x坐标
		 * @param centerY		圆心的y坐标
		 * @param radiusX		椭圆x半径
		 * @param radiusY		椭圆y半径
		 * @param angle		角度（弧度制）
		 * @return 			返回一个对象{x,y}
		 * 
		 */		
		static public function oval(centerX:Number, centerY:Number, radiusX:Number, radiusY:Number, angle:Number):Object
		{
			var _x:Number = centerX + Math.cos(angle) * radiusX;
			var _y:Number = centerY + Math.sin(angle) * radiusY;
			return {x:_x, y:_y};
		}
		
		
		
		/**
		 * 计算两点之间距离
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 */		
		static public function distance(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt( dx * dx + dy * dy );
		}
		
		
		/**
		 * 以ox，oy为原点，计算两个点的夹角，这个方法可以实行一个对象指向另一个对象
		 * 比如想实现mc的角度一直指向鼠标：
		 * mc.rotation = Trigonometry.getAngleBypoint(mc.x, mc.y, mouseX, mouseY);
		 * @param ox	原点x
		 * @param oy	原点y
		 * @param px	
		 * @param py
		 * @return 	一个角度
		 * 
		 */		
		static public function getAngleByPoint(ox:Number, oy:Number, px:Number, py:Number):Number
		{
			var dx:Number = px - ox;
			var dy:Number = py - oy;
			return R2D( Math.atan2( dy, dx ) );
		}
		
		public static function random(nMinimum:Number, nMaximum:Number=0, nRoundToInterval:Number=1):Number
		{
			if (nMinimum > nMaximum)
			{
				var nTemp:Number=nMinimum;
				nMinimum=nMaximum;
				nMaximum=nTemp;
			}
			var nDeltaRange:Number=(nMaximum - nMinimum) + (1 * nRoundToInterval);
			var nRandomNumber:Number=Math.random() * nDeltaRange;
			nRandomNumber+=nMinimum;
			return floor(nRandomNumber, nRoundToInterval);
		}

		public static function floor(nNumber:Number, nRoundToInterval:Number=1):Number
		{
			return Math.floor(nNumber / nRoundToInterval) * nRoundToInterval;
		}
	}
}