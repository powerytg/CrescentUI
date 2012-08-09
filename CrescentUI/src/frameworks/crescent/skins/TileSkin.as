package frameworks.crescent.skins
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import frameworks.crescent.components.Tile;
	
	import mx.utils.ColorUtil;
	
	import spark.components.Group;
	import spark.skins.mobile.SkinnableContainerSkin;
	
	/**
	 * Normal state
	 */
	[SkinState("up")]
	
	/**
	 * Selected state
	 */
	[SkinState("down")]
	
	public class TileSkin extends SkinnableContainerSkin
	{
		
		/**
		 * Shadow
		 */
		[Embed(source='images/TileShadow.png', scaleGridLeft=10, scaleGridRight=30, scaleGridTop=10, scaleGridBottom=20)]
		private var shadowFace:Class;
		
		/**
		 * @private
		 */
		private var shadow:DisplayObject;
		
		/**
		 * Background
		 */
		public var backgroundGroup:Group;
		
		/**
		 * Constructor
		 */
		public function TileSkin()
		{
			super();
			
			// By default, we enable bitmap caching for this component
			cacheAsBitmap = true;
		}
		
		/**
		 *  @private 
		 */ 
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			invalidateDisplayList();
		}
		
		/**
		 *  @private 
		 */ 
		override protected function createChildren():void
		{     
			// Create a shadow
			shadow = new shadowFace();
			addChild(shadow);

			// Create a background
			backgroundGroup = new Group();
			addChild(backgroundGroup);

			// Create content group
			contentGroup = new Group();
			contentGroup.id = "contentGroup";
			
			addChild(contentGroup);
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			setElementPosition(shadow, -7, -5);
			setElementSize(shadow, unscaledWidth + 15, unscaledHeight + 14);
			
			// Setup background group
			setElementPosition(backgroundGroup, 0, 0);
			setElementSize(backgroundGroup, unscaledWidth, unscaledHeight);
			
			// Content
			setElementPosition(contentGroup, 5, 5);
			setElementSize(contentGroup, unscaledWidth - 10, unscaledHeight - 10);
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			var host:Tile = hostComponent as Tile;
			
			// Calculate the start and end color
			var startColor:Number;
			
			if(currentState == "up"){
				startColor = host.faceColor;
			}
			else{
				startColor = ColorUtil.adjustBrightness(host.faceColor, 30);
			}
			
			var endColor:Number = ColorUtil.adjustBrightness(startColor, -30);
			var strokeColor:Number = ColorUtil.adjustBrightness(endColor, -80);
			
			// Draw a base tile
			if(backgroundGroup){
				var g:Graphics = graphics;
				var m:Matrix = new Matrix();
				m.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 4);
				g.clear();
				g.beginGradientFill(GradientType.LINEAR, [startColor, endColor], [1, 1], [0, 255], m);
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
				
				// Draw 3D effects
				g.lineStyle(1, strokeColor);
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.lineStyle(1, 0xffffff, 0.4);
				g.drawRect(1, 1, unscaledWidth - 2, unscaledHeight - 2);
			}
			
			// Adjust shadow color
			if(shadow){
				if(currentState == "up"){
					shadow.transform.colorTransform = new ColorTransform();
				}
				else{
					var c:ColorTransform = new ColorTransform();
					
					if(host.glowColor == -1)
						c.color = startColor;
					else
						c.color = host.glowColor;
					
					shadow.transform.colorTransform = c;
				}								
			}
			
		}

	}
}