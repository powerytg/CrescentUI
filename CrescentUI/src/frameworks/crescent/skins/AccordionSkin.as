package frameworks.crescent.skins
{
	import spark.components.Group;
	import spark.components.Scroller;
	import spark.layouts.VerticalLayout;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class AccordionSkin extends SkinnableContainerSkin
	{
		/**
		 * @private
		 */
		private var scroller:Scroller;
		
		/**
		 * Constructor
		 */
		public function AccordionSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			scroller = new Scroller();
			addChild(scroller);
			
			contentGroup = new Group();
			var contentLayout:VerticalLayout = new VerticalLayout();
			contentLayout.gap = 0;
			contentGroup.layout = contentLayout;
			
			scroller.viewport = contentGroup;
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementSize(scroller, unscaledWidth, unscaledHeight);
		}
		
		/**
		 *  @private 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{   
			// Draw nothing
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
		}
		
	}
}