package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	
	import frameworks.crescent.components.supportClasses.SectionTitleBar;
	
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class SectionTitleBarSkin extends MobileSkin
	{
		/**
		 * @public
		 */
		public var hostComponent:SectionTitleBar;
		
		/**
		 * A small icon
		 */
		[Embed(source="images/Item.png")]
		private var iconFace:Class;
		
		/**
		 * @private
		 */
		private var icon:DisplayObject;
		
		/**
		 * @private
		 */
		protected var titleDisplay:StyleableTextField;
		
		/**
		 * Constructor
		 */
		public function SectionTitleBarSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// Create an icon
			icon = new iconFace();
			addChild(icon);
			
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
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			icon.x = 10;
			icon.y = unscaledHeight / 2 - 4;
			
			titleDisplay.x = 25;
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