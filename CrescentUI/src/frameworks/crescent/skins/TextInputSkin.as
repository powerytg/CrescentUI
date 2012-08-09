package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.SoftKeyboardEvent;
	
	import mx.core.mx_internal;
	
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.TextInputSkin;
	
	use namespace mx_internal;
	
	public class TextInputSkin extends spark.skins.mobile.TextInputSkin
	{
		/**
		 * @private
		 */
		[Embed(source='images/TextInput.png', scaleGridLeft="17", scaleGridRight="28", scaleGridTop="17", scaleGridBottom="28")]
		private var upBorderClass:Class;

		/**
		 * @private
		 */
		[Embed(source='images/TextInputFocus.png', scaleGridLeft="17", scaleGridRight="28", scaleGridTop="17", scaleGridBottom="28")]
		private var backlitBorderClass:Class;

		/**
		 * @private
		 */
		private var backlitBorder:DisplayObject;
		
		/**
		 * Constructor
		 */
		public function TextInputSkin()
		{
			super();
			borderClass = upBorderClass;
			
		}
		
		/**
		 * @private
		 */
		private function onFocusOn(evt:Event = null):void{
			border.visible = false;
			backlitBorder.visible = true;
		}

		/**
		 * @private
		 */
		private function onFocusOut(evt:Event = null):void{
			border.visible = true;
			backlitBorder.visible = false;
		}

		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			if (!border)
			{
				border = new borderClass();
				addChild(border);				
			}
			
			// Backlit border (focus border)
			backlitBorder = new backlitBorderClass();
			addChild(backlitBorder);
			backlitBorder.visible = false;
			
			if (!textDisplay)
			{
				textDisplay = StyleableTextField(createInFontContext(StyleableTextField));
				textDisplay.styleName = this;
				textDisplay.editable = true;
				textDisplay.useTightTextBounds = false;
				addChild(textDisplay);
			}
			
			textDisplay.addEventListener(FocusEvent.FOCUS_IN, onFocusOn, false, 0, true);
			textDisplay.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// position & size border
			if (border)
			{
				setElementSize(border, unscaledWidth + 16, unscaledHeight + 16);
				setElementPosition(border, -8, -8);
			}
			
			if(backlitBorder){
				setElementSize(backlitBorder, unscaledWidth + 16, unscaledHeight + 16);
				setElementPosition(backlitBorder, -8, -8);				
			}
		}
		
		/**
		 *  @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Don't draw anything here
		}

	}
}