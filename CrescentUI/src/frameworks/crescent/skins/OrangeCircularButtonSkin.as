package frameworks.crescent.skins
{
	import spark.skins.mobile.ButtonSkin;
	
	/**
	 * The RedCircularButton is meant to be fixed size. The best resolution is 40 by 40
	 */
	public class OrangeCircularButtonSkin extends ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/OrangeCircularButton.png")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/OrangeCircularButtonDown.png")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function OrangeCircularButtonSkin()
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