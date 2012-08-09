package frameworks.crescent.skins
{
	import spark.skins.mobile.ButtonSkin;
	
	/**
	 * The RedCircularButton is meant to be fixed size. The best resolution is 40 by 40
	 */
	public class RedCircularButtonSkin extends ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/RedCircularButton.png")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/RedCircularButtonDown.png")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function RedCircularButtonSkin()
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