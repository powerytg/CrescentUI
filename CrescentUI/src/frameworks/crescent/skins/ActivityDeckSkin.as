package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	
	import frameworks.crescent.activity.Activity;
	import frameworks.crescent.activity.ActivityDeck;
	
	import spark.components.HGroup;
	import spark.components.Scroller;
	import spark.primitives.BitmapImage;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class ActivityDeckSkin extends SkinnableContainerSkin
	{
		/**
		 * The proxy scroller. This is what you see during the transition
		 */
		public var proxyScroller:Scroller;
		
		/**
		 * The proxy group. It holds 'proxies' of the activities. A proxy is
		 * typically a screenshot bitmap of its owner
		 */
		public var proxyGroup:HGroup;
		
		/**
		 * Constructor
		 */
		public function ActivityDeckSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			// Create proxy group
			proxyScroller = new Scroller();
			addChild(proxyScroller);
			
			proxyGroup = new HGroup();
			proxyGroup.gap = (hostComponent as ActivityDeck).gap;
			proxyScroller.viewport = proxyGroup;
			
			// Turn off vertical scrolling
			proxyScroller.setStyle("verticalScrollPolicy", "off");
			
			super.createChildren();
		}
		
		/**
		 *  @private 
		 */ 
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			
			if(currentState == "transition"){
				for(var i:uint = 0; i < contentGroup.numElements; i++){
					var proxy:BitmapImage = proxyGroup.getElementAt(i) as BitmapImage;
					proxy.visible = true;
				}
				
				contentGroup.visible = false;
			}
			else{
				for(i = 0; i < contentGroup.numElements; i++){
					var activity:Activity = contentGroup.getElementAt(i) as Activity;
					proxy = proxyGroup.getElementAt(i) as BitmapImage;
					if(activity == (hostComponent as ActivityDeck).currentActivity){
						activity.visible = true;
						proxy.visible = false;
					}
					else{
						activity.visible = false;
						proxy.visible = true;
					}
				}
				
				contentGroup.visible = true;
			}
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// Layout the proxy group and its scroller
			setElementSize(proxyScroller, unscaledWidth, unscaledHeight);
			setElementPosition(proxyScroller, 0, 0);
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
		}
	}
}