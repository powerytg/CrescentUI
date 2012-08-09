package frameworks.crescent.skins
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class DefaultItemRendererBackgroundSkin extends MobileSkin
	{
		/**
		 * @private
		 */
		[Embed('images/ListHighlight.png')]
		private var backlit:Class;
		
		/**
		 * @private
		 */
		private var backgroundImage:Bitmap;
		
		/**
		 * Constructor
		 */
		public function DefaultItemRendererBackgroundSkin()
		{
			super();
			this.blendMode = BlendMode.NORMAL;
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			backgroundImage = new backlit();
			addChild(backgroundImage);
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementSize(backgroundImage, unscaledWidth, unscaledHeight);
		}
			
		
	}
}