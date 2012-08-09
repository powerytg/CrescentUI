package frameworks.crescent.skins
{
	import frameworks.crescent.components.NumericLabel;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class NumericLabelSkin extends MobileSkin
	{
		/**
		 * @public
		 */
		public var hostComponent:NumericLabel;
		
		/**
		 * @public
		 */
		public var labelDisplay:Label;
		
		/**
		 * @private
		 */
		private var labelGroup:Group;
		
		/**
		 * Constructor
		 */
		public function NumericLabelSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			labelGroup = new Group();
			addChild(labelGroup);
			
			labelDisplay = new Label();
			labelDisplay.styleName = this;
			labelDisplay.horizontalCenter = 0;
			labelDisplay.verticalCenter = 0;
			labelGroup.addElement(labelDisplay);
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			labelDisplay.text = hostComponent.text;
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			labelGroup.width = unscaledWidth;
			labelGroup.height = unscaledHeight;
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			var fillColor:Number = hostComponent.text == "0" ? 0x696969 : hostComponent.faceColor;
			
			graphics.clear();
			graphics.beginFill(fillColor);
			graphics.drawEllipse(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
	}
}