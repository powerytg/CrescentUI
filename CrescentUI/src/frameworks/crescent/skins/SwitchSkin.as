package frameworks.crescent.skins
{
	import frameworks.crescent.components.Switch;
	
	import mx.events.EffectEvent;
	
	import spark.components.Group;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.primitives.BitmapImage;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class SwitchSkin extends MobileSkin
	{
		/**
		 * @public
		 */
		public var hostComponent:Switch;
		
		/**
		 * @private
		 */
		[Embed('images/SwitchThumb.png')]
		private var normalThumbFace:Class;

		/**
		 * @private
		 */
		[Embed('images/SwitchThumbSelected.png')]
		private var selectedThumbFace:Class;

		/**
		 * @private
		 */
		[Embed('images/SwitchTrack.png')]
		private var normalTrackFace:Class;
		
		/**
		 * @private
		 */
		[Embed('images/SwitchTrackSelected.png')]
		private var selectedTrackFace:Class;

		/**
		 * @private
		 */
		private var layoutGroup:Group;
		
		/**
		 * @private
		 */
		private var track:BitmapImage;
		
		/**
		 * @private
		 */
		private var thumb:BitmapImage;
		
		/**
		 * @private
		 */
		private var moving:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function SwitchSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 135;
			measuredHeight = 51;
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			layoutGroup = new Group();
			addChild(layoutGroup);
			
			track = new BitmapImage();
			layoutGroup.addElement(track);
			
			thumb = new BitmapImage();
			layoutGroup.addElement(thumb);
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementSize(layoutGroup, 135, 51);
			track.verticalCenter = 0;
			track.horizontalCenter = 0;
			
			thumb.verticalCenter = 0;
			if(!moving){
				if(hostComponent.currentState == "selected"){
					thumb.x = 0;
				}
				else if(hostComponent.currentState == "normal"){
					thumb.x = 84;
				}				
			}
		}
		
		/**
		 * @private
		 */
		override protected function commitCurrentState():void{
			super.commitCurrentState();
			
			if(currentState != null){
				var animate:Animate = new Animate(thumb);
				var mp:SimpleMotionPath = new SimpleMotionPath("x");
				animate.motionPaths = Vector.<MotionPath>([mp]);
				if(currentState == "selected"){
					mp.valueTo = 0;
					thumb.source = selectedThumbFace;
					track.source = selectedTrackFace;
				}
				else{
					mp.valueTo = 84;
					thumb.source = normalThumbFace;
					track.source = normalTrackFace;
				}
				
				moving = true;
				animate.addEventListener(EffectEvent.EFFECT_END, onEffectEnd, false, 0, true);
				animate.play();
			}
		}
		
		/**
		 * @private
		 */
		private function onEffectEnd(evt:EffectEvent):void{
			moving = false;
		}
		
	}
}