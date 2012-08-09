package frameworks.crescent.skins
{
	import frameworks.crescent.components.AccordionSection;
	import frameworks.crescent.components.supportClasses.AccordionTitleBar;
	
	import mx.events.EffectEvent;
	
	import spark.components.Group;
	import spark.components.Scroller;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	public class AccordionSectionSkin extends SkinnableContainerSkin
	{
		/**
		 * Title bar
		 */
		public var titleBar:AccordionTitleBar;
		
		/**
		 * Scroller
		 */
		public var scroller:Scroller;
		
		/**
		 * Constructor
		 */
		public function AccordionSectionSkin()
		{
			super();
		}
		
		/**
		 * @protected
		 */
		override protected function createChildren():void{
			// Create the title bar first
			titleBar = new AccordionTitleBar();
			titleBar.title = (hostComponent as AccordionSection).title;
			addChild(titleBar);	

			contentGroup = new Group();
			contentGroup.id = "contentGroup";
			
			scroller = new Scroller();
				
			scroller.setStyle("horizontalScrollPolicy", "off");
			scroller.setStyle("verticalScrollPolicy", "off");
			scroller.viewport = contentGroup;
			addChild(scroller);
		}
		
		/**
		 * @protected
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// Title bar
			setElementPosition(titleBar, 0, 0);
			setElementSize(titleBar, unscaledWidth, titleBar.measuredHeight);
			
			// Scroller
			scroller.width = unscaledWidth;
			setElementPosition(scroller, 0, titleBar.measuredHeight);
		}
		
		/**
		 * @private
		 */
		override protected function commitCurrentState():void{
			var mp:SimpleMotionPath; 
			if(currentState == "shaded"){
				mp = new SimpleMotionPath("height", scroller.height, 0);
			}
			else if(currentState == "expanded"){
				if(contentGroup.contentHeight == 0){
					contentGroup.invalidateSize();
					contentGroup.validateNow();
				}
				
				mp = new SimpleMotionPath("height", 0, contentGroup.contentHeight);
			}
			
			var animate:Animate = new Animate(scroller);
			animate.duration = 500;
			animate.motionPaths = Vector.<MotionPath>([mp]);
			animate.play();
		}
	
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			measuredHeight = titleBar.measuredHeight + scroller.height;
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