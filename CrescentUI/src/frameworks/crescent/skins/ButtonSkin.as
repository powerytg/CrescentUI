package frameworks.crescent.skins
{
	
	import flash.display.DisplayObject;
	
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.supportClasses.ButtonSkinBase;
	
	
	use namespace mx_internal;
	
	public class ButtonSkin extends ButtonSkinBase
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/Button.png", scaleGridLeft="10", scaleGridRight="17", scaleGridTop="8", scaleGridBottom="12")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/ButtonDown.png", scaleGridLeft="10", scaleGridRight="17", scaleGridTop="8", scaleGridBottom="12")]
		protected var downFace:Class;
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function ButtonSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutGap = 10;
					layoutPaddingLeft = 20;
					layoutPaddingRight = 20;
					layoutPaddingTop = 20;
					layoutPaddingBottom = 20;
					layoutBorderSize = 2;
					measuredDefaultWidth = 64;
					measuredDefaultHeight = 86;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutGap = 7;
					layoutPaddingLeft = 15;
					layoutPaddingRight = 15;
					layoutPaddingTop = 15;
					layoutPaddingBottom = 15;
					layoutBorderSize = 1;
					measuredDefaultWidth = 48;
					measuredDefaultHeight = 65;
					
					break;
				}
				default:
				{
					// default DPI_160
					layoutGap = 5;
					layoutPaddingLeft = 10;
					layoutPaddingRight = 10;
					layoutPaddingTop = 10;
					layoutPaddingBottom = 10;
					layoutBorderSize = 1;
					measuredDefaultWidth = 32;
					measuredDefaultHeight = 43;
					
					break;
				}
			}
			
			upBorderSkin = upFace;
			downBorderSkin = downFace;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _border:DisplayObject;
		
		private var borderClass:Class;
		
		/**
		 *  Read-only button border graphic. Use getBorderClassForCurrentState()
		 *  to specify a graphic per-state.
		 * 
		 *  @see #getBorderClassForCurrentState()
		 */
		protected function get border():DisplayObject
		{
			return _border;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Class to use for the border in the up state.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 * 
		 *  @default Button_up
		 */  
		protected var upBorderSkin:Class;
		
		/**
		 *  Class to use for the border in the down state.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 *       
		 *  @default Button_down
		 */ 
		protected var downBorderSkin:Class;
		
		private var changeFXGSkin:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			setStyle("textAlign", "center");
			
			if (borderClass)
			{
				_border = new borderClass();
				addChildAt(_border, 0);
			}
		}
		
		/**
		 *  @private 
		 */
		override protected function commitCurrentState():void
		{   
			super.commitCurrentState();
			
			borderClass = getBorderClassForCurrentState();
			
			if (!(_border is borderClass))
				changeFXGSkin = true;
			
			invalidateDisplayList();
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			if (changeFXGSkin)
			{
				changeFXGSkin = false;
				
				if (_border)
				{
					removeChild(_border);
					_border = null;
				}
				
				if (borderClass)
				{
					_border = new borderClass();
					addChildAt(_border, 0);
				}
			}
			
			setElementSize(border, unscaledWidth, unscaledHeight);
			setElementPosition(border, 0, 0);
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Do nothing
		}
		
		/**
		 *  Returns the borderClass to use based on the currentState.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 */
		protected function getBorderClassForCurrentState():Class
		{
			if (currentState == "down") 
				return downBorderSkin;
			else
				return upBorderSkin;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 */
		override protected function labelDisplay_valueCommitHandler(event:FlexEvent):void 
		{
			super.labelDisplay_valueCommitHandler(event);
		}
		
	}
}