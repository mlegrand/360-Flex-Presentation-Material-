package com.derschmale.utils
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.events.EventDispatcher;
	import flash.events.ShaderEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @author David Lenaerts ( http://www.derschmale.com )
	 */
	public class PBImageMapper extends EventDispatcher
	{
		[Embed(source="/../shaders/BitmapDataToByteArray.pbj", mimeType="application/octet-stream")]
		private var BitmapDataToByteArrayKernel : Class;
		
		[Embed(source="/../shaders/ByteArrayToBitmapData.pbj", mimeType="application/octet-stream")]
		private var ByteArrayToBitmapDataKernel : Class;
		
		// Vector(x, y)+Scalar combo
		[Embed(source="/../shaders/BitmapDataToByteArrayVVS.pbj", mimeType="application/octet-stream")]
		private var BitmapDataToByteArrayVVSKernel : Class;
		
		// Vector(x, y)+Scalar combo
		[Embed(source="/../shaders/ByteArrayToBitmapDataVVS.pbj", mimeType="application/octet-stream")]
		private var ByteArrayToBitmapDataVVSKernel : Class;
		
		private var _toByteArray : Shader;
		private var _toBitmapData : Shader;
		private var _toByteArrayVVS : Shader;
		private var _toBitmapDataVVS : Shader;
				
		public function PBImageMapper()
		{
			super();
			_toByteArray = new Shader(new BitmapDataToByteArrayKernel());
			_toBitmapData = new Shader(new ByteArrayToBitmapDataKernel());
			_toByteArrayVVS = new Shader(new BitmapDataToByteArrayVVSKernel());
			_toBitmapDataVVS = new Shader(new ByteArrayToBitmapDataVVSKernel());
		}
		
		// converts a BitmapData object to a ByteArray
		// different from getPixels in data format
		public function toByteArray(bitmapData : BitmapData, channels : int = 7) : ByteArray
		{
			var ba : ByteArray = new ByteArray();
			var shaderJob : ShaderJob = new ShaderJob(_toByteArray, ba, bitmapData.width, bitmapData.height);
			ba.endian = Endian.LITTLE_ENDIAN;
			_toByteArray.data.src.input = bitmapData;
			
			if (channels & BitmapDataChannel.RED) _toByteArray.data.r.value = [ 1 ];
			else _toByteArray.data.r.value = [ 0 ];
			
			if (channels & BitmapDataChannel.GREEN) _toByteArray.data.g.value = [ 1 ];
			else _toByteArray.data.g.value = [ 0 ];
			
			if (channels & BitmapDataChannel.BLUE) _toByteArray.data.b.value = [ 1 ];
			else _toByteArray.data.b.value = [ 0 ];
			
			shaderJob.addEventListener(ShaderEvent.COMPLETE, handleComplete);
			shaderJob.start();
			
			return ba;
		}
		
		// converts a ByteArray object to a BitmapData
		// different from setPixels in data format
		public function toBitmapData(byteArray : ByteArray, bitmapData : BitmapData) : void
		{
			var shaderJob : ShaderJob = new ShaderJob(_toBitmapData, bitmapData, bitmapData.width, bitmapData.height);
			byteArray.position = 0;
			_toBitmapData.data.src.input = byteArray;
			_toBitmapData.data.src.width = bitmapData.width;
			_toBitmapData.data.src.height = bitmapData.height;
			shaderJob.addEventListener(ShaderEvent.COMPLETE, handleComplete);
			shaderJob.start();
		} 
		
		// converts a BitmapData object to a ByteArray
		// where r and g contain vector coordinates between -1 and 1, and b a vector from 0 to 1
		public function toByteArrayVVS(bitmapData : BitmapData) : ByteArray
		{
			var ba : ByteArray = new ByteArray();
			var shaderJob : ShaderJob = new ShaderJob(_toByteArrayVVS, ba, bitmapData.width, bitmapData.height);
			ba.endian = Endian.LITTLE_ENDIAN;
			
			_toByteArrayVVS.data.src.input = bitmapData;
			
			shaderJob.start(true);
			
			return ba;
		}
		
		// converts a ByteArray object to a BitmapData
		// where r and g contain vector coordinates between -1 and 1, and b a vector from 0 to 1
		public function toBitmapDataVVS(byteArray : ByteArray, bitmapData : BitmapData) : void
		{
			var shaderJob : ShaderJob = new ShaderJob(_toBitmapDataVVS, bitmapData, bitmapData.width, bitmapData.height);
			byteArray.position = 0;
			_toBitmapDataVVS.data.src.input = byteArray;
			_toBitmapDataVVS.data.src.width = bitmapData.width;
			_toBitmapDataVVS.data.src.height = bitmapData.height;
			shaderJob.start(true);
		}
		
		private function handleComplete(event : ShaderEvent) : void
		{
			event.target.removeEventListener(event, handleComplete);
			dispatchEvent(event);
		}
	}
}