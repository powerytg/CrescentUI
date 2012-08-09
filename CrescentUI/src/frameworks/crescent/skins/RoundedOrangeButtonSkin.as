package frameworks.crescent.skins
{
	import mx.core.mx_internal;
	
	import spark.skins.mobile.ButtonSkin;
	
	use namespace mx_internal;
	
	public class RoundedOrangeButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/RoundedOrangeButton.png", scaleGridLeft="15", scaleGridRight="30", scaleGridTop="15", scaleGridBottom="20")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/RoundedOrangeButtonDown.png", scaleGridLeft="15", scaleGridRight="30", scaleGridTop="15", scaleGridBottom="20")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function RoundedOrangeButtonSkin()
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
		
		/**
		 * @private
		 */
		override mx_internal function layoutBorder(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementSize(border, unscaledWidth, unscaledHeight - 3);
			setElementPosition(border, 0, 3);
		}
		
	}
}