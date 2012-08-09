package frameworks.crescent.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import spark.components.Application;
	import spark.components.SkinnableContainer;
	
	public class Window extends SkinnableContainer
	{
		/**
		 * @public
		 */
		public var drawCurtain:Boolean = true;
		
		/**
		 * @private
		 */
		protected var curtain:UIComponent;
		
		/**
		 * Constructor
		 */
		public function Window()
		{
			super();
		}
		
		/**
		 * @public
		 */
		public function popOut():void{
			var stageWidth:Number = (FlexGlobals.topLevelApplication as Application).width;
			var stageHeight:Number = (FlexGlobals.topLevelApplication as Application).height;

			// Create a curtain
			if(drawCurtain){
				curtain = new UIComponent();
				curtain.width = stageWidth;
				curtain.height = stageHeight;
				curtain.graphics.beginFill(0x000000, 0.8);
				curtain.graphics.drawRect(0, 0, stageWidth, stageHeight);
				curtain.graphics.endFill();
				
				PopUpManager.addPopUp(curtain, FlexGlobals.topLevelApplication as DisplayObject, true);				
			}
			
			// Create the window
			PopUpManager.addPopUp(this, FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(this);
		}
		
		/**
		 * @public
		 */
		public function close():void{
			PopUpManager.removePopUp(this);
			
			if(curtain){
				PopUpManager.removePopUp(curtain);
			}
		}
	}
}