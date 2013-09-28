package com.lylib.touch.element
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;

	[Event(type="flash.events.Event", name="change")]
	
	
	public class HorizontalSlider extends MovieClip
	{
		private var gfxSliderGrip:Sprite;
		private var gfxActiveGrip:Sprite;
		private var gfxActiveGlow:Sprite;
		public var sliderValue:Number = 0.0;
		private var _isActive:Boolean = false;
		private var gfxWidth:Number = 0;
		private var gfxHeight:Number = 0;
		private var scrollableWidth:Number;
		private var borderPixels:Number = 4;
		private var roundnessPixels:Number = 0;
		
		private var activeX:Number;
		private var activeY:Number;		
		private var indicatorText:TextField;
		
		
		public function HorizontalSlider(wd:Number, ht:Number)
		{
			gfxWidth = wd;
			gfxHeight = ht;
			gfxSliderGrip = new Sprite();
			gfxSliderGrip.graphics.beginFill(0x8C8C8C, 1);
			gfxSliderGrip.graphics.drawRoundRect(-20, -(ht/2) + borderPixels,  40, ht-borderPixels*2, roundnessPixels, roundnessPixels);
			gfxSliderGrip.y = (ht/2);
			gfxSliderGrip.graphics.endFill();
			//gfxSliderGrip.filters = [slider_Shadow];
			addChild(gfxSliderGrip);
			
			
			gfxActiveGrip = new Sprite();
			gfxActiveGrip.graphics.beginFill(0xFFFFFF, 1);
			gfxActiveGrip.graphics.drawRoundRect(-20, -(ht/2) + borderPixels, 40, ht-borderPixels*2, roundnessPixels, roundnessPixels);
			gfxActiveGrip.graphics.endFill();
			gfxSliderGrip.y = (ht/2);			
			gfxActiveGrip.visible = false;
			addChild(gfxActiveGrip);
			
			var blurfx:BlurFilter = new BlurFilter(10, 10, 1);
			
			gfxActiveGlow = new Sprite();
			gfxActiveGlow.graphics.beginFill(0xFFFFFF, 0.3);
			gfxActiveGlow.graphics.drawCircle(0,0,20);
			gfxActiveGlow.visible = false;
			
			scrollableWidth = gfxWidth - 40 - borderPixels*2;
			
			this.graphics.beginFill(0x373737, 1);
			this.graphics.drawRoundRect(0, 0, wd, ht, roundnessPixels, roundnessPixels);
			
			
			this.addEventListener(TouchEvent.TOUCH_MOVE, this.tuioMoveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.TOUCH_BEGIN, this.tuioDownEvent, false, 0, true);						
			this.addEventListener(TouchEvent.TOUCH_END, this.tuioUpEvent, false, 0, true);									
			this.addEventListener(TouchEvent.TOUCH_OVER, this.tuioRollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.TOUCH_OUT, this.tuioRollOutHandler, false, 0, true);

			updateGraphics();
		}
		
		protected function updateGraphics():void
		{
			gfxSliderGrip.y = gfxHeight/2;
			gfxSliderGrip.x = 20 + borderPixels + (scrollableWidth*sliderValue);
			
			gfxActiveGrip.y = gfxHeight/2;
			gfxActiveGrip.x = 20 + borderPixels + (scrollableWidth*sliderValue);
		}
		
		protected function sliderStartDrag():void
		{
			_isActive = true;
			gfxActiveGrip.visible = true;
		}
		
		
		protected function sliderStopDrag():void
		{
			if(_isActive)
			{
				_isActive = false;
				gfxActiveGrip.visible = false;
			}
		}		
		
		public function setValue(f:Number):void
		{
			if(f < 0)
				f = 0.0;
			if(f > 1.0)
				f = 1.0;
			sliderValue = f;
			
			updateGraphics();
		}
		
		public function getValue():Number	
		{
			return sliderValue;
		}
		
		public function getActive():Boolean
		{
			return _isActive;
		}
		

		
		public function tuioDownEvent(e:TouchEvent):void
		{		

			sliderStartDrag();			
			e.stopPropagation();
		}

		public function tuioUpEvent(e:TouchEvent):void
		{		
			sliderStopDrag();		
			//e.stopPropagation();
		}		

		public function tuioMoveHandler(e:TouchEvent):void
		{
			if(_isActive)
			{
				var localPt:Point = globalToLocal(new Point(e.stageX, e.stageY));														
				activeX = localPt.x;
				activeY = localPt.y;
				setValue(((localPt.x-20-borderPixels) / scrollableWidth));
				0
				var event:Event = new Event(Event.CHANGE);
				this.dispatchEvent(event);
			}
			trace(gfxSliderGrip.x);
			e.stopPropagation();
		}
		
		public function tuioRollOverHandler(e:TouchEvent):void
		{
			
		}
		
		public function tuioRollOutHandler(e:TouchEvent):void
		{
			e.stopPropagation();			
		}			

		public function reset():void
		{
			gfxSliderGrip.x = 24;
			gfxActiveGrip.x = 24;
		}
		
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
	}
}