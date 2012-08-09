package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class SocketGroupSkin extends SkinnableContainerSkin
	{
		/**
		 * Shadow
		 */
		[Embed(source='images/SocketGroup.png', scaleGridLeft=30, scaleGridRight=90, scaleGridTop=23, scaleGridBottom=28)]
		private var backgroundFace:Class;
		
		/**
		 * @private
		 */
		private var background:DisplayObject;
		
		/**
		 * Constructor
		 */
		public function SocketGroupSkin()
		{
			super();
		}
		
		/**
		 *  @private 
		 */ 
		override protected function createChildren():void
		{     
			// Create a shadow
			background = new backgroundFace();
			addChild(background);
			
			super.createChildren();
			
			contentGroup.clipAndEnableScrolling = true;
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementPosition(background, 0, 0);
			setElementSize(background, unscaledWidth, unscaledHeight);
			
			// Setup background group
			setElementPosition(contentGroup, 9, 8);
			setElementSize(contentGroup, unscaledWidth - 18, unscaledHeight - 16);
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			// Draw nothing
		}
		
	}
}