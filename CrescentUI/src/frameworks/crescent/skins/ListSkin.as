package frameworks.crescent.skins
{
	import spark.skins.mobile.ListSkin;
	
	public class ListSkin extends spark.skins.mobile.ListSkin
	{
		/**
		 * Constructor
		 */
		public function ListSkin()
		{
			super();
		}
		
		/**
		 *  @private 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{   
			graphics.clear();

			// Scroller
			scroller.minViewportInset = 0;
			setElementSize(scroller, unscaledWidth, unscaledHeight);
			setElementPosition(scroller, 0, 0);			
		}
		
	}
}