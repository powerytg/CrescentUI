package frameworks.crescent.skins
{
	import flash.filters.GlowFilter;
	import flash.text.TextLineMetrics;
	
	import frameworks.crescent.activity.Activity;
	import frameworks.crescent.components.RedCircularButton;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.supportClasses.StyleableTextField;
	import spark.primitives.BitmapImage;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class ActivitySkin extends SkinnableContainerSkin
	{
		/**
		 * Host component
		 */
		private function get host():Activity{
			return hostComponent as Activity;
		}
		
		/**
		 * @public
		 */
		public var backgroundGroup:Group;
		
		/**
		 * Title banner
		 */
		public var titleGroup:Group;
		
		/**
		 * @private
		 */
		private var titleGroupHeight:Number = 54;
		
		/**
		 * Title action buttons (maximize, pop-out, etc.), appears right after the title
		 */
		protected var titleActionGroup:HGroup;
		
		/**
		 * Action group, which holds user specified UI widgets, appears on the right
		 */
		public var actionGroup:HGroup;
		
		/**
		 * Title label
		 */
		public var titleLabel:StyleableTextField;

		/**
		 * A triangle bitmap
		 */
		[Embed(source="images/Triangle.png")]
		protected var triangleFace:Class;
		
		/**
		 * @private
		 */
		[Embed(source="images/CloseIcon.png")]
		protected var closeIcon:Class;
		
		/**
		 * A triangle decoration, visible when there's no action buttons available 
		 */
		protected var titleDeco:BitmapImage;
		
		/**
		 * Close Button
		 */
		public var closeButton:RedCircularButton;
		
		/**
		 * Constructor
		 */
		public function ActivitySkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			// Background group
			backgroundGroup = new Group();
			addChild(backgroundGroup);

			super.createChildren();			
			
			// Create the title banner
			titleGroup = new Group();
			addChild(titleGroup);
			
			// Create title bar			
			titleLabel = StyleableTextField(createInFontContext(StyleableTextField));
			titleLabel.setStyle("fontSize", 40);
			titleLabel.setStyle("color", 0xffffff);
			titleLabel.editable = false;
			titleLabel.selectable = false;
			titleLabel.filters = [new GlowFilter(0x1a7980, 0.8, 12, 12, 2, 2)];
			titleGroup.addElement(titleLabel);
			
			// Create a title action group
			titleActionGroup = new HGroup();
			titleActionGroup.verticalAlign = "bottom";
			titleGroup.addElement(titleActionGroup);
			
			titleDeco = new BitmapImage();
			titleDeco.source = triangleFace;
			titleActionGroup.addElement(titleDeco);
			
			// Create the action group
			actionGroup = new HGroup();
			actionGroup.verticalAlign = "middle";
			actionGroup.horizontalAlign = "right";
			titleGroup.addElement(actionGroup);
			
			// Create a close button
			closeButton = new RedCircularButton();
			closeButton.setStyle("icon", closeIcon);
			titleGroup.addElement(closeButton);
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			closeButton.visible = host.canClose;
			titleLabel.text = host.title;
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			// Layout title banner first
			setElementPosition(titleGroup, 0, 0);
			setElementSize(titleGroup, unscaledWidth, titleGroupHeight);
			
			titleLabel.x = 5;
			titleLabel.verticalCenter = 0;
			
			// Calculate the splitter position
			var labelMetric:TextLineMetrics = titleLabel.getLineMetrics(0);
			
			// Layout the title action group, next to the title
			setElementPosition(titleActionGroup, labelMetric.width + 10, 0);
			titleActionGroup.height = labelMetric.height;
			
			// Layout the content group
			contentGroup.setLayoutBoundsPosition(0, titleGroupHeight + 15);
			contentGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight - titleGroupHeight - 15);
			
			// Layout the action group and close button
			if(host.actions.length == 0 || !host.canClose){
				actionGroup.right = 0;
				actionGroup.height = labelMetric.height;
			}
			else{
				actionGroup.right = 50;
				actionGroup.height = labelMetric.height;				
			}
			
			actionGroup.verticalCenter = 0;
			
			closeButton.right = 0;
			closeButton.verticalCenter = 0;
			
			// Background group
			setElementSize(backgroundGroup, unscaledWidth, unscaledHeight);
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();

			if((hostComponent as Activity).backgroundIsTransparent)
				backgroundGroup.visible = false;
			else
				backgroundGroup.visible = true;
			
			backgroundGroup.graphics.clear();
			backgroundGroup.graphics.beginFill(0, 0);
			backgroundGroup.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			backgroundGroup.graphics.endFill();
			
			// Draw a line under the title group
			titleGroup.graphics.lineStyle(1, 0x056972);
			titleGroup.graphics.moveTo(0, titleGroupHeight);
			titleGroup.graphics.lineTo(titleGroup.width, titleGroupHeight);
		}
		
	}
}