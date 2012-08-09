package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class WindowSkin extends SkinnableContainerSkin
	{
		/**
		 * @private
		 */
		[Embed(source='images/WindowBackground.png', scaleGridLeft=30, scaleGridRight=110, scaleGridTop=30, scaleGridBottom=110)]
		private var backgroundFace:Class;
		
		/**
		 * @private
		 */
		[Embed('images/WindowGlow.png')]
		private var glowFace:Class;
		
		/**
		 * @private
		 */
		[Embed('images/WindowHighlight.png')]
		private var highlightFace:Class;

		/**
		 * @private
		 */
		private var background:DisplayObject;

		/**
		 * @private
		 */
		private var glow:DisplayObject;

		/**
		 * @private
		 */
		private var highlight:DisplayObject;

		/**
		 * Constructor
		 */
		public function WindowSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			glow = new glowFace();
			addChild(glow);
			
			background = new backgroundFace();
			addChild(background);
			
			highlight = new highlightFace();
			addChild(highlight);
			
			super.createChildren();
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			// Draw nothing
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementPosition(glow, -160, -60);
			setElementSize(glow, unscaledWidth + 320, unscaledHeight + 120);
			
			setElementPosition(background, 0, 0);
			setElementSize(background, unscaledWidth, unscaledHeight);
			
			setElementPosition(highlight, unscaledWidth / 2 - 325, unscaledHeight - 91);
			
			setElementPosition(contentGroup, 15, 15);
			setElementSize(contentGroup, unscaledWidth - 30, unscaledHeight - 30);
			
		}
	}
}