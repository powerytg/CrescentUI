package frameworks.crescent.skins
{
	import spark.skins.mobile.ButtonSkin;
	
	public class RedButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/RedButton.png", scaleGridLeft="10", scaleGridRight="17", scaleGridTop="8", scaleGridBottom="12")]
		protected var upFace:Class;

		/**
		 * Down skin
		 */
		[Embed(source="images/RedButtonDown.png", scaleGridLeft="10", scaleGridRight="17", scaleGridTop="8", scaleGridBottom="12")]
		protected var downFace:Class;

		/**
		 * Constructor
		 */
		public function RedButtonSkin()
		{
			super();
			upBorderSkin = upFace;
			downBorderSkin = downFace;
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Draw nothing
		}
	}
}