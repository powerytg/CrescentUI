package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	
	import frameworks.crescent.components.supportClasses.PagerIndicator;
	
	import mx.events.PropertyChangeEvent;
	
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class PagerIndicatorSkin extends MobileSkin
	{
		/**
		 * @private
		 */
		[Embed(source="images/PagerIndicator.png")]
		private var upFace:Class;

		/**
		 * @private
		 */
		[Embed(source="images/PagerIndicatorSelected.png")]
		private var selectedFace:Class;

		/**
		 * @private
		 */
		private var upImage:DisplayObject;
		
		/**
		 * @private
		 */
		private var selectedImage:DisplayObject;		
		
		/**
		 * @public
		 */
		public var hostComponent:PagerIndicator;
		
		/**
		 * Constructor
		 */
		public function PagerIndicatorSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 11;
			measuredHeight = 12;
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			upImage = new upFace();
			addChild(upImage);
			
			selectedImage = new selectedFace();
			addChild(selectedImage);
			selectedImage.visible = false;
			
			hostComponent.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange, false, 0, true);
		}
		
		/**
		 * @private
		 */
		protected function onPropertyChange(evt:PropertyChangeEvent):void{
			if(evt.property == "selected"){
				if(hostComponent.selected){
					selectedImage.visible = true;
					upImage.visible = false;
				}
				else{
					selectedImage.visible = false;
					upImage.visible = true;				
				}				
			}
		}
		
	}
}