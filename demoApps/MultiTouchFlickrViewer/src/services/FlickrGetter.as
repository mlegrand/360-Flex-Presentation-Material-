package services
{
	import components.RSImage;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.core.IContainer;
	import mx.rpc.http.HTTPService;

	public class FlickrGetter
	{
		
		protected var httpService:HTTPService;
		
		protected var pics:Array;
		
		protected var rest:URLLoader;
		
		protected var xmlPhotoList:XML;
		
		// public
		
		public var picStartingSize:Number = .05;
		
		public var maxNumberOfPics:Number = 50;
		
		protected var container:IContainer;
		
		
		public function FlickrGetter(cont:IContainer)
		{
			container = cont;
			pics = new Array();
		}
		
		public function getPhotos(key:String):void
		{
			var request:URLRequest = new URLRequest( "http://api.flickr.com/services/rest/" );
			var variables:URLVariables = new URLVariables();
			variables.api_key = "566c6aa058a2b4aa13f1b6ddc9bfd582";
			if(key==""){
				key = "recent";
			}
			
			if(key == "recent")
			{
				variables.method = "flickr.photos.getRecent";
			} 
			else 
			{
				variables.method = "flickr.photosets.getPhotos";
				variables.photoset_id = key;
			}
			request.data = variables;
			rest = new URLLoader();
			rest.addEventListener( Event.COMPLETE, parsePhotoList , false, 0, true);
			rest.load( request );
		}
		
		
		protected function parsePhotoList(event:Event):void
		{
			xmlPhotoList = new XML(rest.data);
			addPicsToContainer();
		}
		
		protected function addPicsToContainer():void
		{
			var id:String = null;
			var secret:String = null;
			var server:String = null;			
			var url:String = null;
			var request:URLRequest = null;
			
			if(xmlPhotoList..err.@msg.toString()!=""){
				Alert.show(xmlPhotoList..err.@msg.toString())
			}
			
			var len:int = xmlPhotoList..photo.length();
			
			if(len > maxNumberOfPics)
				len = maxNumberOfPics;
			
			for(var i:int=0; i<len; i++)
			{
				server = xmlPhotoList..photo[i].@server.toString();
				id = xmlPhotoList..photo[i].@id.toString();
				secret = xmlPhotoList..photo[i].@secret.toString();
				
				// Assemble the URL and request
				
				var photo:RSImage = new RSImage();
				photo.source = "http://static.flickr.com/" + server + "/" + id + "_" + secret + ".jpg";
				photo.name="RSImage"+i;
				photo.scaleX = picStartingSize;
				photo.scaleY = photo.scaleX;
				photo.x = (Math.random()*container.width-100);
				photo.y = (Math.random()*container.height-100);	
				photo.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEventHandler);
				photo.addEventListener(MouseEvent.MOUSE_UP, mouseUpEventHandler);
				photo.filters = [new GlowFilter(0x000000, .75, 16, 16, 2, 1, false)];	
				container.addChild(photo);
				pics.push(photo);
			}
		}
		
		protected function mouseDownEventHandler(event:MouseEvent):void
		{
			if(event.currentTarget is RSImage){
				(event.currentTarget as RSImage).startDrag()
				bringPhotoToFront(event.currentTarget as RSImage, container);
			}
		}
		
		protected function mouseUpEventHandler(event:MouseEvent):void
		{
			if(event.currentTarget is RSImage){
				(event.currentTarget as RSImage).stopDrag();
			}
		}
		
		protected function bringPhotoToFront(photo:RSImage, c:IContainer):void
		{
			c.removeChild(photo);
			c.addChild(photo);
		}
		
		public function clearPics():void
		{
			for(var i:int = 0; i<pics.length; i++)
			{
				container.removeChild(pics[i]);
			}			
			pics = new Array();
		}
		
		
		
	}
}