package frameworks.crescent.skins
{
	import frameworks.crescent.components.Pager;
	
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	import spark.primitives.BitmapImage;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class PagerSkin extends MobileSkin
	{
		/**
		 * @private
		 */
		public var indicatorGroup:Group;

		/**
		 * @private
		 */
		private var backgroundGroup:Group;
		
		/**
		 * @private
		 */
		private var backgroundImage:BitmapImage;
		
		/**
		 * @private
		 */
		[Embed(source="images/HorizontalPager.png", scaleGridTop="11", scaleGridLeft="12", scaleGridBottom="14", scaleGridRight="30")]
		private var hFace:Class;

		/**
		 * @private
		 */
		[Embed(source="images/VerticalPager.png", scaleGridLeft="11", scaleGridTop="12", scaleGridRight="14", scaleGridBottom="30")]
		private var vFace:Class;

		/**
		 * @private
		 */
		private var hLayout:HorizontalLayout = new HorizontalLayout();
		
		/**
		 * @private
		 */
		private var vLayout:VerticalLayout = new VerticalLayout();
		
		/**
		 * @public
		 */
		public var hostComponent:Pager;
		
		/**
		 * Constructor
		 */
		public function PagerSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			if(hostComponent.direction == "horizontal"){
				backgroundImage.source = hFace;
				indicatorGroup.layout = hLayout;
			}
			else{
				backgroundImage.source = vFace;
				indicatorGroup.layout = vLayout;
			}
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			
			var calculatedLength:Number = hostComponent.numItems * 15 + 24; 
			
			if(hostComponent.direction == "horizontal"){
				measuredWidth = calculatedLength;
				measuredHeight = 23;	
			}
			else{
				measuredWidth = 23;
				measuredHeight = calculatedLength;
			}
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			backgroundImage = new BitmapImage();
			backgroundImage.scaleMode = "stretch";
			
			backgroundGroup = new Group();
			backgroundGroup.addElement(backgroundImage);
			addChild(backgroundGroup);		
			
			indicatorGroup = new Group();
			addChild(indicatorGroup);
			
			hLayout.horizontalAlign = "center";
			hLayout.verticalAlign = "middle";
			vLayout.horizontalAlign = "center";
			vLayout.verticalAlign = "middle";
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			setElementSize(backgroundImage, unscaledWidth, unscaledHeight);
			setElementSize(indicatorGroup, unscaledWidth, unscaledHeight);
		}
		
	}
}