package frameworks.crescent.skins
{
	import spark.skins.mobile.RadioButtonSkin;
	
	public class RadioButtonSkin extends spark.skins.mobile.RadioButtonSkin
	{
		/**
		 * @private
		 */
		[Embed('images/RadioButton.png')]
		private var upFace:Class;

		/**
		 * @private
		 */
		[Embed('images/RadioButtonDown.png')]
		private var downFace:Class;

		/**
		 * Constructor
		 */
		public function RadioButtonSkin()
		{
			super();
			
			upIconClass = upFace;
			upSelectedIconClass = downFace;
			downIconClass = downFace;
			downSelectedIconClass = downFace;
			
			upSymbolIconClass =  null;
			downSymbolIconClass =  null;
			upSymbolIconSelectedClass = null;
			downSymbolIconSelectedClass = null;
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
		}
		
	}
}