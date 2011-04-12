package panel
{
	import events.BasicPanelEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.controls.Spacer;
	
	/**
	 *  Dispatched when settings button is mouse down on.
	 *
	 *  @eventType vents.BasicPanelEvent.SHOW_SETTINGS_PANEL
	 */
	[Event(name="showSettingsPanel", type="events.BasicPanelEvent")]


	/**
	 *  Dispatched when refresh button is mouse down on.
	 *
	 *  @eventType vents.BasicPanelEvent.REFRESH_FLICKR_VIEW
	 */
	[Event(name="refreshFlickrView", type="events.BasicPanelEvent")]
	
	[Event(name="max")]

	public class BasicPanel extends TitleWindow
	{
		
		protected static const BUTTON_ALPHA:Number = 0.75;
		
		[Bindable]
		protected var closeButton:Button = new Button();
		
		[Bindable]
		protected var minButton:Button = new Button();
		
		[Bindable]
		protected var maxButton:Button = new Button();

		[Bindable]
		protected var settingsButton:Button = new Button();
		
		[Bindable]
		protected var refreshButton:Button = new Button();
		
		protected var hbox:HBox = new HBox();
		
		public function BasicPanel()
		{
			super();
			addEventListners()
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			hbox.height = 45; 
			hbox.width = 300;
			addAllButtonsToTitleBar(hbox);
			this.rawChildren.addChild(hbox as DisplayObject);
			hbox.setStyle('paddingright', 10);
			hbox.setStyle('horizontalAlign', 'right');
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			hbox.x = 0;
			hbox.width = unscaledWidth;
			hbox.y = 5;
		}
		
		protected function addAllButtonsToTitleBar(hb:HBox):void
		{
			closeButton.styleName = "closeBtnStyle";
			closeButton.alpha = BUTTON_ALPHA;
			
			var s:Spacer =new Spacer();
			s.width = 25;
			
			minButton.styleName = "minBtnStyle";
			minButton.alpha = BUTTON_ALPHA;
			/*
			
			refreshButton.styleName = "refreshBtnStyle";
			refreshButton.alpha = BUTTON_ALPHA;			
			maxButton.styleName = "maxBtnStyle";
			maxButton.alpha = BUTTON_ALPHA;
			settingsButton.styleName = "settingsBtnStyle";
			settingsButton.alpha = BUTTON_ALPHA;
			hb.addChild(refreshButton);
			hb.addChild(settingsButton);
			*/
			
			
			hb.addChild(minButton);
			hb.addChild(s);
			hb.addChild(closeButton);
		}
		
		protected function addEventListners():void
		{
			/*
			refreshButton.addEventListener(MouseEvent.MOUSE_DOWN, refreshMouseDownHandler)
			settingsButton.addEventListener(MouseEvent.MOUSE_DOWN, settingsMouseDownHandler)
			maxButton.addEventListener(MouseEvent.MOUSE_DOWN, maxMouseDownHandler);
			*/
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN, closeMouseDownHandler);
			minButton.addEventListener(MouseEvent.MOUSE_DOWN, minMouseDownHandler);
			
			hbox.addEventListener(MouseEvent.MOUSE_DOWN, headerMouseDown)
		}
		
		protected function headerMouseDown(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		
		
		protected function settingsMouseDownHandler(event:MouseEvent):void
		{
			var e:BasicPanelEvent = new BasicPanelEvent(BasicPanelEvent.SHOW_SETTINGS_PANEL);
			dispatchEvent(e);
		}
		
		protected function refreshMouseDownHandler(event:MouseEvent):void
		{
			var e:BasicPanelEvent = new BasicPanelEvent(BasicPanelEvent.REFRESH_FLICKR_VIEW);
			dispatchEvent(e);
		}
		
		protected function closeMouseDownHandler(event:MouseEvent):void
		{
			this.stage.nativeWindow.close();
		}
		
		protected function minMouseDownHandler(event:MouseEvent):void
		{
			this.stage.nativeWindow.minimize();
		}
		
		protected function maxMouseDownHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event('max'));
			this.stage.nativeWindow.maximize();
		}





		
	}
}