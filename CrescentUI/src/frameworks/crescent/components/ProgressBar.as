package frameworks.crescent.components
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	
	public class ProgressBar extends UIComponent
	{
		/**
		 * @private
		 */
		private var contentGroup:Group;
		
		/**
		 * @private
		 */
		[Embed(source="../skins/images/ProgressBarTrack.png", scaleGridLeft="15", scaleGridRight="30", scaleGridTop="12", scaleGridBottom="17")]
		private var trackFace:Class;

		/**
		 * @private
		 */
		[Embed(source="../skins/images/ProgressBarHighlight.png", scaleGridLeft="15", scaleGridRight="30", scaleGridTop="10", scaleGridBottom="15")]
		private var highlightFace:Class;

		/**
		 * @private
		 */
		[Embed('../skins/images/ProgressBarPattern.png')]
		private var pattern:Class;
		
		/**
		 * @private
		 */
		private var patternBitmap:Bitmap = new pattern();

		/**
		 * @private
		 */
		private var patternGroup:Group;
		
		/**
		 * @private
		 */
		private var track:BitmapImage;

		/**
		 * @private
		 */
		private var highlight:BitmapImage;

		/**
		 * @private
		 */
		private var _min:Number = 0;
		
		/**
		 * @private
		 */
		private var _max:Number = 100;
		
		/**
		 * @private
		 */
		private var _value:Number = 0;
		
		/**
		 * Constructor
		 */
		public function ProgressBar()
		{
			super();
		}

		/**
		 * @private
		 */
		public function get value():Number
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(v:Number):void
		{
			if(_value != v){
				_value = v;
				invalidateDisplayList();
			}
		}

		/**
		 * @private
		 */
		public function get max():Number
		{
			return _max;
		}

		/**
		 * @private
		 */
		public function set max(v:Number):void
		{
			if(_max != v){
				_max = v;
				invalidateDisplayList();
			}
		}

		/**
		 * @private
		 */
		public function get min():Number
		{
			return _min;
		}

		/**
		 * @private
		 */
		public function set min(v:Number):void
		{
			if(_min != v){
				_min = v;
				invalidateDisplayList();
			}
		}

		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			contentGroup = new Group();
			addChild(contentGroup);
			
			track = new BitmapImage();
			track.source = trackFace;
			track.left = 0;
			track.right = 0;
			track.top = 0;
			track.bottom = 0;
			contentGroup.addElement(track);
			
			highlight = new BitmapImage();
			highlight.source = highlightFace;
			highlight.left = 3;
			highlight.top = 3;
			highlight.bottom = 2;
			contentGroup.addElement(highlight);
			
			patternGroup = new Group();
			patternGroup.left = highlight.left;
			patternGroup.top = 2;
			patternGroup.bottom = 5;
			contentGroup.addElement(patternGroup);
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			measuredWidth = 200;
			measuredHeight = 30;
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			try{
				contentGroup.width = unscaledWidth;
				contentGroup.height = unscaledHeight;
				
				highlight.width = (unscaledWidth - 6) * value / (max - min);
				patternGroup.width = highlight.width;
				
				// Draw a pattern
				patternGroup.graphics.clear();
				patternGroup.graphics.beginBitmapFill(patternBitmap.bitmapData);
				patternGroup.graphics.drawRoundRect(patternGroup.x, patternGroup.y, patternGroup.width, patternGroup.height, 22, 22);
				patternGroup.graphics.endFill();				
			}
			catch(e:Error){
			}
		}
		
	}
}