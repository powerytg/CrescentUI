package frameworks.crescent.skins
{
	import frameworks.crescent.components.supportClasses.AccordionTitleBar;
	
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class AccordionTitleBarSkin extends MobileSkin
	{
		/**
		 * @public
		 */
		public var hostComponent:AccordionTitleBar;
		
		/**
		 * @private
		 */
		protected var titleDisplay:StyleableTextField;
		
		/**
		 * Constructor
		 */
		public function AccordionTitleBarSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			titleDisplay = new StyleableTextField();
			titleDisplay.selectable = false;
			titleDisplay.styleName = this;
			
			addChild(titleDisplay);
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			super.measure();
		}

		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			
			titleDisplay.text = hostComponent.title;
		}
		
		/**
		 * @protected
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			// Draw background
			graphics.clear();
			graphics.beginFill(0xff0000, 0);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.lineStyle(1, 0xffffff, 0.4);
			graphics.moveTo(0, unscaledHeight);
			graphics.lineTo(unscaledWidth, unscaledHeight);
			
			// Draw text
			titleDisplay.commitStyles();
		}
	}
}