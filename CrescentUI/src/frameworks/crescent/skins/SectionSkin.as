package frameworks.crescent.skins
{
	import frameworks.crescent.components.Section;
	import frameworks.crescent.components.supportClasses.SectionTitleBar;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class SectionSkin extends SkinnableContainerSkin
	{
		/**
		 * Title bar
		 */
		public var titleBar:SectionTitleBar;
		
		/**
		 * @public
		 */
		public var actionGroup:HGroup;

		/**
		 * @public
		 */
		public var actionHolder:Group;
		
		/**
		 * Constructor
		 */
		public function SectionSkin()
		{
			super();
		}
		
		/**
		 * @protected
		 */
		override protected function createChildren():void{
			// Title bar
			titleBar = new SectionTitleBar();
			titleBar.title = (hostComponent as Section).title;
			addChild(titleBar);	

			contentGroup = new Group();
			addChild(contentGroup);			
			
			actionHolder = new Group();
			addChild(actionHolder);
			
			actionGroup = new HGroup();
			actionGroup.verticalAlign = "middle";
			actionGroup.horizontalAlign = "right";
			actionHolder.addElement(actionGroup);
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// Title bar
			setElementPosition(titleBar, 0, 0);
			setElementSize(titleBar, unscaledWidth, titleBar.measuredHeight);
			
			setElementPosition(contentGroup, 0, titleBar.measuredHeight);
			setElementSize(contentGroup, unscaledWidth, unscaledHeight - titleBar.measuredHeight);
			
			// Action group
			setElementPosition(actionHolder, unscaledWidth - actionGroup.measuredWidth, titleBar.measuredHeight / 2 - actionGroup.measuredHeight / 2);
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			measuredHeight = contentGroup.getPreferredBoundsHeight() + titleBar.getPreferredBoundsHeight();
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			
			titleBar.title = (hostComponent as Section).title;
		}
		
		/**
		 * @protected
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			// Draw notihing
		}
	}
}