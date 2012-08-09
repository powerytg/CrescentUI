package frameworks.crescent.components
{
	import frameworks.crescent.components.supportClasses.PagerIndicator;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Pager extends SkinnableComponent
	{
		/**
		 * @public
		 */
		[SkinPart]
		public var indicatorGroup:Group;
		
		/**
		 * @public
		 */
		public static const HORIZONTAL_DIRECTION:String = "horizontal";
		
		/**
		 * @public
		 */
		public static const VERTICAL_DIRECTION:String = "vertical";
		
		/**
		 * @private
		 */
		private var _direction:String;

		/**
		 * @public
		 */
		[Bindable]
		public function get direction():String
		{
			return _direction;
		}

		/**
		 * @public
		 */
		public function set direction(value:String):void
		{
			_direction = value;
		}

		
		/**
		 * @private
		 */
		private var _numItems:Number;

		/**
		 * @public
		 */
		[Bindable]
		public function get numItems():Number
		{
			return _numItems;
		}

		/**
		 * @private
		 */
		public function set numItems(value:Number):void
		{
			if(_numItems != value){
				_numItems = value;
				recreateIndicators();
			}
		}
		
		/**
		 * @private
		 */
		private var _selectedIndex:Number;

		/**
		 * @public
		 */
		[Bindable]
		public function get selectedIndex():Number
		{
			return _selectedIndex;
		}

		/**
		 * @public
		 */
		public function set selectedIndex(value:Number):void
		{
			var oldIndex:Number = _selectedIndex;
			
			selectIndicator(oldIndex, value);
			
			_selectedIndex = value;
		}
		
		/**
		 * Constructor
		 */
		public function Pager()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			if(partName == "indicatorGroup"){
				recreateIndicators();
			}
		}
		
		/**
		 * @private
		 */
		protected function recreateIndicators():void{
			if(!indicatorGroup)
				return;
			
			indicatorGroup.removeAllElements();
			
			for(var i:uint = 0; i < numItems; i++){
				var indicator:PagerIndicator = new PagerIndicator();
				indicatorGroup.addElement(indicator);
			}
		}
		
		/**
		 * @private
		 */
		protected function selectIndicator(oldIndex:Number, newIndex:Number):void{
			if(!indicatorGroup)
				return;
			
			try{
				if(oldIndex){
					var oldIndicator:PagerIndicator = indicatorGroup.getElementAt(oldIndex) as PagerIndicator;
					oldIndicator.selected = false;
				}
				
				if(newIndex){
					var newIndicator:PagerIndicator = indicatorGroup.getElementAt(newIndex) as PagerIndicator;
					newIndicator.selected = true;				
				}				
			}
			catch(e:Error){
				// Ignore
			}
		}
		
	}
}